# 01 — Claude 최신 업데이트 (최근 90일)

- 조사 기준일: 2026-08-11
- 조사 창(window): 2026-05-13 ~ 2026-08-11
- 조사 방법: WebFetch 기반 1차 출처 직접 조회. 기억/학습데이터 기반 서술 배제.
- 표기 규칙: `[미확인]` = fetch 실패 또는 원문 확인 불가. `[stale: YYYY-MM]` = 조사창(3개월) 밖 정보.

---

## 0. 조사 커버리지 한계 (먼저 밝힘)

| 항목 | 상태 | 영향 |
|---|---|---|
| `www.anthropic.com/news` | **EGRESS_BLOCKED** (프록시 전면 차단) | Anthropic 공식 뉴스 원문 미확인. 개발자 문서(`platform.claude.com`)로 대체 교차확인 |
| `modelcontextprotocol.io/specification` | **EGRESS_BLOCKED** | 스펙 원문 미확인. `blog.modelcontextprotocol.io`(차단 안 됨)로 대체 |
| `code.claude.com/docs/en/release-notes` | HTTP 404 | `changelog` 페이지가 대체하는 것으로 판단 |
| changelog 2026-05-13 ~ 2026-06-24 구간 | **미확보** | 조사창 앞 6주 분량이 표에서 누락됨. 아래 표는 **2026-06-25 이후**가 실질 커버리지 |

> 결론: 본 문서는 "최근 90일 전량"이 아니라 **2026-06-25 ~ 2026-08-08 구간의 전량 + 그 밖의 개별 확인 항목**이다. 전량 주장하지 않는다.

---

## 1. 변경 이력 (날짜 | 변경내용 | 영향도)

영향도 판정 전제: *개인 개발자가 Claude Code로 코딩/리서치 워크플로를 운영한다.*
- **High** = 워크플로 즉시 변경 필요
- **Med** = 인지 필요, 조건부 대응
- **Low** = 참고

### 1.1 High — 즉시 대응 필요 (7건)

| 날짜 | 카테고리 | 변경내용 | 영향 이유 | 출처 |
|---|---|---|---|---|
| 2026-06-30 | 모델/가격 | Claude Sonnet 5 (`claude-sonnet-5`) 출시. 네이티브 1M 컨텍스트. **도입가 $2/$10 (MTok, ~2026-08-31)** → **2026-09-01부터 $3/$15** | 20일 뒤 입력 단가 +50%, 출력 단가 +50%. 예산 재산정 필요 | [changelog](https://code.claude.com/docs/en/changelog), [pricing](https://platform.claude.com/docs/en/about-claude/pricing) |
| 2026-07-01 | CC기능 | **서브에이전트가 기본적으로 백그라운드 실행**으로 변경. 기본 모델이 Sonnet 5(1M)로 전환 | 서브에이전트 결과를 동기적으로 기다리던 스크립트/습관이 깨짐. 본 리서치에서도 실측 확인됨(4개 에이전트가 `run_in_background:false` 지정에도 비동기 실행) | [changelog](https://code.claude.com/docs/en/changelog) |
| **2026-08-14 (예정, D-3)** | 정책 | **auto mode가 신규 세션의 기본 permission mode가 됨 (Pro/Max/Team)** — 분류기 모델이 명령을 검토해 위험한 것만 차단 | 3일 뒤 시행. 직접 설정한 기본값은 유지되나, 미설정 사용자는 동작이 바뀜. 원문: *"Starting August 14, 2026, auto mode becomes the default permission mode for new sessions on Pro, Max, and Team plans. You can switch modes at any time. A default you set yourself stays in place unless you accept the one-time switch prompt, and a default your organization manages is unchanged."* | [permission-modes](https://code.claude.com/docs/en/permission-modes) |
| ~~2026-07-03~~ | 정책 | ~~기본 permission mode가 `default` → `Manual`로 변경~~ → **[정정] 이것은 동작 변경이 아니라 표시 라벨 변경이다.** 원문: *"The mode that reviews every action is named **Manual** in the CLI... Its config value is `default`, which is what hooks and SDK integrations use. The CLI accepts `manual` as an alias... The Manual label and the `manual` alias require Claude Code v2.1.200 or later."* | **영향도 High → Low로 하향.** config 값·훅/SDK 연동은 그대로 `default`. 자동화가 깨지지 않는다 | [permission-modes](https://code.claude.com/docs/en/permission-modes) |
| 2026-07-17~18 | 보안 | Bash/PowerShell 권한 우회 취약점 **다수** 패치. docker 데몬 리다이렉트 플래그에 권한 프롬프트 추가. `--max-budget-usd`가 백그라운드 서브에이전트도 정지시키도록 수정. `EndConversation` 도구 추가 | 구버전 유지 시 권한 게이트가 실제로 우회 가능. 버전 업그레이드가 보안 조치 | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-07-24 | 모델/가격 | **Claude Opus 5 (`claude-opus-5`) 출시, 기본 Opus로 전환.** 1M 컨텍스트, $5/$25 (Fast mode $10/$50). 서브에이전트 중첩 스폰 깊이 기본값 3 | 기본 모델·단가 체계 전면 변경. 중첩 깊이 3은 다층 하네스 설계 가능성을 넓힘 | [changelog](https://code.claude.com/docs/en/changelog), [models](https://platform.claude.com/docs/en/about-claude/models) |
| 2026-07-28 | MCP | **MCP 스펙 2026-07-28 정식 릴리스 — stateless 아키텍처 전환** (§3 참조) | MCP 서버를 직접 구현/운영 중이면 프로토콜 근본 변경. 세션 기반 구현은 재설계 대상 | [MCP blog](https://blog.modelcontextprotocol.io/posts/2026-07-28/) |
| 2026-08-04 | 보안/git | Worktree 격리 세션이 **메인 체크아웃에 파괴적 git 명령을 실행할 수 있던 취약점** 수정(전 세션 타입 격리 적용). `ultraplan` 제거 | 격리 우회 취약점 → 업그레이드 필요 | [changelog](https://code.claude.com/docs/en/changelog) |
| **2026-07-01 (정정)** | git | 백그라운드 세션이 **자동으로 commit/push** 하도록 변경 (v2.1.198 — 서브에이전트 백그라운드 기본화와 동일 버전) | **[정정] 최초 보고에서 2026-08-04로 잘못 기재.** 자동 commit/push는 의도치 않은 원격 반영 위험 → 브랜치 보호 재점검 필요 | [sub-agents](https://code.claude.com/docs/en/sub-agents) (v2.1.198 표기) |
| 2026-08-05 | 모델 폐기 | **Claude Opus 4.1 (`claude-opus-4-1-20250805`) API 은퇴(retired)** (공지 2026-06-05) | 해당 모델 ID를 하드코딩한 코드/스크립트는 즉시 실패 | [deprecations](https://platform.claude.com/docs/en/about-claude/model-deprecations) |

### 1.2 Med — 인지 필요 (7건)

| 날짜 | 카테고리 | 변경내용 | 영향 이유 | 출처 |
|---|---|---|---|---|
| 2026-06-09 | 모델 | Claude Fable 5 (`claude-fable-5`) / Mythos 5 GA. 1M 컨텍스트, 출력 최대 128k, $10/$50. Fable 5는 안전 분류기 탑재로 `stop_reason:"refusal"` 반환 가능. Mythos 5는 프로젝트 Glasswing 한정 배포 | 코딩 기본값은 아니나, API 직접 호출 시 `refusal` stop_reason 분기 처리 필요 | [Fable 5/Mythos 5](https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5) |
| 2026-07-19 | CC기능 | `/verify`, `/code-review`를 Claude가 **자동 실행하지 않도록** 변경(명시적 호출 필요) | "알아서 리뷰하겠지"에 의존한 검증 루프가 조용히 사라짐 → Stop hook 등 결정론적 게이트로 대체해야 함 (03·04 문서 연결) | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-07-21~22 | CC기능 | VSCode Focus view. `/code-review`가 백그라운드 서브에이전트로 실행. **동시 서브에이전트 상한 20개** (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`) | 대규모 팬아웃 리서치 설계 시 상한값이 병렬도 상한 | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-08-04 | CC기능 | 샌드박스 자격증명 마스킹 옵션 (`mode:"mask"`). zsh `[[ ]]` 권한 우회 패치. Claude in Chrome 탭 자동 종료 | 비밀정보 노출면 축소 옵션 | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-08-06 | CC기능 | `/review`가 `/code-review`의 별칭이 됨(`ultra`로 클라우드 심층 리뷰). `CLAUDE_CODE_DISABLE_1M_CONTEXT`가 1M 네이티브 모델 전체에 적용. 미인식 모델 ID에도 auto-compact 적용 | 컨텍스트 관리 동작 변경 | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-08-07 | CC기능 | 자체 호스팅 러너(`claude self-hosted-runner`, Team/Enterprise). 세션 간 `SendMessage`. Zip 기반 plugin source(`archive`) | 멀티 세션 오케스트레이션 가능성. 개인 워크플로는 참고 수준 | [changelog](https://code.claude.com/docs/en/changelog) |
| (진행중) | 한도 | Opus 5는 Opus 4.5~4.8과 **별도 rate limit 버킷** (Start tier: 1,000 RPM / 2M ITPM / 400k OTPM). Fast mode는 별도 전용 한도 | 모델 전환 시 한도 계산을 새로 해야 함 | [rate-limits](https://platform.claude.com/docs/en/api/rate-limits) |

### 1.3 Low — 참고 (3건)

| 날짜 | 변경내용 | 출처 |
|---|---|---|
| 2026-06-25 | `autoMode.classifyAllShell` 설정 추가(모든 shell 명령을 auto-mode 분류기로 라우팅) | [changelog](https://code.claude.com/docs/en/changelog) |
| 2026-08-08 | 게이트웨이 지출 한도 경고에 한도명/리셋시간 표시. 안정성 버그 다수 수정 | [changelog](https://code.claude.com/docs/en/changelog) |
| (진행중) | Fast mode(연구 프리뷰): Opus 5/4.8에서 최대 2.5배 출력 속도, $10/$50, Batch/Priority Tier 병용 불가 | [fast-mode](https://platform.claude.com/docs/en/build-with-claude/fast-mode) |

### 1.4 조사창 밖 참고 항목

| 날짜 | 변경내용 | 태그 | 출처 |
|---|---|---|---|
| 2026-04-14 공지 → **2026-06-15 은퇴** | Claude Sonnet 4 / Opus 4 API 완전 은퇴 | `[stale: 2026-04]` (공지 기준) / 실제 폐기는 조사창 내 | [deprecations](https://platform.claude.com/docs/en/about-claude/model-deprecations) |

---

## 2. 모델 라인업 / 가격 현황 (fetch 확인분)

| 모델 ID | 출시/갱신 | 입력 $/MTok | 출력 $/MTok | 컨텍스트 | 상태 |
|---|---|---|---|---|---|
| `claude-opus-5` | 2026-07-24 | 5 | 25 | 1M (출력 128k) | 현행 기본 Opus |
| `claude-opus-5` (Fast mode) | 2026-07-24 | 10 | 50 | 1M | 연구 프리뷰, 옵트인 |
| `claude-sonnet-5` | 2026-06-30 | **2 → 3** (2026-09-01) | **10 → 15** | 1M (출력 128k) | 현행 기본 모델 |
| `claude-fable-5` | 2026-06-09 | 10 | 50 | 1M (출력 128k) | GA |
| `claude-mythos-5` | 2026-06-09 | 10 | 50 | 1M | 제한 배포(Glasswing) |
| `claude-opus-4-8` | 이전 | 5 | 25 | 1M | 유지 |
| `claude-opus-4-7` | 이전 | 5 | 25 | 1M | 유지 |
| `claude-sonnet-4-6` | 이전 | 3 | 15 | 1M | 유지 |
| `claude-haiku-4-5-20251001` | `[stale: 2025-10]` | 1 | 5 | 200k (출력 64k) | 유지 |
| `claude-opus-4-1-20250805` | — | — | — | 200k | **2026-08-05 retired** |
| `claude-sonnet-4-20250514` / `claude-opus-4-20250514` | — | — | — | — | **2026-06-15 retired** |

출처: [models](https://platform.claude.com/docs/en/about-claude/models), [pricing](https://platform.claude.com/docs/en/about-claude/pricing), [deprecations](https://platform.claude.com/docs/en/about-claude/model-deprecations)

### 비용 시사점 (정량)
- 리서치성 팬아웃 작업 1회에 서브에이전트 4개 × 약 11만 토큰 소비를 실측(본 세션 A 에이전트 단독 114,349 토큰).
- 동일 작업을 Opus 5($5/$25)가 아닌 Sonnet 5($2/$10, 9월부터 $3/$15)로 위임하면 입력 기준 **60% 절감**(9월 이후 40%).
- → **액션**: 서브에이전트 기본 모델을 Sonnet 5로 고정하고, 최종 종합·판정만 Opus 5로 수행. (본 리서치에서 실제 적용함)

---

## 3. MCP 스펙 변경

| 버전/날짜 | 변경점 | 하위호환성 | 출처 |
|---|---|---|---|
| **2026-07-28 (정식)** | ① **Stateless 프로토콜 코어**: `initialize`/`initialized` 핸드셰이크 및 `Mcp-Session-Id` 폐지 ② **Multi Round-Trip Requests**(서버 발신 요청을 stateless로 대체) ③ **헤더 기반 라우팅**(`Mcp-Method`, `Mcp-Name`) ④ list 응답 캐시 메타데이터(`ttlMs`, `cacheScope`) ⑤ RFC 9207 issuer 검증 등 인가 강화 ⑥ **Extensions 프레임워크** 공식화(Tasks, MCP Apps, Enterprise Managed Authorization) ⑦ Tier 1 SDK(TS/Python/Go/C#) 전체 지원 | Roots / Sampling / Logging / 구 HTTP+SSE transport는 **최소 12개월 유예 후 제거**. 즉시 breaking 아님. 단 세션 기반 서버는 재설계 대상 | [blog 2026-07-28](https://blog.modelcontextprotocol.io/posts/2026-07-28/) |
| 2026-07-28 RC | 동일 stateless 전환의 RC. Extensions가 SEP(Specification Enhancement Proposal) 거버넌스로 편입. 6개 SEP로 OAuth 2.0/OIDC 정합성 강화, JSON Schema 2020-12 전체 지원, W3C Trace Context 전파 표준화 | 상동 | [blog RC](https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/) |

**RC 발표일 불일치 `[미확인]`**: 블로그 본문은 "Announcement Date: May 21, 2026", GitHub releases는 동일 RC 태그를 "May 29, 2026"으로 표기. 8일 차이의 원인 미확인. 정식판 날짜(2026-07-28)는 두 출처 일치.

---

## 4. 미확인 항목 (추측으로 메우지 않음)

| 항목 | 상태 |
|---|---|
| 2026-05-13 ~ 2026-06-24 changelog | `[미확인]` — 페이지에서 해당 구간 반환 실패 |
| Anthropic 공식 뉴스(anthropic.com/news) 90일 전량 | `[미확인]` — EGRESS_BLOCKED |
| MCP 스펙 원문(modelcontextprotocol.io) | `[미확인]` — EGRESS_BLOCKED. 공식 블로그로 대체 |
| Sonnet 4.5/4.6 → Sonnet 5 breaking change 목록 | `[미확인]` — migration-guide 원문에 해당 내용 없음. 추론 결과였으므로 폐기 |
| GitHub releases 페이지의 시/분 타임스탬프 | 신뢰 불가 — fetch 결과가 "August 8, **2024**" 등 명백한 오류 연도 반환. 버전 순서(v2.1.226 최신)만 changelog와 일치 확인 |

---

## 5. 이 문서에서 도출되는 워크플로 액션 (5개)

| # | 액션 | 근거 | 기한 |
|---|---|---|---|
| 1 | 서브에이전트 기본 모델을 `claude-sonnet-5`로 고정, 종합/판정만 `claude-opus-5` | 입력 단가 5 vs 2 ($/MTok) | 즉시 |
| 2 | **2026-08-31 이전** 토큰 소비 예산 재산정 (Sonnet 5 단가 +50% 예정) | pricing 페이지 | 2026-08-31 |
| 3 | **2026-08-14 이전에** permission mode를 명시적으로 설정 (미설정 시 auto mode로 전환됨) + hooks로 결정론적 게이트 구성 | [permission-modes](https://code.claude.com/docs/en/permission-modes) | **D-3 (2026-08-14)** |
| 4 | 자동 commit/push 동작 대비 브랜치 보호 규칙 점검 | 2026-08-04 changelog | 1주 내 |
| 5 | 하드코딩된 모델 ID(`claude-opus-4-1-*`, `claude-sonnet-4-*`) 전수 검색·치환 | 2026-08-05 / 2026-06-15 은퇴 | 즉시 |
