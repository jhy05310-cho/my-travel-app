#!/usr/bin/env bash
# PreToolUse 보안 가드 — 파일 도구(Read / Write / Edit / NotebookEdit) 전용
#
# 계약 (https://code.claude.com/docs/en/hooks 에서 확인):
#   - Read/Write/Edit 의 tool_input 은 file_path 필드를 가진다
#   - exit 2 => 도구 호출 차단, stderr 가 Claude 에게 전달
#
# 주의: permissions.deny 와 중복해서 거는 것이 정상이다.
#       hooks 는 프로젝트에 커밋되어 팀 전체에 적용되고,
#       permissions 는 settings 계층(managed > project > local)으로 강제된다.
#       둘 다 걸어야 한 쪽 설정이 빠졌을 때 구멍이 안 생긴다.

set -uo pipefail

INPUT="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  echo "guard-secrets.sh: jq 를 찾을 수 없어 경로를 검증할 수 없습니다. jq 설치 후 재시도하세요." >&2
  exit 2
fi

FILE_PATH="$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')"
TOOL="$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')"

[ -z "$FILE_PATH" ] && exit 0

BASENAME="$(basename -- "$FILE_PATH")"

deny() {
  echo "차단됨: $1" >&2
  echo "도구=$TOOL 경로=$FILE_PATH" >&2
  echo "이 파일이 정말 필요하면 사용자에게 요청하세요. 다른 경로로 우회하지 마세요." >&2
  exit 2
}

# 0) 허용 예외 — 반드시 차단 규칙보다 먼저 평가한다.
#    (.env.* 패턴이 .env.example 을 잡아버리므로 순서가 중요하다)
case "$BASENAME" in
  .env.example|.env.sample|.env.template|.env.dist)
    exit 0
    ;;
esac

# 1) 비밀정보 파일명 패턴
case "$BASENAME" in
  .env|.env.*|*.pem|*.key|id_rsa|id_rsa.*|id_ed25519|id_ed25519.*|credentials.json|.npmrc|.netrc|.pgpass)
    deny "비밀정보 파일 패턴 ($BASENAME)"
    ;;
esac

# 2) 비밀정보 디렉터리 패턴
if printf '%s' "$FILE_PATH" | grep -Eq '(^|/)(secrets|\.ssh|\.gnupg|\.aws|\.kube)(/|$)'; then
  deny "비밀정보 디렉터리 ($FILE_PATH)"
fi

# 3) 쓰기 계열만 추가 차단: 락파일 임의 수정 방지
case "$TOOL" in
  Write|Edit|NotebookEdit)
    case "$BASENAME" in
      package-lock.json|pnpm-lock.yaml|yarn.lock|poetry.lock|Cargo.lock|uv.lock)
        deny "락파일 직접 편집 ($BASENAME). 패키지 매니저 명령으로 갱신하세요"
        ;;
    esac
    ;;
esac

exit 0
