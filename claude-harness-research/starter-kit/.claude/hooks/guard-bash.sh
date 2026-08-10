#!/usr/bin/env bash
# PreToolUse 보안 가드 — Bash 전용
#
# 계약 (https://code.claude.com/docs/en/hooks 에서 확인):
#   - stdin 으로 JSON 수신. 공통 필드: session_id, cwd, hook_event_name, tool_name, tool_input, tool_use_id
#   - Bash 의 tool_input 필드: command, description, timeout, run_in_background
#   - exit 2  => 도구 호출 차단. stderr 가 Claude 에게 에러 메시지로 전달됨
#   - exit 0  => stdout 을 JSON 으로 파싱 (없으면 통상 권한 흐름)
#   - 그 외   => non-blocking. 도구는 실행됨
#
# 설계 의도: CLAUDE.md 에 적은 "하면 안 되는 것"은 모델이 무시할 수 있으므로
#            여기서 결정론적으로 막는다.

set -uo pipefail

INPUT="$(cat)"

# jq 가 없으면 가드를 신뢰할 수 없다. 통과시키지 말고 차단한다(fail-closed).
if ! command -v jq >/dev/null 2>&1; then
  echo "guard-bash.sh: jq 를 찾을 수 없어 명령을 검증할 수 없습니다. jq 설치 후 재시도하세요." >&2
  exit 2
fi

CMD="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')"

# 빈 명령이면 판단 대상 없음
[ -z "$CMD" ] && exit 0

block() {
  echo "차단됨: $1" >&2
  echo "실행하려던 명령: $CMD" >&2
  echo "정말 필요하면 사용자에게 근거를 설명하고 직접 실행을 요청하세요. 우회 시도 금지." >&2
  exit 2
}

# 1) 원격 스크립트 파이프 실행 (curl|bash, wget|sh)
if printf '%s' "$CMD" | grep -Eq '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z|k)?sh'; then
  block "원격 스크립트를 셸로 파이프하는 실행 (curl|bash 패턴)"
fi

# 2) 루트/홈 대상 재귀 삭제
if printf '%s' "$CMD" | grep -Eq 'rm[[:space:]]+(-[a-zA-Z]*[rR][a-zA-Z]*[[:space:]]+)+(-[a-zA-Z]+[[:space:]]+)*(/|~|\$HOME|/\*)([[:space:]]|$)'; then
  block "루트 또는 홈 디렉터리 대상 재귀 삭제"
fi

# 3) 파괴적 git 명령
if printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+push[[:space:]]+.*(--force([[:space:]]|$)|-f([[:space:]]|$))'; then
  # --force-with-lease 는 허용
  if ! printf '%s' "$CMD" | grep -q 'force-with-lease'; then
    block "git push --force (--force-with-lease 를 쓰거나 사용자 승인을 받으세요)"
  fi
fi
if printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+reset[[:space:]]+--hard'; then
  block "git reset --hard (되돌릴 수 없는 작업 손실)"
fi
if printf '%s' "$CMD" | grep -Eq 'git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*[fd]'; then
  block "git clean -fd (추적되지 않는 파일 영구 삭제)"
fi

# 4) 비밀정보 파일 열람/전송
if printf '%s' "$CMD" | grep -Eq '(cat|less|more|head|tail|strings|xxd|base64)[^;|&]*(\.env|\.env\.[a-zA-Z]+|id_rsa|id_ed25519|\.pem|credentials\.json|\.aws/credentials|\.npmrc|\.netrc)'; then
  block "비밀정보 파일 열람 시도"
fi

# 5) 환경변수 전체 덤프 (토큰이 그대로 컨텍스트/로그로 흘러감)
if printf '%s' "$CMD" | grep -Eq '(^|[;&|][[:space:]]*)(env|printenv|set)([[:space:]]*$|[[:space:]]*[;|&])'; then
  block "환경변수 전체 덤프 (자격증명이 전사 노출됨). 필요한 변수만 개별 참조하세요"
fi

# 6) 권한 완전 개방
if printf '%s' "$CMD" | grep -Eq 'chmod[[:space:]]+(-[a-zA-Z]+[[:space:]]+)*777'; then
  block "chmod 777"
fi

exit 0
