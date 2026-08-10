# 03 — Claude Code 최대 활용법: 6개 프리미티브와 소유권 결정

- 조사 기준일: 2026-08-11
- 출처: `code.claude.com/docs/en/*` 14개 페이지 직접 fetch
- `anthropic.com/engineering/claude-code-best-practices` 는 **EGRESS_BLOCKED** → 동일 내용의 공식 문서 `code.claude.com/docs/en/best-practices` 로 대체

---

## 1. 6개 프리미티브 비교 요약 (한 장 요약)

| 프리미티브 | 로딩 시점 | 컨텍스트 비용(공식 예시값) | 강제력 | 한 줄 정의 |
|---|---|---|---|---|
| **CLAUDE.md** | 항상 (세션 시작) | 프로젝트 ≈1,800 tok / 사용자 ≈320 tok | **없음** (advisory) | 상시 배경 지식 |
| **Skills** | description만 상시(합계 ≈450 tok), 본문은 호출 시 | 본문은 호출 시 1회 | 부분적 | 온디맨드 절차/지식 |
| **Subagents** | 스폰 시 | 메인 컨텍스트에 위임호출 ≈80 tok + 요약 ≈420 tok만 | **격리는 결정론적** | 컨텍스트 격리 워커 |
| **Slash Commands** | Skills와 동일 | Skills와 동일 | 부분적 | *Skills로 통합됨* |
| **Hooks** | 이벤트마다 실행 | `[미확인]` (주입 시 예시 100~120 tok) | **결정론적** | 라이프사이클 강제 개입 |
| **MCP + Plugins** | 세션 시작 시 연결, 스키마는 deferred | deferred 목록 ≈120 tok | 도구별 상이 | 외부 시스템 연결·배포 단위 |

> 토큰 수치 주의: 위 값은 `code.claude.com/docs/en/context-window` 의 **단일 예시 시나리오**에 나오는 값이다. 통계적 평균도, 보장 상한도 아니다. 일반화하면 안 된다.

---

## 2. 프리미티브별 상세

### 2.1 CLAUDE.md
| 항목 | 내용 |
|---|---|
| 정의 | 영속적 지침 마크다운. 시스템 프롬프트가 아니라 **사용자 메시지로 주입** |
| 경로 | 조직: `/etc/claude-code/CLAUDE.md`(Linux/WSL), `/Library/Application Support/ClaudeCode/CLAUDE.md`(macOS), `C:\Program Files\ClaudeCode\CLAUDE.md`(Win) · 사용자 `~/.claude/CLAUDE.md` · 프로젝트 `./CLAUDE.md` 또는 `./.claude/CLAUDE.md` · 로컬 `./CLAUDE.local.md` · 조건부 `.claude/rules/*.md` (YAML `paths:` frontmatter) |
| 로딩 | 상위 트리는 launch 시 전량 로드. 하위 디렉터리 CLAUDE.md는 해당 파일 읽을 때 on-demand. **`/compact` 후 루트 CLAUDE.md만 자동 재주입**, nested/path-scoped rules는 재주입 안 됨 |
| 강제력 | **없음.** 원문: *"Claude treats them as context, not enforced configuration."* 결정론적 차단이 필요하면 PreToolUse hook을 쓰라고 문서가 직접 지시 |
| 안 쓰는 게 나은 경우 | ① 자주 바뀌는 정보 ② 특정 상황에만 필요한 절차(→Skill) ③ 예외 없이 실행돼야 하는 규칙(→Hook) ④ 코드에서 유추 가능한 사실 |
| 함정 | 원문: *"Bloated CLAUDE.md files cause Claude to ignore your actual instructions."* 권장 상한 **200줄/파일**. `@path` import는 조직화에는 좋으나 **컨텍스트를 줄이지 못한다**(launch 시 전개됨) |
| 출처 | [memory](https://code.claude.com/docs/en/memory), [best-practices](https://code.claude.com/docs/en/best-practices) |

### 2.2 Skills
| 항목 | 내용 |
|---|---|
| 정의 | `SKILL.md`(YAML frontmatter + 본문). 모델이 관련성 판단 시 자동 로드하거나 `/skill-name`으로 수동 호출 |
| 경로 | `~/.claude/skills/<name>/SKILL.md` · `.claude/skills/<name>/SKILL.md` (nested 시 `apps/web:deploy` 형태 qualified name) · `<plugin>/skills/<name>/SKILL.md` |
| 로딩 | **description은 세션 내내 상시 컨텍스트**, 본문은 호출 시 로드 후 세션 내 유지(동일 내용 중복 삽입 안 함). `disable-model-invocation: true` 시 description조차 컨텍스트에 없음 |
| 제약 수치 | `description`+`when_to_use` 합계 **1,536자 truncate**. 본문 **500줄 미만 권장**. Auto-compaction 시 스킬당 최신 호출분 **5,000 tok**, 전체 재부착 예산 **25,000 tok** |
| 강제력 | 본문은 advisory. 단 `disable-model-invocation: true`는 **모델의 자동 호출을 결정론적으로 차단**. `allowed-tools`/`disallowed-tools`는 해당 턴 한정으로 도구 풀 조정(**다음 사용자 메시지에 grant 소멸** — 지속 보장 아님) |
| 안 쓰는 게 나은 경우 | ① 예외 없이 매번 실행돼야 하는 안전 규칙(→Hook) ② 대량 조사 격리(→Subagent) ③ 실시간 외부 시스템 연동(→MCP) |
| 출처 | [skills](https://code.claude.com/docs/en/skills) |

### 2.3 Subagents
| 항목 | 내용 |
|---|---|
| 정의 | 독립 컨텍스트 윈도우 + 전용 시스템 프롬프트 + 제한된 도구 접근을 가진 워커 |
| 경로 | managed settings(조직, 최우선) · `--agents` CLI flag(세션 한정) · `.claude/agents/` · `~/.claude/agents/` · `<plugin>/agents/`(최하위 우선순위) |
| 로딩 | Agent tool 호출 또는 `@agent-<name>` 멘션 시 스폰. 파일 변경은 세션 중 수 초 내 감지(단 `agents` 디렉터리 **최초 생성** 시엔 재시작 필요) |
| 컨텍스트 효과 | **서브에이전트 내부 read/분석은 메인 컨텍스트에 0 토큰.** 메인에는 위임 호출(≈80 tok)과 최종 요약(≈420 tok)만 |
| 강제력 | `tools`/`disallowedTools`로 결정론적 제한. **단 부모 세션이 `bypassPermissions`/`acceptEdits`/`auto`면 자식의 `permissionMode` override 불가** |
| 안 쓰는 게 나은 경우 | ① 부모 대화 전체 히스토리가 필요한 작업(일반 subagent는 부모 auto memory 상속 안 함, `context: fork` 예외) ② 초경량 단발 조회(스폰 오버헤드 > 이득) ③ 사용자 상호작용 필요 작업(`AskUserQuestion` 등 일부 도구가 subagent에서 제거됨) |
| 실측 (본 세션) | 리서치 에이전트 4개 소비 토큰: 114,349 / 139,664 / 112,390 / 195,790 = **합계 562,193 토큰**. 이 중 메인 컨텍스트에 들어온 것은 각 에이전트의 최종 보고서뿐 |
| 출처 | [sub-agents](https://code.claude.com/docs/en/sub-agents) |

### 2.4 Slash Commands — **이미 Skills로 통합됨**
공식 문서 원문: *"Custom commands have been merged into skills."*

| 항목 | 내용 |
|---|---|
| 현황 | `.claude/commands/<name>.md` 는 `.claude/skills/<name>/SKILL.md` 와 **동일하게** `/<name>` 커맨드를 생성하고 동일하게 동작. 이름 충돌 시 **skill이 command보다 우선** |
| 권고 | 신규는 skill 디렉터리 구조로 작성. commands는 호환 유지 목적 |
| 안 쓰는 게 나은 경우 | 지원 파일·`context: fork`·확장 frontmatter가 필요하면 commands 대신 skill 구조 |
| 출처 | [skills](https://code.claude.com/docs/en/skills) (`/docs/en/slash-commands` 는 이 페이지로 통합 반환됨) |

### 2.5 Hooks
| 항목 | 내용 |
|---|---|
| 정의 | 생명주기 이벤트에 자동 실행되는 쉘 명령/HTTP/MCP tool/prompt/agent. 원문: *"gives you deterministic control: certain actions always happen rather than relying on the LLM to choose to run them"* |
| 경로 | `~/.claude/settings.json` · `.claude/settings.json`(git 공유) · `.claude/settings.local.json`(gitignore) · managed policy settings · 플러그인 `hooks/hooks.json` · skill/agent frontmatter의 `hooks` 필드 |
| 강제력 | **결정론적.** exit code 2로 이벤트별 차단. 원문: *"Settings rules are enforced by the client regardless of what Claude decides to do."* |
| 기본 timeout | 600초 |
| 안 쓰는 게 나은 경우 | ① 유연한 판단이 필요한 결정 ② 매번 큰 지연을 유발하는 무거운 작업 ③ 단순 안내로 충분한 경우(과잉 엔지니어링) |
| 출처 | [hooks](https://code.claude.com/docs/en/hooks), [hooks-guide](https://code.claude.com/docs/en/hooks-guide) |

### 2.6 MCP + Plugins
| 항목 | 내용 |
|---|---|
| MCP 스코프 | Local: `~/.claude.json`(프로젝트별, 기본, 비공유) · Project: `.mcp.json`(git 공유, **세션마다 승인 필요**) · User: `~/.claude.json`(전체 프로젝트, 개인) |
| MCP 로딩 | 세션 시작 시 연결 시도. 원격 HTTP/SSE는 v2.1.221+부터 이전 세션 tool list를 캐시(`cached` 상태) 후 첫 호출 시 실제 연결. **tool 스키마는 기본 deferred** (ToolSearch로 온디맨드 로드) |
| MCP 출력 제한 | 기본 **25,000 토큰**, 10,000 초과 시 경고. `MAX_MCP_OUTPUT_TOKENS`로 조정 |
| Plugin 구조 | 루트에 `.claude-plugin/plugin.json`, 구성요소는 `skills/`, `agents/`, `hooks/hooks.json`, `.mcp.json`, `.lsp.json`, `monitors/monitors.json`, `bin/`, `settings.json` |
| Plugin 로딩 | 세션 시작 시 활성 플러그인의 모든 구성요소 자동 로드. 변경 후 `/reload-plugins` 필요 |
| 보안 제약 | **플러그인 agent는 `hooks`/`mcpServers`/`permissionMode` frontmatter가 무시된다** (권한 상승 방지). MCP tool도 permission 시스템 대상. `requiresUserInteraction` 메타 도구는 auto/bypassPermissions/dontAsk 모드에서도 **항상 프롬프트** |
| 안 쓰는 게 나은 경우 | MCP: 신뢰 안 되는 서버(문서에 prompt injection 위험 명시), 1회성 조회. Plugin: 공유/버전관리 불필요한 개인 실험(→standalone `.claude/`) |
| 출처 | [mcp](https://code.claude.com/docs/en/mcp), [plugins](https://code.claude.com/docs/en/plugins) |

---

## 3. 【핵심 산출물】 소유권 결정 표 — 어떤 요구사항을 어느 레이어가 소유하는가

| 요구사항 유형 | 예시 | **소유 레이어** | 이유 | 잘못 선택하면 생기는 실패 |
|---|---|---|---|---|
| **규칙 강제** (예외 없이) | "커밋 전 항상 lint", "`migrations/` 쓰기 금지" | **Hooks** (`PreToolUse`, exit 2) | 결정론적. 도구 호출 자체를 차단 | CLAUDE.md에만 적으면 advisory → 컨텍스트가 길어지면 모델이 조용히 건너뜀 |
| **비밀정보 차단** | `.env`, `secrets/**` | **settings `permissions.deny`** (가능하면 managed) | *"deny: Operations explicitly blocked (takes precedence over allow)"* — 클라이언트가 강제 | CLAUDE.md 서술 → prompt injection·실수로 우회. skill `disallowed-tools`만 → **다음 사용자 메시지에 grant 소멸**하여 지속 보장 안 됨 |
| **맥락 지식** (알아야 하나 실행은 불필요) | 아키텍처, 코딩 컨벤션 | **CLAUDE.md**(짧고 보편적) 또는 **Skill**(도메인 특화) | 보편 지식은 상시, 특수 지식은 온디맨드로 컨텍스트 절약 | 전부 CLAUDE.md → 200줄 초과 → 준수율 하락 |
| **위임 경계** (격리 후 요약만) | 대형 코드베이스 탐색, 로그/테스트 대량 출력 | **Subagents** | 내부 토큰이 메인 컨텍스트에 0으로 반영 | 메인에서 직접 대량 read → 컨텍스트 소진, 장문 세션 성능 저하 |
| **상시 가이드** | 코드 스타일, "typecheck 하고 마무리" | **CLAUDE.md** | 트리거 조건 없이 항상 적용 | Skill로 만들면 description 매칭 실패 시 지침이 **로드조차 안 됨** |
| **외부 시스템 접근** | GitHub PR, Postgres, Sentry | **MCP** | OAuth·재연결·타임아웃 표준화 | Bash curl 즉석 스크립트 → 인증/에러처리 재발명, credential이 프롬프트·로그에 노출 |
| **반복 워크플로 호출** (사용자 트리거) | `/deploy`, `/fix-issue 123` | **Skills** + `disable-model-invocation: true` | `$ARGUMENTS` 지원. 사이드이펙트 작업은 사용자만 트리거하도록 강제 | CLAUDE.md에 절차 서술 → 컨텍스트 낭비 + 모델이 조건 판단 없이 자동 실행 시도 |

### 3.1 판정 알고리즘 (3문항)
1. **"모델이 안 지켜도 되는가?"** → 아니오면 **Hooks / permissions**. (문서·스킬은 전부 advisory다)
2. **"항상 필요한가, 가끔 필요한가?"** → 항상=CLAUDE.md, 가끔=Skill
3. **"중간 산출물이 큰가?"** → 크면 Subagent로 격리

---

## 4. 검증 루프 설계

### 4.1 Plan Mode
| 항목 | 내용 |
|---|---|
| 동작 | 파일 읽기·탐색·계획만 수행, 승인 전까지 소스 편집 차단 (`bypassPermissions` 세션은 예외) |
| 진입 | `Shift+Tab` 순환(`default → acceptEdits → plan`) · 프롬프트 앞 `/plan` 접두어 · `claude --permission-mode plan` |
| 계획 편집 | `Ctrl+G` 로 텍스트 에디터에서 직접 수정 |
| 승인 선택지 | "Yes, and use auto mode" / "Yes, manually approve edits" / "No, keep planning" |
| 언제 쓰나 (원문) | *"Planning is most useful when you're uncertain about the approach, when the change modifies multiple files, or when you're unfamiliar with the code being modified. If you could describe the diff in one sentence, skip the plan."* |
| 출처 | [permission-modes](https://code.claude.com/docs/en/permission-modes), [best-practices](https://code.claude.com/docs/en/best-practices) |

### 4.2 Stop hook 게이트
| 항목 | 내용 |
|---|---|
| 이벤트명 | `Stop` (메인 대화 종료 시), `SubagentStop` (서브에이전트 종료 시). **subagent frontmatter의 `Stop` 훅은 런타임에 자동으로 `SubagentStop`으로 변환됨** |
| exit 2 | 종료 차단, 대화 계속. **stderr가 Claude에게 에러 메시지로 전달됨** → 여기에 무엇을 고쳐야 하는지 써야 함 |
| exit 0 | stdout을 JSON으로 파싱: `{"decision":"block","reason":"...","hookSpecificOutput":{"hookEventName":"Stop","additionalContext":"..."}}` |
| 그 외 exit | non-blocking, stderr 첫 줄만 표시 |
| 최소 예시 | `if ! npm test; then echo "Tests failing" >&2; exit 2; fi` |
| **무한루프 방지** | best-practices 원문: *"Claude Code overrides the hook and ends the turn after 8 consecutive blocks."* → **게이트는 8회까지만 유효.** 자동 수정 불가능한 실패를 Stop hook으로 막으면 8턴 낭비 후 그냥 통과됨 |
| 주의 | 이 "8회" 임계치는 `best-practices` 한 곳에서만 확인됨. `hooks` 레퍼런스에는 없음 → 버전·모드별 동일 적용 여부 `[미확인]` |
| **교차검증 이력** | 레드팀이 *"hooks 문서에 없으므로 창작된 수치일 가능성"* 이라고 반박 → **필자가 `best-practices` 원문을 직접 재fetch하여 문장 실재를 확인, 레드팀 반박을 기각.** 확인된 원문: *"a Stop hook runs your check as a script and blocks the turn from ending until it passes. Claude Code overrides the hook and ends the turn after 8 consecutive blocks."* 단 "hooks 레퍼런스에는 없다"는 레드팀 지적 자체는 맞다 |

### 4.3 검증 전용 서브에이전트 (작성자/검증자 분리)
- 문서 근거 (원문): *"A reviewer running in a fresh subagent context sees only the diff and the criteria you give it, not the reasoning that produced the change, so it evaluates the result on its own terms."*
- Writer/Reviewer 패턴 (원문): *"A fresh context improves code review since Claude won't be biased toward code it just wrote."*
- 번들 `/code-review`도 v2.1.218+부터 forked subagent에서 실행 (작성자 컨텍스트와 분리)
- 동일 패턴을 테스트에도 적용: 한 세션이 테스트 작성 → 다른 세션이 통과 코드 작성
- **본 리서치에 실제 적용**: 리서치 에이전트 A/B/C/D 와 반증 전용 레드팀 에이전트를 분리 스폰. 레드팀은 리서치 결과를 "반박하라"는 프롬프트만 받음
- 출처: [best-practices](https://code.claude.com/docs/en/best-practices)

### 4.4 증거 기반 완료 보고 — **관행이 아니라 공식 권고**
원문: *"Have Claude show evidence rather than asserting success: the test output, the command it ran and what it returned, or a screenshot of the result. Reviewing evidence is faster than re-running the verification yourself, and it works for sessions you weren't watching."*

검증 강도 3단계 (문서 기준):
| 강도 | 방법 | 적용 범위 |
|---|---|---|
| 1 | 프롬프트 내에서 증거 요청 | 단발 턴 |
| 2 | `/goal` 로 완료 조건 설정 → 매 턴 재평가 | 세션 전체 |
| 3 | **Stop hook** 결정론적 게이트 | 모델 무관 강제 |

---

## 5. 훅 이벤트 목록 (문서 확인분)

exit code 2로 **차단 가능**함이 hooks 레퍼런스의 "Exit Code 2 Effects by Event" 표에 명시된 것만 "예"로 표기. 표에 없으면 `[미확인]`.

| 이벤트명 | 발화 시점 | exit 2 차단 |
|---|---|---|
| `UserPromptSubmit` | 사용자 프롬프트 제출 | **예** (프롬프트 차단·입력 삭제) |
| `UserPromptExpansion` | 커맨드가 프롬프트로 확장될 때 | **예** |
| `PreToolUse` | 도구 실행 전 | **예** (도구 호출 차단) |
| `PermissionRequest` | 도구가 권한 필요 시 | **예** (권한 거부) |
| `PostToolBatch` | 병렬 도구 완료 후 | **예** (다음 모델 호출 전 루프 정지) |
| `Stop` | Claude 응답 종료 시 | **예** (8회 연속까지) |
| `SubagentStop` | 서브에이전트 종료 시 | **예** |
| `WorktreeCreate` | Worktree 생성 시 | **예** (0 이외 전부 실패 처리) |
| `PostToolUse` | 도구 성공 후 | 아니오 (이미 실행됨, stderr만 전달) |
| `PostToolUseFailure` | 도구 실패 후 | 아니오 |
| `SessionStart` | 세션 시작/재개 | 아니오 (컨텍스트 주입용) |
| `InstructionsLoaded` | CLAUDE.md/rules 로드 시 | 아니오 (디버깅/로깅용) |
| `Setup`, `PermissionDenied`, `SubagentStart`, `TaskCreated`, `TaskCompleted`, `TeammateIdle`, `CwdChanged`, `DirectoryAdded`, `FileChanged`, `WorktreeRemove`, `PreCompact`, `PostCompact`, `Elicitation`, `ElicitationResult`, `ConfigChange`, `StopFailure`, `Notification`, `MessageDisplay`, `SessionEnd` | (각 이름대로) | `[미확인]` — exit 2 효과 표에 미등재 |

출처: [hooks](https://code.claude.com/docs/en/hooks)

---

## 6. 도입 로드맵 (초급 / 중급 / 고급)

| 단계 | 도입 항목 | 소요 | 성공 판정 기준 (증거) | 위험 |
|---|---|---|---|---|
| **초급 (D-3)** | **permission mode를 명시적으로 고정** | 10분 | `/config` 또는 settings의 `defaultMode` 확인 | **2026-08-14부터 Pro/Max/Team 신규 세션 기본값이 `auto`로 바뀐다.** 미설정 상태로 두면 분류기 기반 자동 승인으로 동작이 변함 |
| **초급** | `/init` 으로 CLAUDE.md 생성 → `/context` 로 로드 확인 | 30분 | `/context` 출력의 "Memory files"에 표시 + 200줄 이하 | 길게 써서 오히려 준수율 저하 |
| **초급** | 큰 변경 전 Plan Mode 습관화 (`Shift+Tab`) | 즉시 | 승인 전 실제 편집 0건 확인 | 사소한 수정에 남용 → 오버헤드 |
| **중급** | 반복 작업을 Skill로 전환 (`.claude/skills/`) | 스킬당 1~2h | fresh session에서 with/without 비교, 트리거 정확도 측정 | description 모호 → 자동 트리거 실패 |
| **중급** | 프로젝트 전용 Subagent 정의 (`tools` 제한 필수) | 1~2h | 위임 후 메인 컨텍스트에 요약만 반영됨을 `/context`로 확인 | 과도한 tool 허용 → 의도치 않은 파일 쓰기/삭제 |
| **고급** | Hook 결정론적 게이트 (`PreToolUse` deny + `Stop` 테스트 게이트) | 반나절 | `/hooks` 등록 확인 + **실제로 exit 2 차단되는지 트리거 테스트** | 스크립트 버그 → 반복 차단 루프(8회 후 강제 해제되나 그전까지 낭비) |
| **고급** | MCP 연결 + 플러그인화 팀 배포 | 1일+ | `/mcp` 에서 `Connected` + 팀원 승인 플로우(`claude mcp reset-project-choices`) 검증 | 미검증 서버 연결 시 prompt injection (문서 명시 경고) |

---

## 7. 이 문서의 신뢰도 한계

| 항목 | 상태 |
|---|---|
| Plugins 자체의 컨텍스트 오버헤드 수치 | `[미확인]` — 공식 문서에 없음 |
| Stop hook "8회 연속" 임계치의 적용 범위 | 부분 확인 — best-practices 1곳에만 명시, hooks 레퍼런스 미기재 |
| context-window 토큰 수치의 대표성 | 문서의 **단일 예시 시나리오** 값. 평균/상한 아님 |
| `anthropic.com/engineering/claude-code-best-practices` | `[미확인]` — EGRESS_BLOCKED, code.claude.com 판으로 대체 |
| 훅 이벤트 19개의 exit 2 차단 여부 | `[미확인]` — 레퍼런스 표에 미등재 |
