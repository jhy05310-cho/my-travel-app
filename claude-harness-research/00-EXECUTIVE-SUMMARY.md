# 00 — 종합 요약 (Executive Summary)

- 작성일: 2026-08-11 | 조사창: 2026-05-13 ~ 2026-08-11
- 방법: 병렬 리서치 서브에이전트 4개 → 반증 전용 레드팀 1개 → 필자가 1차 출처로 최종 판정
- 소비: 서브에이전트 5개 합계 **750,156 토큰** (메인 컨텍스트에는 각 에이전트의 요약만 반영)
- fetch 성공 URL **52개** (요구 25개 대비 208%)

---

## 1. 결론 먼저

### 1.1 하네스 설계의 핵심 사실
Claude Code에서 **모델이 무시할 수 없는 것은 4개뿐**이다.

| 결정론적으로 강제되는 것 | 부탁일 뿐인 것 |
|---|---|
| **Hooks** (exit 2 차단) | CLAUDE.md |
| **permissions** (deny 우선, 클라이언트 강제) | Skills 본문 |
| **Plan Mode** (승인 전 편집 차단) | Slash Commands |
| **Subagent 격리** (독립 컨텍스트·도구 제한) | Auto memory |

공식 문서 원문: *"Claude treats them as context, not enforced configuration. To block an action regardless of what Claude decides, use a PreToolUse hook instead."*

→ **하네스를 설계한다 = 위 4개를 어디에 배치할지 정하는 것.** 나머지는 품질 개선이지 보장이 아니다.

### 1.2 사용자가 제시한 전제 중 검증에 실패한 것
| 전제 | 판정 |
|---|---|
| "Hashimoto 2026-02 → OpenAI/Anthropic 확산" | **검증 실패** (mitchellh.com·anthropic.com·openai.com 전부 차단) |
| Information / Execution / Feedback 3계층 | **1차 출처 없음.** 해당 분야 큐레이션 저장소에도 부재 확인 |
| Inner vs Outer harness | **1차 출처 없음.** 2차 출처 반복 재생산 패턴 |
| arXiv 논문의 설계 원칙·평가 지표 원문 인용 | **전량 실패.** 논문 미러 도메인 전부 차단. **ID 실재 여부조차 미확인** |

이 4개는 추측으로 메우지 않고 실패로 남겼다. 상세는 `04-harness-engineering.md`.

### 1.3 리서치 자체에서 나온 가장 중요한 발견
**커뮤니티 스킬 채택도 수치(star)를 신뢰할 수 없다.** 보고된 값(obra/superpowers 270,192 등)은 Linux 커널·React를 상회하는 수준인데 생성 6~10개월 저장소다. 게다가 이 환경의 GitHub 데이터에서 `react/react`, `nilbuild/developer-roadmap` 같은 **실제와 다른 owner명**이 관측되었다 → 완전한 미러가 아닐 가능성. 상세는 `02-top10-skills.md` §0.

---

## 2. 지금 해야 할 액션 5개

| # | 액션 | 기한 | 근거 | 완료 증거 |
|---|---|---|---|---|
| **1** | **permission mode를 명시적으로 고정한다** | **2026-08-14 (D-3)** | *"Starting August 14, 2026, auto mode becomes the default permission mode for new sessions on Pro, Max, and Team plans."* — [permission-modes](https://code.claude.com/docs/en/permission-modes) | `settings.json` 의 `defaultMode` 값 |
| **2** | **PreToolUse 보안 가드 + permissions.deny를 건다** | 1주 내 | 2026-07-17~18 Bash/PowerShell 권한 우회 취약점 다수 패치. CLAUDE.md는 강제력이 없음 | Claude에게 `cat .env` 를 시켜 차단되는 화면 |
| **3** | **하드코딩된 모델 ID를 치환한다** | 즉시 | `claude-opus-4-1-*` 2026-08-05 은퇴, `claude-sonnet-4-*`/`claude-opus-4-*` 2026-06-15 은퇴 | `grep -rn "claude-opus-4-1\|claude-.*-2025" .` 출력 |
| **4** | **서브에이전트 기본 모델을 Sonnet 5로 내리고 2026-08-31 전에 예산을 재산정한다** | **2026-08-31 (D-20)** | Sonnet 5 $2/$10 → **$3/$15 (+50%)**. Opus 5는 $5/$25 | 월 예상 토큰 × 신단가 계산표 |
| **5** | **작성자와 검증자를 분리한다 (레드팀 서브에이전트 상설화)** | 2주 내 | *"A reviewer running in a fresh subagent context sees only the diff and the criteria you give it, not the reasoning that produced the change."* 본 리서치에서 레드팀이 **High 오류 2건 + 검증누락 1건**을 실제로 잡음 | 레드팀 지적 목록 + 1차 출처 재확인 결과 |

---

## 3. 90일 변경 중 High 등급만 (상세: `01-claude-updates.md`)

| 날짜 | 변경 | 즉시 해야 할 일 |
|---|---|---|
| **2026-08-14 (예정)** | auto mode가 신규 세션 기본값 (Pro/Max/Team) | 모드 명시 고정 |
| 2026-08-05 | Opus 4.1 API 은퇴 | 모델 ID 치환 |
| 2026-08-04 | worktree 격리 취약점 수정 | 업그레이드 |
| 2026-07-28 | MCP 스펙 stateless 전환 (핸드셰이크·세션ID 폐지) | **MCP 서버를 직접 구현하는 경우만** 재설계 검토. 12개월 유예 있음 |
| 2026-07-24 | Opus 5 출시, 기본 Opus 전환 ($5/$25) | 비용 재산정 |
| 2026-07-01 | 서브에이전트 백그라운드 기본화 + 백그라운드 세션 자동 commit/push | 브랜치 보호 점검 |
| 2026-06-30 | Sonnet 5 출시, 기본 모델 ($2/$10 → 09-01부터 $3/$15) | 예산 재산정 |
| 2026-06-15 | Sonnet 4 / Opus 4 은퇴 | 모델 ID 치환 |

---

## 4. 교차검증 결과 요약 (작성자 ≠ 채점자)

레드팀이 제기한 6건 중 **5건 채택, 1건 기각**. 기각 근거도 1차 출처 재fetch다.

| 지적 | 판정 |
|---|---|
| "permission mode default→Manual 변경"은 라벨 변경일 뿐 | **채택** → 영향도 High→Low 하향 |
| 2026-08-14 auto mode 기본화 누락 | **채택** → 최우선 액션으로 승격 |
| 자동 commit/push는 08-04가 아니라 07-01 | **채택** → 날짜 정정 |
| `claude plugins install <name>` 은 없는 명령 | **채택** → 취소선 처리 |
| star 수치에 sanity check 없음 | **채택** → 02 §0 경고 섹션 신설 |
| "Stop hook 8회 연속 차단"은 창작된 수치 | **기각** — best-practices 원문 재fetch로 문장 실재 확인 |

전체 판정 이력: `SOURCES.md` §6

---

## 5. 문서 지도

| 파일 | 내용 | 신뢰도 |
|---|---|---|
| `01-claude-updates.md` | 90일 변경 이력, 모델/가격, MCP 스펙 | 높음 (1차 출처, 단 5/13~6/24 구간 미확보) |
| `02-top10-skills.md` | 스킬 TOP10, 선정 기준, 도입 절차 | **낮음 — §0 경고 필독** |
| `03-claude-code-mastery.md` | 6개 프리미티브, **소유권 결정 표**, 검증 루프 | 높음 (1차 출처 14개) |
| `04-harness-engineering.md` | 하네스 정의, 계층 매핑, **검증 실패 목록** | 중간 (핵심 전제가 미검증) |
| `05-my-adoption-roadmap.md` | 30일 주차별 실행 계획 | 실행용 |
| `SOURCES.md` | URL 52개 + 실패 목록 + 판정 이력 | — |
| `starter-kit/` | 즉시 적용 가능한 하네스 | 동작 검증 완료 (하단) |

---

## 6. starter-kit 구성

| 파일 | 레이어 | 강제력 |
|---|---|---|
| `CLAUDE.md` | 상시 가이드 | 없음 (advisory) |
| `.claude/settings.json` | permissions + hooks 실제 로드 위치 | **결정론적** |
| `.claude/hooks.json` | 훅 정의 (플러그인 배포용 분리본) | **결정론적** |
| `.claude/hooks/guard-bash.sh` | PreToolUse — 원격스크립트 실행/재귀삭제/파괴적 git/비밀정보 열람/env 덤프 차단 | **결정론적** (fail-closed) |
| `.claude/hooks/guard-secrets.sh` | PreToolUse — 비밀정보 경로·락파일 차단 | **결정론적** (fail-closed) |
| `.claude/hooks/verify-gate.sh` | Stop/SubagentStop — 검증 게이트 (3회 자동 해제) | **결정론적** (fail-open) |
| `.claude/skills/source-verified-research/SKILL.md` | 온디맨드 지식 — 출처 검증 리서치 절차 | advisory |
| `.claude/agents/source-researcher.md` | 위임 — 리서치 워커 | 도구 제한은 결정론적 |
| `.claude/agents/red-team-verifier.md` | 위임 — 반증 전용 검증자 | 도구 제한은 결정론적 |
| `mcp-setup.md` | MCP 연결 절차·후보·판정 3문항 | 문서 |

---

## 7. 미해결 질문 3개

1. **arXiv 논문 6편은 실재하는가?** 검색 스니펫에만 등장했고 ID·저자·초록 중 원문으로 확인된 것이 하나도 없다. 네트워크 제약이 없는 환경에서 실재 여부부터 확인해야 한다. 실재하지 않는 ID가 섞여 있을 가능성을 배제할 수 없다.
2. **커뮤니티 스킬의 실제 채택도는 얼마인가?** 이 환경의 GitHub 데이터가 실제 github.com의 완전한 미러가 아닐 정황이 있다. 브라우저나 다른 네트워크에서 star 수를 재확인해야 02의 순위가 의미를 갖는다.
3. **2026-05-13 ~ 06-24 구간에 무슨 변경이 있었나?** changelog 페이지가 이 구간을 반환하지 않아 조사창의 앞 6주가 비어 있다. 이 구간에 High 등급 변경이 있었을 수 있다.

## 8. 다음 액션 1개

**2026-08-14 이전에 `starter-kit/.claude/settings.json` 을 실제 프로젝트에 적용하고, `permissions.deny` 와 PreToolUse 가드가 실제로 차단하는지 트리거 테스트를 실행한다.** (설정만 하고 테스트하지 않으면 강제되지 않는 것과 같다.) 나머지 항목은 이 검증이 통과한 뒤 `05-my-adoption-roadmap.md` 2주차부터 진행한다.
