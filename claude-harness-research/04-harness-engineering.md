# 04 — 하네스 엔지니어링 (Harness Engineering)

- 조사 기준일: 2026-08-11
- **이 문서의 결론을 먼저 밝힌다: 사용자가 전제로 제시한 프레임(Hashimoto 기원설, Information/Execution/Feedback 3계층, Inner/Outer harness, arXiv 논문군)은 이번 조사에서 1차 출처로 검증되지 않았다.** 검증 실패를 추측으로 메우지 않고 그대로 보고한다.

---

## 0. 조사 환경 제약 (이 문서 해석의 전제)

이 세션의 아웃바운드 프록시가 아래 도메인을 전면 차단(`EGRESS_BLOCKED`)했다. 하네스 엔지니어링의 **1차 출처가 될 도메인이 거의 전부 차단**되었다.

| 차단된 도메인 | 이 조사에서의 의미 |
|---|---|
| `mitchellh.com` | 용어 기원 주장의 원문 확인 불가 |
| `anthropic.com`, `docs.anthropic.com`, `claude.com` | context engineering 공식 정의 확인 불가 |
| `openai.com` | "OpenAI로 확산" 주장 확인 불가 |
| `arxiv.org`, `export.arxiv.org`, `ar5iv.labs.arxiv.org`, `huggingface.co/papers`, `semanticscholar.org`, `alphaxiv.org`, `openreview.net`, `paperswithcode.com` | **논문 원문 단 1편도 확인 불가** |
| `en.wikipedia.org`, `martinfowler.com`, 다수 개인 블로그 | 2차 출처조차 확인 불가 |

접근 가능했던 도메인: `code.claude.com`, `platform.claude.com`, `github.com`, `raw.githubusercontent.com`, `api.github.com`(세션 스코프 내), `blog.modelcontextprotocol.io`

> **WebSearch 스니펫은 "실제 fetch"가 아니다.** 검색엔진이 생성한 요약일 뿐이므로, 스니펫만으로 얻은 주장은 전부 "검증실패"로 분류했다.

---

## 1. 용어 정의 (출처 등급별 분리)

| 등급 | 용어 | 정의 (원문 인용) | 한국어 | 출처 |
|---|---|---|---|---|
| **2차 (커뮤니티 큐레이션, fetch 성공)** | harness engineering | *"the discipline of designing the scaffolding — context delivery, tool interfaces, planning artifacts, verification loops, memory systems, and sandboxes — that surrounds an AI agent"* | 에이전트를 둘러싼 **컨텍스트 전달 / 툴 인터페이스 / 계획 산출물 / 검증 루프 / 메모리 시스템 / 샌드박스**라는 뼈대를 설계하는 분야 | [ai-boost/awesome-harness-engineering](https://github.com/ai-boost/awesome-harness-engineering) |
| **3차 (재인용, 원문 미확인)** | (Anthropic 인용이라 주장되는 문장) | *"every harness component assumes the model can't do something; those assumptions expire"* | 하네스의 모든 구성요소는 "모델이 무언가를 못한다"는 전제 위에 있고, 그 전제는 만료된다 | 위 저장소의 README 내 인용. **Anthropic 원문 미확인** |
| **1차 (Anthropic 공식, 링크 제목만 확인)** | harness (Claude Code 문맥) | 블로그 제목: *"A harness for every task: dynamic workflows in Claude Code"* | — | [overview](https://code.claude.com/docs/en/overview) 페이지 내 링크 텍스트. **본문은 claude.com 차단으로 미확인** |
| **미확인** | AI Harness Engineering (학술적 정의) | 검색 스니펫에 *"a runtime substrate... so that latent model coding capability becomes auditable software-engineering behavior"* 가 반복 등장 | — | `[미확인]` — 원문 fetch 실패 |

---

## 2. 등장 배경 타임라인 — **검증 결과: 전부 실패**

사용자가 제시한 전제: *"Hashimoto 2026-02 → OpenAI/Anthropic으로 확산"*

| 주장 | 검증 상태 | 근거 |
|---|---|---|
| Mitchell Hashimoto가 2026-02(스니펫상 2026-02-05) "My AI Adoption Journey"에서 harness 개념을 제기 | **검증 실패** | `mitchellh.com` 및 이를 인용한 2차 출처(hachyderm.io, newsletter.pragmaticengineer.com, gigazine.net 등) 전부 EGRESS_BLOCKED. 날짜·워딩을 원문 대조 불가 |
| 이후 수 주 내 OpenAI/Anthropic이 용어를 확산 | **검증 실패** | `openai.com`, `anthropic.com` 전부 차단 |
| 용어의 최초 사용자가 Hashimoto인가 | **판정 불가** | "harness를 engineer한다"는 습관 서술과 "harness engineering"이라는 **용어화**는 다른 사건이다. 이 둘을 구분할 근거를 확보하지 못함 |

**추가 경고 (조사 에이전트가 직접 관찰한 패턴)**: 여러 개의 서로 다른 사이트가 거의 **동일한 문장**으로 이 기원 서사를 재생산하는 패턴이 관찰되었다. SEO 콘텐츠 팜의 반복 재생산 가능성을 배제할 수 없다. → 1차 출처 확인 전까지 이 서사를 사실로 인용하면 안 된다.

---

## 3. prompt / context / harness engineering 경계

| 축 | prompt engineering | context engineering | harness engineering |
|---|---|---|---|
| 정의 | `[미확인]` — 원문 미fetch | `[미확인]` — anthropic.com/engineering 전면 차단 | 2차 출처 기준: *"designing the scaffolding that surrounds an AI agent"* |
| 대상 | 단일 프롬프트 문구 | 모델에 주입되는 컨텍스트 전체 (툴 결과, 메모리, 검색 결과) `[정의 미확인]` | 에이전트를 둘러싼 전체 소프트웨어 시스템 (툴, 권한, 검증 루프, 메모리, 샌드박스) |
| **강제성** | 없음 | 없음 | **일부 결정론적 강제 가능** |
| 강제성 근거 (유일하게 1차 확인된 축) | — | — | 원문: *"Claude treats them as context, not enforced configuration. To block an action regardless of what Claude decides, use a PreToolUse hook instead."* — [memory](https://code.claude.com/docs/en/memory) |

> **실무적으로 유효한 유일한 구분선**: prompt/context는 *모델에게 부탁하는 것*이고, harness는 *모델이 거부해도 관철되는 것*이다. 이 구분만이 1차 출처(`code.claude.com`)로 검증되었다.

---

## 4. 레이어 구조 / Inner vs Outer — **출처 미확인 프레임**

### 4.1 Information / Execution / Feedback 3계층
**판정: 1차 출처 없음.** 하네스 엔지니어링 자료를 폭넓게 모은 큐레이션 저장소를 fetch해 분석한 결과, 해당 문서에 대한 조사 결론은 다음과 같다:

> *"The document does not contain explicit 'Inner vs. Outer harness' or 'Information/Execution/Feedback layer' definitions with those specific terms. These architectural distinctions appear absent from this particular compilation."*

즉 이 분야 큐레이션 저장소에서조차 해당 3계층 명칭이 등장하지 않는다.
→ **라벨: 출처 미확인 — 정리용 프레임으로만 사용 가능. 인용 금지.**

### 4.2 Inner harness vs Outer harness
**판정: 1차 출처 없음.** 검색 스니펫 수준에서는 "Inner = 모델 제공사가 내장한 것(Claude Code 터미널 에이전트 등), Outer = 사용자가 그 위에 조립하는 것(AGENTS.md, MCP, skill 등)"이라는 설명이 여러 블로그에서 반복되나, 해당 블로그 원문을 fetch로 확인하지 못했다.
→ **라벨: 출처 미확인 — 2차 출처 반복 재생산 패턴, 1차 소스 불명.**

### 4.3 그럼에도 이 프레임을 쓸 것인가
| 선택지 | 트레이드오프 |
|---|---|
| 프레임을 쓴다 | 설계 논의가 정리되지만, **출처 없는 용어를 사내에 유통시키는 비용**이 생김. 나중에 실제 표준이 정립되면 재교육 필요 |
| 프레임을 안 쓴다 | 용어가 없으니 논의가 장황해짐 |
| **권장** | 프레임은 쓰되 **"내부 정리용, 출처 없음"이라고 문서에 못 박고** 외부 인용·발표에는 사용하지 않는다 |

---

## 5. arXiv 논문 — **전량 검증 실패**

절대 규칙("abs 페이지를 실제 fetch해서 원문 인용")을 지킬 수 없었다. 시도한 모든 논문 미러 도메인이 차단되었다.

| arXiv ID (검색 스니펫에서만 발견) | 제목 (스니펫 기준) | 상태 |
|---|---|---|
| 2603.05344 | "Building Effective AI Coding Agents for the Terminal: Scaffolding, Harness, Context Engineering..." | **검증 실패 — abs 페이지 fetch 불가** |
| 2605.13357 | "AI Harness Engineering: A Runtime Substrate for Foundation-Model Software Agents" | **검증 실패** |
| 2604.21003 | "The Last Harness You'll Ever Build" | **검증 실패** |
| 2602.12670 | "SkillsBench: Benchmarking How Well Agent Skills Work Across Diverse Tasks" | **검증 실패** |
| 2605.18747 | "Code as Agent Harness" | **검증 실패** |
| 2411.13768 | "Evaluation-Driven Development and Operations of LLM Agents: A Process Model and Reference Architecture" | **검증 실패** (2024-11로 표기되어 존재 개연성은 상대적으로 높으나 원문 미확인) |

**이 표의 ID·제목·저자·초록 중 원문으로 재확인된 것은 하나도 없다.** 실존하는 논문인지조차 확인하지 못했다. 설계 원칙·평가 지표의 "원문 인용"은 따라서 **제공할 수 없다.**

→ **미해결 과제 1순위**: 네트워크 제약이 없는 환경에서 arXiv 6편의 실재 여부부터 확인해야 한다. 실재하지 않는 ID가 섞여 있을 가능성도 열어 둬야 한다.

---

## 6. Claude Code 기능 ↔ 하네스 계층 대조표

계층 명칭(§4가 미확인)이므로 **"정보/실행/피드백"이라는 출처 없는 명칭 대신 기능적 역할로 기술**한다. Inner/Outer 배정은 공식 출처가 없는 **판단**임을 명시한다.

| CC 기능 | 기능적 역할 | Inner/Outer (판단, 출처 없음) | **결정론적 강제** | 1차 근거 |
|---|---|---|---|---|
| CLAUDE.md | 컨텍스트 주입 | Outer | **아니오** — *"Claude treats them as context, not enforced configuration"* | [memory](https://code.claude.com/docs/en/memory) |
| Auto memory | 세션 간 학습 노트 주입 | Outer | 아니오 | [memory](https://code.claude.com/docs/en/memory) |
| Skills | 온디맨드 절차/지식 주입 | Outer | **부분적** — 기본은 모델이 관련성 판단(비결정적). `disable-model-invocation:true`면 사용자만 호출 가능(결정론적) | [skills](https://code.claude.com/docs/en/skills) |
| Slash Commands | 실행 트리거 | Outer | 아니오 (진입점일 뿐, 내용은 비강제). *Skills로 통합됨* | [skills](https://code.claude.com/docs/en/skills) |
| Subagents | **실행 격리** | Outer | **예 (격리 자체는 결정론적)** — *"Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions."* | [sub-agents](https://code.claude.com/docs/en/sub-agents) |
| **Hooks** | **실행 강제 / 검증 개입** | Outer | **예** — *"Hook decisions don't bypass permission rules... A blocking hook also takes precedence over allow rules."* exit 2 = 강제 차단 | [hooks](https://code.claude.com/docs/en/hooks), [permissions](https://code.claude.com/docs/en/permissions) |
| **Permissions (allow/ask/deny)** | **실행 통제** | Outer 설정이나 클라이언트 강제라는 점에서 Inner 성격 | **예** — *"Settings rules are enforced by the client regardless of what Claude decides to do."* deny 우선 | [permissions](https://code.claude.com/docs/en/permissions) |
| Plan Mode | 사전 승인 게이트 | Outer | **예 (대체로)** — *"Claude reads files, runs shell commands to explore, and writes a plan, but does not edit your source. Except in sessions with bypass permissions available, edits stay blocked until you approve the plan."* | [permission-modes](https://code.claude.com/docs/en/permission-modes) |
| MCP | 툴/데이터 연결 인터페이스 | Outer | 도구별 상이. `requiresUserInteraction` 툴은 강제 승인 | [mcp](https://code.claude.com/docs/en/mcp) |
| Compaction (`/compact`) | 상태 관리 / 컨텍스트 요약 | **Inner (엔진 내장)** | 부분적 — 실행은 결정론적이나 무엇을 남길지는 모델 판단. *"Replaces the conversation with a structured summary."* | [context-window](https://code.claude.com/docs/en/context-window) |

### 6.1 이 표에서 나오는 실무 결론
결정론적 강제가 **"예"** 인 것은 4개뿐이다: **Hooks / Permissions / Plan Mode / Subagent 격리.**
나머지(CLAUDE.md, Skills 본문, Slash Commands, Auto memory)는 전부 *부탁*이다.
→ **하네스를 설계한다는 것은 실질적으로 이 4개를 어떻게 배치하느냐의 문제다.** 나머지는 품질 개선이지 보장이 아니다.

---

## 7. 검증 실패 / 미확인 항목 전량 목록

| # | 항목 | 사유 |
|---|---|---|
| 1 | Hashimoto 원문 URL·날짜·워딩 | mitchellh.com EGRESS_BLOCKED |
| 2 | "OpenAI/Anthropic이 수 주 내 확산" | openai.com / anthropic.com 차단 |
| 3 | Anthropic 공식 context engineering 정의 원문 | anthropic.com/engineering 차단 |
| 4 | Information/Execution/Feedback 3계층 | 1차 출처 없음. 큐레이션 저장소에도 부재 확인 |
| 5 | Inner/Outer harness 구분의 최초 출처 | 1차 출처 불명, 2차 반복 재생산 패턴 |
| 6 | arXiv 논문 6편 전부 | 모든 논문 미러 차단. 실재 여부조차 미확인 |
| 7 | martinfowler.com의 harness engineering 글 | 링크로만 확인, 원문 fetch 실패 |
| 8 | "OpenAI가 harness engineering을 formalize했다"는 주장 | 저장소 요약에만 등장, 원문 미확인 |
| 9 | `blog.claude.com` "A harness for every task" 본문 | claude.com 차단, 제목만 확인 |

---

## 8. 인용 근거로 쓴 유일한 2차 출처의 신뢰도

`github.com/ai-boost/awesome-harness-engineering` — 커뮤니티 큐레이션 저장소.
- 1차 출처가 **아니다** (본인 정의가 아니라 남의 글 모음).
- 원문 게시일이 저장소에 표기되어 있지 않다.
- 이 저장소가 인용하는 Anthropic/OpenAI 원문을 대조 확인하지 못했다.
- → **§1의 harness engineering 정의는 "이 커뮤니티 저장소가 그렇게 정리했다"는 사실까지만 참이다.** 업계 표준 정의로 인용하면 안 된다.

(레드팀 검증 결과는 `00-EXECUTIVE-SUMMARY.md` §4 및 `SOURCES.md`에 반영)
