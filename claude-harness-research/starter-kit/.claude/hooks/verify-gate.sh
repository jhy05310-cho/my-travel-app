#!/usr/bin/env bash
# Stop / SubagentStop 검증 게이트
#
# 계약 (https://code.claude.com/docs/en/hooks 에서 확인):
#   - exit 2 => 종료 차단, 대화 계속. stderr 가 Claude 에게 에러 메시지로 전달됨
#   - exit 0 => 통과
#
# 중요 — 이 게이트의 한계 (https://code.claude.com/docs/en/best-practices 원문):
#   "a Stop hook runs your check as a script and blocks the turn from ending until it passes.
#    Claude Code overrides the hook and ends the turn after 8 consecutive blocks."
#   => 8회 연속 차단하면 harness 가 훅을 무시하고 턴을 끝낸다.
#      따라서 이 게이트는 "Claude 가 스스로 고칠 수 있는 실패"에만 걸어야 한다.
#      환경 문제·미구현 기능처럼 자동 수정이 불가능한 실패를 여기 걸면 8턴을 낭비하고 그냥 통과한다.
#
# 무한루프 방지 장치 (아래 STAMP 로직): 같은 세션에서 3회까지만 차단하고 이후 통과시킨다.
#   harness 의 8회 한도보다 먼저 스스로 멈추게 해서 토큰 낭비를 줄인다.

set -uo pipefail

INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  # 게이트를 검증할 수 없으면 통과시킨다(fail-open).
  # 보안 가드(PreToolUse)와 달리 여기서 fail-closed 하면 세션이 끝나지 못한다.
  echo "verify-gate.sh: jq 없음 — 검증 생략" >&2
  exit 0
fi

SESSION_ID="$(printf '%s' "$INPUT" | jq -r '.session_id // "unknown"')"
CWD="$(printf '%s' "$INPUT" | jq -r '.cwd // "."')"

cd "$CWD" 2>/dev/null || exit 0

MAX_BLOCKS=3
STAMP_DIR="${TMPDIR:-/tmp}/claude-verify-gate"
mkdir -p "$STAMP_DIR" 2>/dev/null || true
STAMP="$STAMP_DIR/${SESSION_ID}.count"

count() { [ -f "$STAMP" ] && cat "$STAMP" 2>/dev/null || echo 0; }
bump()  { echo $(( $(count) + 1 )) > "$STAMP"; }
reset() { rm -f "$STAMP" 2>/dev/null || true; }

block() {
  if [ "$(count)" -ge "$MAX_BLOCKS" ]; then
    echo "verify-gate: ${MAX_BLOCKS}회 연속 차단하여 게이트를 해제합니다. 아래 문제는 미해결 상태입니다:" >&2
    echo "$1" >&2
    reset
    exit 0
  fi
  bump
  {
    echo "검증 게이트 실패 — 아직 끝낼 수 없습니다."
    echo "$1"
    echo ""
    echo "위 출력을 근거로 원인을 고친 뒤 다시 시도하세요."
    echo "고칠 수 없는 문제라면, 무엇이 왜 실패했는지 사용자에게 명시적으로 보고하세요."
  } >&2
  exit 2
}

# ── 검증 1: 커밋되지 않은 문법 오류가 없는지 (프로젝트에 맞게 교체) ──────────────
# 프로젝트에 맞는 명령만 남기고 나머지는 지운다. 없는 명령은 자동으로 건너뛴다.

run_check() {
  local label="$1"; shift
  command -v "$1" >/dev/null 2>&1 || return 0
  local out
  if ! out="$("$@" 2>&1)"; then
    block "[$label] 실패 — 명령: $*
--- 출력 (마지막 40줄) ---
$(printf '%s' "$out" | tail -40)"
  fi
}

# package.json 이 있으면 스크립트 존재 여부를 보고 실행
if [ -f package.json ]; then
  has_script() { jq -e --arg s "$1" '.scripts[$s] // empty' package.json >/dev/null 2>&1; }
  has_script typecheck && run_check "typecheck" npm run --silent typecheck
  has_script lint      && run_check "lint"      npm run --silent lint
  has_script test      && run_check "test"      npm test --silent
fi

# Python 프로젝트
if [ -f pyproject.toml ] || [ -f pytest.ini ]; then
  run_check "pytest" python3 -m pytest -q
fi

# ── 검증 2: 셸 스크립트 문법 ──────────────────────────────────────────────────
if compgen -G ".claude/hooks/*.sh" >/dev/null 2>&1; then
  for f in .claude/hooks/*.sh; do
    if ! err="$(bash -n "$f" 2>&1)"; then
      block "[shell-syntax] $f 문법 오류
$err"
    fi
  done
fi

# ── 검증 3: 훅 설정 JSON 유효성 ───────────────────────────────────────────────
if [ -f .claude/hooks.json ]; then
  if ! err="$(jq empty .claude/hooks.json 2>&1)"; then
    block "[json] .claude/hooks.json 이 유효한 JSON 이 아닙니다
$err"
  fi
fi

reset
exit 0
