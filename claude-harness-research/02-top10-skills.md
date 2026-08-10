# 02 — Claude Code 스킬 TOP 10

- 조사 기준일: 2026-08-11
- **이 문서는 다른 문서보다 신뢰도가 낮다. §0을 읽지 않고 이 순위를 인용하면 안 된다.**

---

## 0. ⚠️ 채택도 수치의 신뢰도 경고 (레드팀 검증 결과)

### 0.1 무슨 일이 있었나
조사 에이전트가 GitHub에서 읽어온 star 수치를 레드팀이 재검증했다. **수치 자체는 이 세션에서 접근 가능한 GitHub 데이터와 ±5 이내로 일치했다.** 그러나 두 가지 문제가 남는다.

**문제 1 — 현실성(sanity check) 실패**

| 저장소 | 보고된 star | 저장소 나이 | 대조 |
|---|---|---|---|
| obra/superpowers | 270,192 | 약 10개월 (2025-10-09 생성) | Linux 커널(242k), React(247k), Vue.js(210k)를 **상회** |
| mattpocock/skills | 212,480 | 약 6개월 | Vue.js 13년치 누적을 상회 |
| multica-ai/andrej-karpathy-skills | 201,198 | — | — |
| anthropics/skills | 167,457 | 2025-09-22 생성 | — |

GitHub 전체 최상위 저장소가 40만대 수준이다. 위 수치가 사실이라면 이들이 **GitHub 역대 top 20**에 들어간다. 생성 6~10개월 만에. 뉴스·커뮤니티 토론 등 외부 corroboration은 **하나도 확인되지 않았다.**

**문제 2 — 데이터 소스가 실제 GitHub의 완전한 미러가 아닐 가능성**

레드팀이 star 상위 저장소 리더보드를 조회했을 때, 실제 GitHub과 **owner명이 다른** 항목이 나왔다:

| 이 환경에서 반환된 이름 | 실제 GitHub |
|---|---|
| `react/react` | `facebook/react` |
| `nilbuild/developer-roadmap` | `kamranahmedse/developer-roadmap` |
| `openclaw/openclaw` | — |

또한 필자가 직접 `curl https://api.github.com/repos/anthropics/skills` 를 실행한 결과:
```
{"message":"GitHub access to this repository is not enabled for this session. Use add_repo to request access.
 If add_repo answers that read access is already available and you need GitHub API or write access,
 call add_repo again with access:\"push\" to attach the repository with credentials.", ...}
```
→ 이 세션의 GitHub 접근은 프록시를 거치며, **실제 github.com의 완전한 미러가 아닐 수 있다.**

### 0.2 결론
| 항목 | 판정 |
|---|---|
| star 수치를 **실세계 채택도 지표**로 사용 | **불가.** `[미검증]` |
| 저장소가 실재하고 최근 커밋이 있다는 사실 | 조건부 신뢰 (동일 소스 기준) |
| **아래 순위표를 근거로 도입 결정** | **하지 마라.** §4의 대안 절차를 쓸 것 |

이 문서를 남기는 이유는 순위 자체가 아니라 **후보 목록과 "안 쓰는 게 나은 상황" 정보**에 있다.

---

## 1. 선정 기준 (점수화 방법)

각 항목 0~5점, 총 20점.

| 기준 | 정의 | 배점 방법 |
|---|---|---|
| **C1 채택도** | GitHub star 또는 공식 번들 여부 | <5k=1, 1만~3만=3, 3만~10만=4, 10만+ 또는 공식=5 · **§0에 따라 이 축은 신뢰 불가** |
| **C2 최신성** | `pushed_at`이 2026-05-13 이후 | 이후=5, 이전=0 (중간값 없음) |
| **C3 토큰 효율** | SKILL.md가 progressive disclosure 구조(짧은 본문 + 참조파일 분리)인가 | 원문 확인=5, 구조 불명/커맨드 중심=2~3 |
| **C4 범용성** | 특정 언어·프레임워크·툴체인 종속 없이 적용 가능한가 | 종속 없음=5 |

---

## 2. TOP 10

**C1 열은 §0에 따라 신뢰할 수 없다.** C2/C3/C4와 마지막 두 열이 이 표의 실질 가치다.

| 순위 | 스킬/플러그인 | 공식/커뮤니티 | 저장소 | star `[미검증]` | 최근커밋 | C1 | C2 | C3 | C4 | 총점 | 해결하는 문제 | 설치 명령어 | **안 쓰는 게 나은 상황** |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | **anthropics/skills** | **공식** | [링크](https://github.com/anthropics/skills) | 167,457 | 2026-08-07 | 5 | 5 | 5 | 5 | 20 | PDF/DOCX/PPTX/XLSX 문서 작업, MCP 서버 빌드, 웹앱 테스팅 | 개별 스킬 디렉터리를 `.claude/skills/` 로 복사. **단일 CLI 설치 명령은 저장소에서 확인 못함** `[미확인]` | 문서 작업이 없는 순수 코딩 세션에는 대부분 불필요 |
| 2 | addyosmani/agent-skills | 커뮤니티 | [링크](https://github.com/addyosmani/agent-skills) | 85,696 | 2026-08-08 | 4 | 5 | 5 | 5 | 19 | 스펙→TDD→코드리뷰→보안→성능→CI/CD SDLC 전 구간 | `npx skills add addyosmani/agent-skills` 또는 `/plugin marketplace add addyosmani/agent-skills` + `/plugin install agent-skills@addy-agent-skills` | 24개 스킬이 과할 만큼 작은 프로젝트, 자체 SDLC가 확립된 팀 |
| 3 | obra/superpowers | 커뮤니티 (공식 마켓플레이스 등재) | [링크](https://github.com/obra/superpowers) | 270,192 | 2026-08-08 | 5 | 5 | 3 | 5 | 18 | TDD·체계적 디버깅·브레인스토밍·계획수립 방법론 | `/plugin install superpowers@claude-plugins-official` | 확립된 자체 워크플로가 있는 시니어 팀, 일회성 스크립트 |
| 4 | DietrichGebert/ponytail | 커뮤니티 | [링크](https://github.com/DietrichGebert/ponytail) | 100,090 | 2026-08-07 | 5 | 5 | 3 | 5 | 18 | 에이전트의 과잉 엔지니어링(불필요 의존성·래퍼·추상화) 억제 | `/plugin marketplace add DietrichGebert/ponytail` + `/plugin install ponytail@ponytail` | **README가 직접 명시**: 이미 최소화된 코드에는 효과가 거의 0 |
| 5 | JuliusBrussee/caveman | 커뮤니티 | [링크](https://github.com/JuliusBrussee/caveman) | 97,283 | 2026-08-10 | 4 | 5 | 3 | 5 | 17 | 출력 토큰 절감 (산문 65%, 전체 에이전틱 작업 8.5% — **저장소 자체 주장, 독립 검증 없음**) | `claude plugin marketplace add JuliusBrussee/caveman && claude plugin install caveman@caveman` | **README가 직접 명시**: 이미 간결한 워크플로에는 순손실. 입력토큰 비중이 큰 대형 코드베이스 |
| 6 | blader/humanizer | 커뮤니티 | [링크](https://github.com/blader/humanizer) | 34,710 | 2026-07-22 | 3 | 5 | 4 | 5 | 17 | AI 글쓰기 특유 패턴(과장·상투구·수동태) 제거 | `npx skills add blader/humanizer --global` | 코드 작성/버그 수정처럼 문체가 무관한 작업, 사실 검증이 핵심인 기술문서 |
| 7 | mattpocock/skills | 커뮤니티 | [링크](https://github.com/mattpocock/skills) | 212,480 | 2026-08-07 | 5 | 5 | 2 | 4 | 16 | TDD, 이슈 트리아지, 아키텍처 저하 방지 | `npx skills@latest add mattpocock/skills` · ~~`claude plugins install mattpocock-skills`~~ **[레드팀 반증] 이 셸 명령 형태는 공식 문서에 없음.** 확인된 문법은 세션 내 `/plugin install <name>@<marketplace>` | progressive disclosure 구조가 README에 명시되지 않아 토큰 비용 예측 불가 |
| 8 | OthmanAdi/planning-with-files | 커뮤니티 | [링크](https://github.com/OthmanAdi/planning-with-files) | 26,083 | 2026-08-09 | 3 | 5 | 4 | 4 | 16 | `/clear`·세션 중단 후 계획 소실 방지 | `/plugin marketplace add OthmanAdi/planning-with-files` + `/plugin install planning-with-files@planning-with-files` | 짧은 단일 세션, Windows PowerShell 5.1(호환성 이슈 명시), 훅 미지원 에이전트 |
| 9 | garrytan/gstack | 커뮤니티 | [링크](https://github.com/garrytan/gstack) | 127,370 | 2026-08-08 | 5 | 5 | 2 | 3 | 15 | 기획~디자인~QA~배포 전체 SDLC를 23개 역할별 에이전트로 | `git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup` | **Bun/Git 툴체인 필수.** SKILL.md 표준이 아닌 슬래시커맨드 중심 구조 → 범용성 낮음. 컨벤션이 확고한 팀엔 과함 |
| 10 | thedotmack/claude-mem | 커뮤니티 | [링크](https://github.com/thedotmack/claude-mem) | 90,326 | 2026-08-10 | 4 | 5 | 2 | 4 | 15 | 세션 간 컨텍스트 소실 방지 (자동 압축·재주입) | `npx claude-mem install` | Node.js 20+ 로컬 Bun 워커 설치 부담. **민감정보 프로젝트 — 수동 `<private>` 태깅이 필요해 누락 시 유출 위험** |

### 2.1 설치 명령어 신뢰도
| 명령 형태 | 상태 |
|---|---|
| `/plugin marketplace add <owner>/<repo>` + `/plugin install <name>@<marketplace>` | **공식 문서로 확인됨** ([skills](https://code.claude.com/docs/en/skills)) |
| `npx skills add ...` | 각 저장소 README 표기. npm 패키지 원문 미검증 `[미확인]` |
| `claude plugins install <name>` | **공식 문서에 없음.** 인용 금지 |

---

## 3. 공식 번들 스킬 (anthropics/skills, 17개)

커뮤니티 스킬과 달리 **출처가 1차이고 채택도 논쟁이 없다.** 여기서 시작하는 게 안전하다.

| 분류 | 스킬 |
|---|---|
| 문서 처리 | `pdf`, `docx`, `pptx`, `xlsx` |
| 개발 도구 | `mcp-builder`, `webapp-testing`, `skill-creator`, `claude-api` |
| 디자인/프론트 | `frontend-design`, `web-artifacts-builder`, `canvas-design`, `algorithmic-art`, `theme-factory` |
| 커뮤니케이션 | `brand-guidelines`, `internal-comms`, `doc-coauthoring`, `slack-gif-creator` |

- `pdf/SKILL.md` 는 원문 fetch로 **progressive disclosure 구조 확인**됨 (`REFERENCE.md`, `FORMS.md` 분리)
- 나머지 16개의 SKILL.md 원문은 미확인 `[미확인]`
- Claude Code 내장 `/debug`, `/code-review` 등은 이 저장소와 **별개**의 내장 스킬 `[미확인]`

---

## 4. 탈락 후보와 사유

| 후보 | 사유 |
|---|---|
| multica-ai/andrej-karpathy-skills | `pushed_at` 2026-04-20 → C2 컷오프 이전. 또한 SKILL.md 패키지가 아니라 **단일 CLAUDE.md 파일**이라 Agent Skills 표준이 아님 |
| ComposioHQ/awesome-claude-skills | 개별 스킬이 아니라 큐레이션 목록 |
| anthropics/claude-plugins-official | 마켓플레이스 **채널** 자체(300+ 플러그인). 대부분 `commands/` 구조라 개별 스킬 평가 불가 |
| anthropics/claude-plugins-community | README에 "Read-only mirror"로 명시된 자동 미러. 자체 콘텐츠 없음 |
| nextlevelbuilder/ui-ux-pro-max-skill | React/Tailwind 종속 → C4 낮음 |
| K-Dense-AI/scientific-agent-skills | 생물/화학/신약 도메인 전용 158개 → 범용성 매우 낮음 |
| jimmc414/claude-code-plugin-marketplace | star 4 |

---

## 5. 【권장】 순위 대신 쓸 도입 절차

§0 때문에 star 기반 순위를 신뢰할 수 없으므로, 아래 절차로 대체한다.

| 단계 | 행동 | 판정 기준 |
|---|---|---|
| 1 | **공식 번들(anthropics/skills)부터 검토** | 출처 1차. 채택도 논쟁 없음 |
| 2 | 내 실제 반복 작업 3개를 적는다 | 스킬이 없어도 되는 작업이면 도입하지 않는다 |
| 3 | 후보 스킬의 **SKILL.md 원문을 직접 읽는다** | 본문 500줄 미만 + 참조파일 분리 구조인가 |
| 4 | `/context` 로 도입 전 토큰을 기록 | 도입 후와 비교할 기준선 |
| 5 | fresh session에서 **with/without A-B 비교** | 트리거 정확도, 출력 품질, 컨텍스트 증가량 |
| 6 | 4주 뒤 재평가 | 실제로 트리거된 횟수가 0이면 제거 |

> 스킬 하나하나는 description이 **상시 컨텍스트**를 차지한다(공식 예시값 기준 전체 합계 ≈450 tok). 설치 개수를 늘리는 것 자체가 비용이다.

---

## 6. 이 문서의 미확인 항목

| 항목 | 상태 |
|---|---|
| 모든 star 수치의 **실세계 정확성** | `[미검증]` — §0 |
| anthropics/skills 단일 CLI 설치 명령 | `[미확인]` |
| superpowers / ponytail / caveman / mattpocock의 SKILL.md 원문 | `[미확인]` — README 요약 기반 추정 |
| gstack / claude-mem이 `skills/*/SKILL.md` 표준을 포함하는지 | `[미확인]` — 폴더 트리 미탐색 |
| caveman의 "토큰 65%/8.5% 절감" 수치 | 저장소 자체 주장, 독립 검증 없음 |
| `npx skills add`, `npx claude-mem install` 문법 | `[미확인]` — npm 패키지 미확인 |
