# masisdog 기획서

> 에이전트-퍼스트 폰. 온디바이스 LLM 에이전트가 폰의 관리자로 상주한다. 개인용, 상업화는 결과 보고 판단.

## 1. 프로젝트 정의

폰을 켜면 앱 그리드가 아니라 에이전트가 있고, 앱은 에이전트가 대신 조작하며,
저장공간·네트워크·알림·화면을 에이전트가 관장한다. 재부팅에도 스스로 권한을 복구하며 생존한다.

## 2. 핵심 결정 — 왜 커스텀 OS가 아니라 앱 계층인가

- 원래 구상은 "폰을 밀고 내 OS를 올려 GPS·인터넷의 온전한 소유권"이었다.
- **갤럭시는 불가**: One UI 8(Android 16, 2025-07)부터 부트로더 언락 코드 자체가 제거됨. 전 지역.
  구형(One UI 7 이하)으로 버텨도 삼성은 AOSP 디바이스 트리를 안 줘서 올릴 커스텀 ROM이 없다.
- **커스텀 OS가 필요하면** 기기를 바꿔야 함: Pixel(AOSP 공식 지원) 또는 OnePlus(스냅드래곤+언락 유지).
- **그러나** 원하는 것의 대부분("에이전트가 폰을 운영")은 순정 안드로이드 앱 계층에서 달성 가능.
  → 앱 계층으로 시작해 검증하고, 천장에 부딪히면 그때 기기를 옮긴다. 앱 코드는 그대로 이식됨(매몰비용 0).

## 3. 능력과 천장 (순정 갤럭시 앱 계층 기준)

### 되는 것
| 영역 | 수단 |
|------|------|
| 홈 화면 장악 | 런처 교체 |
| 알림 읽기/삭제/답장 | Notification Listener + RemoteInput |
| 앱 조작 | Accessibility Service (UI 트리 구독 + 제스처 주입) |
| 위치 | Location API (백그라운드 위치까지) |
| 모든 트래픽 장악 | VPNService (루트 없이 전 트래픽 통과 — 차단/모니터/라우팅) |
| 공유 저장소 전체 | MANAGE_EXTERNAL_STORAGE (사진·다운로드·문서·미디어) |
| 실시간 로그 | logcat 스트림, dumpsys, UsageStatsManager |
| 시스템 관리 | Shizuku(=상시 ADB shell): 앱 강제종료/설치/제거/비활성화, 권한 grant, 설정 쓰기, input 주입 |
| 온디바이스 LLM | Termux + llama.cpp, foreground service 상시 구동 |

### 안 되는 것 (갤럭시 영구 제약)
1. **다른 앱의 프라이빗 데이터**(/data/data, 예: 카톡 DB) — 샌드박스. 루트 없이 불가. Shizuku로도 안 됨.
   우회는 "앱이 밖으로 내보내는 것"(알림·화면·공유저장소 파일)만 잡는 것.
2. **시스템 자체 개조** — 시스템 파티션/프레임워크/커널. 관리는 해도 개조는 못 함.

→ 이 둘이 꼭 필요해지는 순간이 **Pixel/OnePlus로 넘어갈 타이밍.**

## 4. Shizuku 부활 체인 (재부팅 후 무인 복구)

재부팅 시 Shizuku(shell 권한)와 무선 디버깅은 꺼지지만, 다음 체인으로 에이전트가 스스로 복구한다.

- 살아남는 것: Accessibility Service(부팅 자동 재시작), 한 번 grant한 `WRITE_SECURE_SETTINGS`(영구), 무선 디버깅 페어링
- 체인:
  1. 부팅 → 에이전트 앱 Accessibility Service + boot receiver 자동 기동
  2. `WRITE_SECURE_SETTINGS`로 `settings put global adb_wifi_enabled 1` (UI 없이 코드로 무선 디버깅 ON)
  3. Shizuku가 무선 디버깅에 self-connect (페어링은 최초 1회)
  4. shell 권한 복구 완료
  - 폴백: Accessibility로 설정 앱 직접 탐색해 토글 ON
- 남는 리스크: Wi-Fi 필수(무선 디버깅은 Wi-Fi에서만), OS 업데이트/개발자옵션 초기화 시 재페어링.
  → 평시 재부팅은 무인 복구, 예외 시에만 "몇 달에 한 번 정비" 수준.
- **이 부활 체인을 초기 마일스톤에 포함** — 에이전트 생존이 다른 모든 기능의 토대.

## 5. 폰 조작 = Playwright의 안드로이드판

대응: DOM→UI 트리(accessibility tree), 셀렉터→resource-id/텍스트, page.click()→탭 주입.

- **1단계 (PC에서 폰 조작, 지금)**:
  - `adb` 원시: `uiautomator dump`(UI 트리 XML) + `input tap/swipe/text` + `screencap`
  - **`mobile-mcp`**: Playwright MCP의 폰 버전. Claude Code 세션에서 직접 폰을 읽고 탭하며 실험 → 코드 0줄로 개념 검증
  - `uiautomator2`(Python, openatx): LLM 파이프라인에 끼우기 제일 편함. Mobile-Agent 계열이 이걸 씀
  - `Maestro`: DX가 Playwright에 가장 가까움(YAML 플로우). `Appium`: 무겁지만 표준
  - `scrcpy`: 화면 미러링+수동 개입 (자동화 아님, 지켜보기용)
- **2단계 (온디바이스 자체 조작)**: Accessibility Service가 Playwright 역할 (이벤트 기반 UI 트리 + 제스처 주입)
- 화면 인식: UI 트리 우선, 트리가 못 읽는 화면(게임·커스텀 렌더링)은 스크린샷+비전 모델 보조 (하이브리드)

## 6. 마일스톤

- [ ] **M0. LLM 성능 벤치**: 갤럭시에서 Termux+llama.cpp로 3~8B 모델 토큰 속도 측정.
      이 숫자가 "온디바이스 단독 vs 온디바이스+클라우드 하이브리드" 설계를 결정.
- [ ] **M1. PC 조작 검증(첫 슬라이스)**: mobile-mcp/uiautomator2로 "알림 오면 LLM이 요약 → 답장 액션으로 대신 답장".
      Accessibility 없이 Notification Listener + RemoteInput만으로 되는 최소 시나리오.
- [ ] **M2. 부활 체인 PoC**: WRITE_SECURE_SETTINGS + 무선 디버깅 self-connect로 재부팅 후 Shizuku 자동 복구.
- [ ] **M3. 온디바이스 이식**: 검증된 조작 로직을 Accessibility Service 기반 앱으로.

## 7. 기기 전략

- 현재: 보유 갤럭시(순정)로 M0~M3 진행. 앱 계층 코드는 안드로이드 기기 간 이식 가능.
- 이전 트리거: §3의 "안 되는 것"이 실제로 막힘이 될 때 → Pixel(AOSP 빌드 경험) 또는 OnePlus(성능+언락) 중고.
