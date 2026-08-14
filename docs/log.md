# 작업 로그

> `## [YYYY-MM-DD] <작업> | <제목>` 한 줄씩 append-only.

## [2026-08-15] 킥오프 3부 | 스택 집계·하네스 확정
- `docs/stack.md` 생성 — 필요기술 4계층(두뇌/폰제어/외부연동/개발하네스), 스택 확정, 빌드 순서(M0→척추1 읽기전용→척추2 자율행동→트랙4개)
- 하네스 판정: `playwright` MCP 제거(스택에 웹 브라우저 없음), 나머지 5개 유지. 스킬 신규 0
- 근거: [stack.md](stack.md) §3

## [2026-08-15] 유즈케이스 | UC-16 수신 문자 브리핑 추가
- "문자 요약" 갈래 A(지출)는 UC-8에 흡수 확인, 갈래 B(전체 수신문자 중요도 분류·브리핑)는 별 케이스로 UC-16 신규
- derived_from: 대화 2026-08-15

## [2026-08-15] 개요 | overview.md 추가 (비개발자용 입구)
- 사용자가 "프로젝트 이름·구조를 잘 모른다(다 맡겨서)" → 위키 입구로 쉬운말 개요 작성
- 핵심 정리: masisdog엔 **DB·서버 없음**(온디바이스). "DB 구조(Supabase)"는 별개 프로젝트 Odin의 것 — 혼동 해소
- 이름 뜻·확정은 미확인으로 표시(저장소명 masisdog 그대로 사용)
- derived_from: 대화 2026-08-15

## [2026-08-15] llmwiki init | docs를 LLM 위키로 초기화
- index/log/pending + Stop·SessionStart 훅 설치, CLAUDE.md 스키마 블록 추가
- 기존 문서 plan/usecases/stack을 index에 등재
