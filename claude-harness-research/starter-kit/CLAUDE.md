# CLAUDE.md — 프로젝트 상시 가이드 (템플릿)

<!--
설계 원칙 (04-harness-engineering.md §6.1 근거)
- 이 파일은 "부탁"이다. 모델이 무시할 수 있다.
  공식 문서 원문: "Claude treats them as context, not enforced configuration."
  → 반드시 지켜져야 하는 것은 .claude/hooks.json 과 settings.json 의 permissions.deny 에 넣는다.
- 200줄을 넘기지 않는다. 문서 경고: "Bloated CLAUDE.md files cause Claude to ignore your actual instructions."
- @path import 는 조직화에는 도움되지만 컨텍스트를 줄이지 못한다 (launch 시 전개 로드).
- 상황별로만 필요한 절차는 여기 쓰지 말고 .claude/skills/ 로 뺀다.
출처: https://code.claude.com/docs/en/memory , https://code.claude.com/docs/en/best-practices
-->

## 1. 이 프로젝트가 무엇인가
<!-- 3줄 이내. 코드에서 유추 가능한 사실은 쓰지 않는다. -->
- 목적:
- 사용자:
- 배포 대상:

## 2. 실행/검증 명령 (정확한 명령만. 설명 금지)
| 목적 | 명령 |
|---|---|
| 설치 | `` |
| 개발 서버 | `` |
| 테스트 | `` |
| 타입체크 | `` |
| 린트 | `` |
| 빌드 | `` |

## 3. 아키텍처 (파일에서 읽어내기 어려운 것만)
<!-- 디렉터리 구조 나열 금지 — Claude가 직접 볼 수 있다. 왜 그렇게 나뉘었는지만 쓴다. -->
-

## 4. 작업 규칙

### 4.1 완료 보고는 증거로 한다
"성공했다", "동작한다" 같은 서술만으로 완료 보고하지 않는다.
- 실행한 명령과 그 **출력**을 붙인다.
- 테스트가 실패했으면 실패했다고 쓰고 출력을 붙인다.
- 건너뛴 단계가 있으면 건너뛰었다고 명시한다.
<!-- 근거(공식 권고): "Have Claude show evidence rather than asserting success: the test output,
     the command it ran and what it returned, or a screenshot of the result."
     https://code.claude.com/docs/en/best-practices -->

### 4.2 확인하지 않은 것은 확인하지 않았다고 쓴다
- 외부 사실을 인용할 때는 실제로 fetch에 성공한 URL만 근거로 쓴다.
- 확인 실패 시 `[미확인]` 으로 표기한다. 추측으로 메우지 않는다.
- 상세 절차는 `/source-verified-research` 스킬 참조.

### 4.3 변경 범위
- 요청받은 범위만 변경한다. 리팩터링을 끼워 넣지 않는다.
- 여러 파일을 건드리거나 접근법이 불확실하면 **먼저 Plan Mode** (`Shift+Tab`).
  한 문장으로 diff를 설명할 수 있으면 계획 단계를 건너뛴다.

### 4.4 커밋
- 커밋 메시지는 무엇을 왜 바꿨는지 한국어로 쓴다.
- 요청받지 않으면 push 하지 않는다. PR은 명시 요청 시에만 만든다.

## 5. 하면 안 되는 것
<!-- 아래는 hooks.json 에서도 결정론적으로 차단된다. 여기 적는 것은 '왜'를 알려주기 위함이다. -->
- `.env`, `secrets/`, `*.pem`, `credentials.json` 읽기/쓰기
- `git push --force`, `git reset --hard` (원격/공유 브랜치 대상)
- `curl ... | bash` 형태의 원격 스크립트 실행
- 프로덕션 DB에 직접 쓰기

## 6. 이 파일을 고칠 때
| 넣으려는 내용 | 실제로 넣어야 할 곳 |
|---|---|
| 예외 없이 지켜져야 하는 규칙 | `.claude/hooks.json` (PreToolUse) |
| 읽기/쓰기 금지 경로 | `.claude/settings.json` 의 `permissions.deny` |
| 가끔만 필요한 절차 | `.claude/skills/<name>/SKILL.md` |
| 대량 조사·탐색 | `.claude/agents/` 서브에이전트에 위임 |
| 항상 켜져 있어야 하는 짧은 지침 | 이 파일 |
