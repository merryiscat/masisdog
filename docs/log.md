# 작업 로그

> `## [YYYY-MM-DD] <작업> | <제목>` 한 줄씩 append-only.

## [2026-08-15] 킥오프 3부 | 스택 집계·하네스 확정
- `docs/stack.md` 생성 — 필요기술 4계층(두뇌/폰제어/외부연동/개발하네스), 스택 확정, 빌드 순서(M0→척추1 읽기전용→척추2 자율행동→트랙4개)
- 하네스 판정: `playwright` MCP 제거(스택에 웹 브라우저 없음), 나머지 5개 유지. 스킬 신규 0
- 근거: [stack.md](stack.md) §3

## [2026-08-15] 유즈케이스 | UC-16 수신 문자 브리핑 추가
- "문자 요약" 갈래 A(지출)는 UC-8에 흡수 확인, 갈래 B(전체 수신문자 중요도 분류·브리핑)는 별 케이스로 UC-16 신규
- derived_from: 대화 2026-08-15

## [2026-08-15] 개발환경 | 1단계=adb 단독, Android Studio는 2단계
- 1단계는 platform-tools(adb)만 설치하면 됨(mobile-mcp·uiautomator2 둘 다 adb만 요구). Android Studio 불필요
- Android Studio는 2단계 네이티브 앱 빌드 시 설치. 에뮬레이터 택하면 1단계에도 필요하나 계획은 실물 폰
- stack.md §④에 반영

## [2026-08-15] 호출어 확정 | "마스야"
- 음성 호출어 = "마스야"로 확정. UC-5·14 및 overview 반영, pending에서 해소
- asserted(사용자 발화 2026-08-15)

## [2026-08-15] 이름 확정 | masisdog = "마스 is dog", 강아지 마스
- 이름 뜻 확정: masisdog = "마스(Mas) is dog", 폰 관리 강아지 캐릭터 이름=마스. git 핸들 merryiscat="Merry is cat"(고양이 메리)의 강아지판
- 마스코트: 강아지 디자인, 이름 마스. 형제 프로젝트 크리스(Chris) 존재(별개)
- overview.md 이름·개념 정정, 호출어 마스 vs 마시스독 재확인을 pending에 등록
- asserted(사용자 발화 2026-08-15)

## [2026-08-15] 개요 | overview.md 추가 (비개발자용 입구)
- 사용자가 "프로젝트 이름·구조를 잘 모른다(다 맡겨서)" → 위키 입구로 쉬운말 개요 작성
- 핵심 정리: masisdog엔 **DB·서버 없음**(온디바이스). "DB 구조(Supabase)"는 별개 프로젝트 Odin의 것 — 혼동 해소
- 이름 뜻·확정은 미확인으로 표시(저장소명 masisdog 그대로 사용)
- derived_from: 대화 2026-08-15

## [2026-08-15] llmwiki init | docs를 LLM 위키로 초기화
- index/log/pending + Stop·SessionStart 훅 설치, CLAUDE.md 스키마 블록 추가
- 기존 문서 plan/usecases/stack을 index에 등재
