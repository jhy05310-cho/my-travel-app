# SOURCES — 전체 출처 목록

- 접속일자: 모두 **2026-08-11**
- **수록 원칙: 실제 fetch에 성공한 URL만.** 검색 스니펫만 본 URL, 차단된 URL은 §4에 분리 기재하며 인용 근거로 쓰지 않았다.

## 신뢰도 등급 정의
| 등급 | 정의 | 이 조사에서의 도메인 |
|---|---|---|
| **1차** | 주체 본인이 발행한 문서 | `code.claude.com/docs`, `platform.claude.com/docs`, `blog.modelcontextprotocol.io` |
| **2차** | 1차를 인용·해설, 또는 공식 소유 저장소 | `github.com/anthropics/*`, `github.com/modelcontextprotocol/*` |
| **3차** | 제3자 재인용·큐레이션 | 커뮤니티 GitHub 저장소, awesome-list |

---

## 1. 1차 출처 — Claude Code 공식 문서 (`code.claude.com/docs/en/`) — 20개

| # | URL | 확인한 내용 | 사용 문서 |
|---|---|---|---|
| 1 | https://code.claude.com/docs/en/changelog | 2026-06-25 ~ 2026-08-08 변경 이력 | 01 |
| 2 | https://code.claude.com/docs/en/memory | CLAUDE.md 경로·로딩·강제력 없음 | 03, 04, starter-kit |
| 3 | https://code.claude.com/docs/en/skills | Skills 전체, "Custom commands have been merged into skills", `/plugin install <name>@<marketplace>` 문법 | 02, 03, 04 |
| 4 | https://code.claude.com/docs/en/sub-agents | 서브에이전트 격리·도구제한·v2.1.198 백그라운드 기본화 | 01, 03, 04 |
| 5 | https://code.claude.com/docs/en/slash-commands | skills 페이지로 통합 반환됨을 확인 | 03 |
| 6 | https://code.claude.com/docs/en/hooks | **훅 설정 JSON 구조, stdin 입력 필드, tool_input 필드, exit code 의미, permissionDecision 값** (필자 직접 재fetch) | 03, starter-kit |
| 7 | https://code.claude.com/docs/en/hooks-guide | 훅 개요·퀵스타트 | 03 |
| 8 | https://code.claude.com/docs/en/mcp | MCP 스코프, 설정, 출력 토큰 제한 | 03, starter-kit/mcp-setup.md |
| 9 | https://code.claude.com/docs/en/plugins | 플러그인 구조, 보안 제약 | 03 |
| 10 | https://code.claude.com/docs/en/settings | `permissions` allow/deny/ask 구조 | 03, starter-kit |
| 11 | https://code.claude.com/docs/en/permissions | *"Settings rules are enforced by the client regardless of what Claude decides to do."* | 04 |
| 12 | https://code.claude.com/docs/en/permission-modes | **"Manual"은 CLI 표시명이고 config 값은 `default`. 2026-08-14 auto mode 기본화 예고** (필자 직접 재fetch) | 01, 03, 05 |
| 13 | https://code.claude.com/docs/en/best-practices | **"8 consecutive blocks", 증거 기반 보고, Writer/Reviewer, adversarial review** (필자 직접 재fetch) | 03, 04, starter-kit |
| 14 | https://code.claude.com/docs/en/context-window | 컨텍스트 비용 예시 토큰값 | 03 |
| 15 | https://code.claude.com/docs/en/common-workflows | Plan Mode 진입법, 워크플로 패턴 | 03 |
| 16 | https://code.claude.com/docs/en/overview | "A harness for every task" 블로그 링크 제목 | 04 |
| 17 | https://code.claude.com/docs/en/costs | 컴팩션·비용 절감 | 04 |
| 18 | https://code.claude.com/docs/en/commands | 번들 스킬 언급 | 02, 04 |
| 19 | https://code.claude.com/docs/en/interactive-mode | 대화형 모드 | 04 |
| 20 | https://code.claude.com/docs/llms.txt | 문서 인덱스 (페이지 발굴용) | 04 |
| 21 | https://code.claude.com/docs/en/iam | Authentication 페이지 반환 (권한 정보는 12·10에서 확보) | 03 |

## 2. 1차 출처 — Claude 플랫폼 문서 / MCP 공식 블로그 — 10개

| # | URL | 확인한 내용 | 등급 |
|---|---|---|---|
| 22 | https://platform.claude.com/docs/en/about-claude/models | 모델 라인업·컨텍스트·출력 한도 | 1차 |
| 23 | https://platform.claude.com/docs/en/about-claude/pricing | Sonnet 5 $2/$10 → $3/$15 (2026-09-01) | 1차 |
| 24 | https://platform.claude.com/docs/en/about-claude/model-deprecations | Opus 4.1 은퇴(2026-08-05), Sonnet 4/Opus 4 은퇴(2026-06-15) | 1차 |
| 25 | https://platform.claude.com/docs/en/about-claude/models/introducing-claude-fable-5-and-claude-mythos-5 | Fable 5 / Mythos 5 GA, `stop_reason:"refusal"` | 1차 |
| 26 | https://platform.claude.com/docs/en/build-with-claude/fast-mode | Fast mode $10/$50, Batch/Priority 병용 불가 | 1차 |
| 27 | https://platform.claude.com/docs/en/api/rate-limits | Opus 5 독립 버킷 (Start tier 1,000 RPM / 2M ITPM / 400k OTPM) | 1차 |
| 28 | https://platform.claude.com/docs/en/about-claude/models/migration-guide | 마이그레이션 가이드 (Sonnet 5 breaking change 목록은 **원문에 없음** 확인) | 1차 |
| 29 | https://blog.modelcontextprotocol.io/posts/2026-07-28/ | MCP 2026-07-28 정식 릴리스, stateless 전환 | 1차 |
| 30 | https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/ | RC, SEP 거버넌스 | 1차 |

## 3. 2차·3차 출처 — GitHub — 22개

⚠️ **§5의 경고를 반드시 함께 읽을 것.** 이 세션의 GitHub 접근은 프록시를 거치며 실제 github.com의 완전한 미러가 아닐 수 있다.

| # | URL | 등급 | 확인 내용 |
|---|---|---|---|
| 31 | https://github.com/anthropics/skills | 2차 | 공식 스킬 저장소 |
| 32 | https://github.com/anthropics/skills/tree/main/skills | 2차 | 번들 스킬 17개 목록 |
| 33 | https://raw.githubusercontent.com/anthropics/skills/main/skills/pdf/SKILL.md | 2차 | **원문 확인** — progressive disclosure 구조 (REFERENCE.md, FORMS.md 분리) |
| 34 | https://github.com/anthropics/claude-plugins-official | 2차 | 공식 마켓플레이스 채널 |
| 35 | https://raw.githubusercontent.com/anthropics/claude-plugins-official/main/.claude-plugin/marketplace.json | 2차 | 마켓플레이스 정의 |
| 36 | https://github.com/anthropics/claude-plugins-community | 2차 | "Read-only mirror" 명시 확인 |
| 37 | https://github.com/anthropics/claude-code/releases | 2차 | 버전 순서(v2.1.226 최신). **타임스탬프는 신뢰 불가 — "August 8, 2024" 등 오류 연도 반환** |
| 38 | https://github.com/modelcontextprotocol/modelcontextprotocol/releases | 2차 | MCP 릴리스 태그 |
| 39 | https://github.com/obra/superpowers | 3차 | 커뮤니티 스킬 |
| 40 | https://github.com/mattpocock/skills | 3차 | 커뮤니티 스킬 |
| 41 | https://github.com/addyosmani/agent-skills | 3차 | 커뮤니티 스킬 |
| 42 | https://github.com/DietrichGebert/ponytail | 3차 | 커뮤니티 스킬 |
| 43 | https://github.com/JuliusBrussee/caveman | 3차 | 커뮤니티 스킬 |
| 44 | https://github.com/thedotmack/claude-mem | 3차 | 커뮤니티 스킬 |
| 45 | https://github.com/garrytan/gstack | 3차 | 커뮤니티 스킬 |
| 46 | https://github.com/blader/humanizer | 3차 | 커뮤니티 스킬 |
| 47 | https://github.com/OthmanAdi/planning-with-files | 3차 | 커뮤니티 스킬 |
| 48 | https://github.com/ComposioHQ/awesome-claude-skills | 3차 | 큐레이션 목록 (탈락) |
| 49 | https://github.com/jimmc414/claude-code-plugin-marketplace | 3차 | 탈락 후보 |
| 50 | https://github.com/multica-ai/andrej-karpathy-skills | 3차 | 탈락 후보 (pushed_at 2026-04-20) |
| 51 | https://github.com/ai-boost/awesome-harness-engineering | **3차** | harness engineering 정의 인용처. 2026-03-29 생성, 약 3,500 star. **1차 출처 아님** |
| 52 | https://raw.githubusercontent.com/ai-boost/awesome-harness-engineering/main/README.md | 3차 | 위 저장소 README 원문 |

**fetch 성공 URL 합계: 52개** (요구 최소 25개 충족)

---

## 4. 시도했으나 실패한 URL (인용 근거로 사용하지 않음)

### 4.1 프록시 차단 (`EGRESS_BLOCKED`)
| 도메인 | 잃은 것 |
|---|---|
| `www.anthropic.com`, `docs.anthropic.com` | 공식 뉴스 90일 전량, context engineering 정의, claude-code-best-practices 원문 |
| `claude.com`, `blog.claude.com` | auto mode 발표글, "A harness for every task" 본문 |
| `openai.com` | "OpenAI로 확산" 주장 검증 |
| `modelcontextprotocol.io` | MCP 스펙 원문 (블로그로 대체) |
| `mitchellh.com` | harness engineering 기원 주장 검증 |
| `arxiv.org`, `export.arxiv.org`, `ar5iv.labs.arxiv.org`, `huggingface.co/papers`, `semanticscholar.org`, `alphaxiv.org`, `openreview.net`, `paperswithcode.com` | **논문 6편 전량** |
| `en.wikipedia.org`, `martinfowler.com`, `newsletter.pragmaticengineer.com`, `hachyderm.io`, `dev.to`, `stackoverflow.com` 외 다수 | 2차 검증 |

### 4.2 기타 실패
| URL | 사유 |
|---|---|
| `https://code.claude.com/docs/en/release-notes` | HTTP 404 (changelog가 대체) |
| `https://api.github.com/repos/<out-of-scope>` | HTTP 403 / `"GitHub access to this repository is not enabled for this session"` — 세션 스코프 밖 저장소 차단 |
| `code.claude.com/docs/en/changelog` 의 2026-05-13 ~ 06-24 구간 | 페이지가 해당 구간을 반환하지 않음 |
| `raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md` | 응답이 자기모순적 → 신뢰 불가로 폐기 |

### 4.3 검색 스니펫으로만 접한 것 (**출처로 쓰지 않음**)
arXiv ID `2603.05344`, `2605.13357`, `2604.21003`, `2602.12670`, `2605.18747`, `2411.13768` — 실재 여부조차 미확인. `techcrunch.com` Sonnet 5 기사 — 미fetch.

---

## 5. ⚠️ 이 세션의 데이터 소스에 대한 메타 경고

레드팀이 star 상위 저장소 리더보드를 조회했을 때 실제 GitHub과 **owner명이 다른 항목**이 반환되었다:

| 이 환경 | 실제 GitHub |
|---|---|
| `react/react` | `facebook/react` |
| `nilbuild/developer-roadmap` | `kamranahmedse/developer-roadmap` |
| `openclaw/openclaw` | (미상) |

또한 필자가 직접 실행한 결과:
```
$ curl -sS https://api.github.com/repos/anthropics/skills
{"message":"GitHub access to this repository is not enabled for this session.
 Use add_repo to request access. ...", "documentation_url":"..."}
```

**따라서 §3의 GitHub 기반 정량 수치(star, pushed_at)는 "이 환경이 그렇게 응답했다"까지만 참이며, 실세계 GitHub 값으로 인용해서는 안 된다.** 02 §0 참조.

---

## 6. 교차검증 판정 이력 (작성자 ≠ 채점자)

| # | 원 주장 | 레드팀 지적 | **1차 출처 재확인 결과** | 조치 |
|---|---|---|---|---|
| 1 | "2026-07-03 기본 permission mode가 default → Manual로 변경" | 동작 변경이 아니라 UI 라벨 변경 | **레드팀 인용** — 원문: *"The mode that reviews every action is named **Manual** in the CLI... Its config value is `default`, which is what hooks and SDK integrations use."* | 01에서 정정, 영향도 High→Low 하향 |
| 2 | (누락) | 2026-08-14 auto mode 기본화 예고를 빠뜨림 | **레드팀 인용** — 원문: *"Starting August 14, 2026, auto mode becomes the default permission mode for new sessions on Pro, Max, and Team plans."* | 01·03·05에 최우선 항목으로 추가 |
| 3 | "2026-08-04 백그라운드 세션 자동 commit/push" | 실제로는 2026-07-01 (v2.1.198) | 레드팀 근거 채택 (sub-agents 문서의 v2.1.198 표기) | 01에서 날짜 정정 |
| 4 | "Stop hook 8회 연속 차단 시 강제 종료" | hooks 문서에 없음 → 창작 가능성 | **레드팀 기각.** 필자가 best-practices 원문 재fetch하여 문장 실재 확인: *"Claude Code overrides the hook and ends the turn after 8 consecutive blocks."* 단 "hooks 레퍼런스엔 없다"는 지적은 맞음 | 03에 교차검증 이력 명기, 원 주장 유지 |
| 5 | `claude plugins install mattpocock-skills` | 공식 문서에 없는 명령 형태 | 레드팀 근거 채택 | 02에서 취소선 처리 |
| 6 | star 수치 TOP10 | sanity check 부재 + 데이터 소스 신뢰도 문제 | 필자가 `curl`로 api.github.com 차단 직접 확인 | 02 §0에 경고 섹션 신설, 순위 기반 도입 판단 금지 명시 |
