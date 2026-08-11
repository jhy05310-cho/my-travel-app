# MCP 서버 연결 절차 및 후보

- 기준일: 2026-08-11
- 출처: [mcp](https://code.claude.com/docs/en/mcp), [plugins](https://code.claude.com/docs/en/plugins), [best-practices](https://code.claude.com/docs/en/best-practices), [MCP blog 2026-07-28](https://blog.modelcontextprotocol.io/posts/2026-07-28/)

---

## 0. 먼저 읽을 것 — MCP를 쓰지 말아야 할 때

MCP는 기본 선택지가 아니다. 공식 best-practices 원문:

> *"CLI tools are the most context-efficient way to interact with external services. If you use GitHub, install the `gh` CLI."*

| 상황 | 권장 |
|---|---|
| CLI가 이미 있는 서비스 (GitHub, AWS, GCP, Sentry) | **CLI 우선** (`gh`, `aws`, `gcloud`, `sentry-cli`). MCP보다 컨텍스트 효율이 좋다 |
| 1회성 조회 | 그냥 직접 호출 |
| 서버를 신뢰할 수 없음 | **연결하지 마라.** 공식 문서에 prompt injection 위험이 명시되어 있다 |
| CLI가 없고 반복적으로 쓰는 구조화된 데이터 (DB, Notion, Figma, 이슈트래커) | **MCP가 적합** |

---

## 1. 스코프 3가지 — 어디에 저장되는가

| 스코프 | 저장 위치 | git 공유 | 승인 | 언제 쓰나 |
|---|---|---|---|---|
| **Local** (기본값) | `~/.claude.json` (프로젝트별 항목) | ✗ | 불필요 | 개인 실험, 개인 자격증명 |
| **Project** | `./.mcp.json` (프로젝트 루트) | **✓** | **세션마다 승인 필요** | 팀 공유 서버 |
| **User** | `~/.claude.json` | ✗ | 불필요 | 모든 프로젝트에서 쓰는 개인 서버 |

승인 이력 초기화: `claude mcp reset-project-choices`

---

## 2. 연결 절차

### 2.1 추가
```bash
# HTTP 원격 서버
claude mcp add --transport http <name> <url>

# 예 (공식 문서에 나오는 형태)
claude mcp add --transport http notion https://mcp.notion.com/mcp

# 프로젝트 스코프로 추가하려면 스코프 플래그를 확인할 것
claude mcp add --help
```

### 2.2 확인 — **"연결됐다"고 말하지 말고 이 출력을 붙일 것**
```bash
claude mcp list
```
세션 안에서는 `/mcp` 로 상태 확인. 기대 상태: `Connected`
- `cached` 상태가 보이면 정상이다. v2.1.221+ 부터 원격 HTTP/SSE 서버는 이전 세션의 tool list를 캐시해 두고 **첫 tool 호출 시 실제 연결**한다.

### 2.3 제거
```bash
claude mcp remove <name>
```

---

## 3. 연결 후 반드시 할 것

| # | 항목 | 이유 |
|---|---|---|
| 1 | `permissions.deny` 에 해당 MCP의 쓰기 도구를 등록할지 결정 | MCP tool도 permission 시스템 대상이다. 읽기 전용으로 쓸 거면 쓰기 도구를 막아라 |
| 2 | 출력 토큰 상한 확인 | 기본 **25,000 토큰**, 10,000 초과 시 경고. 큰 결과를 반환하는 서버는 `MAX_MCP_OUTPUT_TOKENS` 조정 필요 |
| 3 | tool 스키마가 deferred인지 확인 | MCP tool 스키마는 기본적으로 deferred (ToolSearch로 온디맨드 로드). 이름 목록만 상시 컨텍스트를 차지한다 |
| 4 | 서버가 반환하는 텍스트를 신뢰하지 않도록 설계 | 외부 데이터는 prompt injection 벡터다 |

---

## 4. 2026-07-28 MCP 스펙 변경이 미치는 영향

**직접 MCP 서버를 구현·운영하는 경우에만 해당된다.** 서버를 쓰기만 하면 당장 할 일은 없다.

| 변경 | 영향 |
|---|---|
| **Stateless 코어** — `initialize`/`initialized` 핸드셰이크와 `Mcp-Session-Id` 폐지 | 세션 상태에 의존하는 서버 구현은 재설계 대상 |
| Multi Round-Trip Requests | 서버 발신 요청 방식이 바뀜 |
| 헤더 기반 라우팅 (`Mcp-Method`, `Mcp-Name`) | 게이트웨이/프록시 라우팅 규칙 수정 |
| list 응답 캐시 메타데이터 (`ttlMs`, `cacheScope`) | 캐시 힌트 추가 가능 |
| RFC 9207 issuer 검증 등 인가 강화 | OAuth 구현 점검 |
| **Roots / Sampling / Logging / 구 HTTP+SSE transport** | **최소 12개월 유예 후 제거 예정.** 즉시 breaking 아님 |

출처: [blog.modelcontextprotocol.io/posts/2026-07-28](https://blog.modelcontextprotocol.io/posts/2026-07-28/)
주의: `modelcontextprotocol.io` 스펙 원문은 이 조사 환경에서 차단되어 **미확인**. 위 내용은 공식 블로그 기준이다.

---

## 5. 후보 서버 — 판단 기준과 함께

아래는 **연결 절차의 예시**이며, 각 서버의 현재 상태·URL은 이 환경에서 개별 검증하지 못했다(`anthropic.com`/`claude.com` 차단). 도입 전 각 서버 공식 문서를 직접 확인할 것.

| 후보 | 대신 CLI가 있는가 | 판단 |
|---|---|---|
| **GitHub** | **있음 (`gh`)** | CLI 우선. 공식 문서가 `gh` 설치를 권장. MCP는 `gh`로 안 되는 API가 필요할 때만 |
| **Sentry** | 있음 (`sentry-cli`) | CLI 우선 |
| **AWS / GCP** | 있음 (`aws`, `gcloud`) | CLI 우선 |
| **Notion** | 없음 | MCP 적합. `claude mcp add --transport http notion https://mcp.notion.com/mcp` (공식 문서 예시) |
| **Figma** | 없음 | MCP 적합 (디자인 → 구현 연동) |
| **Postgres / 내부 DB** | `psql` 있음 | 읽기 전용 조회면 `psql` 로 충분. 스키마 탐색을 반복하면 MCP 검토. **쓰기 도구는 반드시 deny** |
| **이슈트래커 (Linear/Jira)** | 부분적 | 반복 작업이면 MCP 적합 |

### 5.1 도입 판정 3문항
1. **CLI로 되는가?** → 되면 CLI. 끝.
2. **반복해서 쓰는가?** → 1회성이면 MCP 설정 비용이 손해.
3. **서버를 신뢰하는가?** → 아니면 연결하지 않는다. 연결한다면 쓰기 도구를 `permissions.deny` 로 막는다.

---

## 6. 이 환경(Claude Code on the web)의 제약

이 세션에서 실측된 제약이다. 로컬 CLI 환경과 다르다.

| 제약 | 실측 내용 |
|---|---|
| 아웃바운드 프록시 | `anthropic.com`, `claude.com`, `arxiv.org`, `modelcontextprotocol.io`, `mitchellh.com` 등 다수 도메인이 `EGRESS_BLOCKED` |
| GitHub API | `api.github.com` 직접 호출 시 세션 스코프 밖 저장소는 차단됨. 실측 응답: `"GitHub access to this repository is not enabled for this session. Use add_repo to request access."` |
| MCP 도구 | 세션에 연결된 MCP 서버 도구는 ToolSearch로 온디맨드 로드됨 |
| 인터랙티브 인증 MCP | 헤드리스/크론 실행에서는 사용 불가할 수 있음 |
