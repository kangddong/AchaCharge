# CLAUDE.md

> Claude Code가 본 저장소에서 작업할 때 자동으로 로드하는 컨텍스트 문서. 빌드/실행 명령, 코드베이스 컨벤션, 자주 쓰는 패턴을 기록합니다.

## 프로젝트 개요

**AchaCharge** ("아차! 충전 까먹었다")는 Game Controller의 배터리 충전 시기를 알려주는 iOS 앱입니다. 내부 Xcode 프로젝트명은 `Controllers`이며, 마케팅 표기는 `AchaCharge` 입니다.

- **핵심 기능**: Game Controller 배터리 모니터링 + 홈 화면 위젯 + 월 구독(IAP)
- **지원 OS**: iOS 14.0 이상 (일부 타깃 16.4), 위젯 동봉. macOS 타깃은 `Feature/macOSTarget` 브랜치에서 작업 중
- **외부 라이브러리 없음**: 순수 Apple 네이티브 프레임워크만 사용 (UIKit, GameController, StoreKit, WidgetKit)
- **공식 지원 컨트롤러**: Sony PlayStation DualSense Wireless Controller

상세 슬로건·외부 소개는 [README.md](README.md) 참조.

## 빌드 / 실행 / 테스트

이 프로젝트는 **Tuist도 Swift Package Manager도 사용하지 않습니다.** `Controllers.xcodeproj`를 Xcode에서 직접 열어 작업합니다.

```bash
open Controllers/Controllers.xcodeproj
```

### Scheme 목록

| Scheme | 용도 |
|---|---|
| `Controllers` | 메인 iOS 앱 |
| `ControllersWidgetExtension` | 홈 화면 위젯 |
| `ControllersTests` | 단위 테스트 |

### 주요 식별자

| 항목 | 값 |
|---|---|
| 메인 앱 번들 ID | `com.arex.achaCharge` |
| 위젯 번들 ID | `com.arex.achaCharge.widget` |
| App Group ID | `group.arex.achaCharge` |
| IAP 상품 ID (월 구독) | `com.Arex.Controller.month` |
| BG Task ID | `com.controller.battery` |

상품 ID는 [Controllers/Controllers/ProductIDs.plist](Controllers/Controllers/ProductIDs.plist)에 정의되어 있습니다.

## 디렉토리 구조

```
.
├── Controllers/                            # Xcode 프로젝트 루트
│   ├── Controllers.xcodeproj
│   ├── Controllers/                        # 메인 앱 타깃
│   │   ├── Applications/                   # AppDelegate, SceneDelegate
│   │   ├── Sources/
│   │   │   ├── Controller/                 # 메인 화면 ViewController + CircularProgressBarView
│   │   │   ├── Models/                     # GameControllerManager, StoreKitManager, StoreObserver
│   │   │   ├── Setting/                    # SettingViewController
│   │   │   └── Extensions/                 # UIColor+, UserDefaults+, StringKey+
│   │   ├── Assets.xcassets/                # 앱 아이콘 등
│   │   ├── ColorAsset.xcassets/            # 컬러 토큰
│   │   ├── Info.plist
│   │   └── ProductIDs.plist
│   ├── ControllersWidget/                  # 위젯 타깃 (SwiftUI)
│   └── ControllersTests/                   # 테스트 타깃
├── CLAUDE.md                               # 본 문서
├── ARCHITECTURE.md                         # 아키텍처 의사결정 기록
├── DESIGN.md                               # 디자인 토큰 현황·로드맵
├── docs/
│   └── index.md                            # 문서 인덱스
└── README.md
```

## 코드베이스 컨벤션

### UI 프레임워크
- **메인 앱은 UIKit**. SnapKit 등 외부 레이아웃 라이브러리 미사용 — 순수 NSLayoutConstraint / `translatesAutoresizingMaskIntoConstraints = false` 패턴
- **위젯만 SwiftUI** (WidgetKit 요구사항)
- `refactor/#8-uikit--swiftui` 브랜치에서 SwiftUI 전환이 진행 중이지만, `main` 기준은 UIKit입니다. 새로 추가하는 화면은 일단 **UIKit으로 작성**하세요.

### 상태 관리
- 싱글톤 Manager + `didSet` 옵저버 + `NotificationCenter` 조합
- 예: [ViewController.swift:87-95](Controllers/Controllers/Sources/Controller/ViewController.swift)의 `isConnected` 프로퍼티
- Combine·MVVM·@Observation 미도입 — 도메인이 단순해 의도적으로 회피

### 의존성 주입
- DI 컨테이너 없음. `SceneDelegate`에서 수동 조립 ([SceneDelegate.swift:99-127](Controllers/Controllers/Applications/SceneDelegate.swift))
- 전역 객체는 싱글톤: `GameControllerManager.shared`, `StoreKitManager` (delegate)
- 새 Manager 추가 시 같은 패턴 유지

### 영속화
- **`UserDefaults.shared`만 사용** (App Group: `group.arex.achaCharge`)
- 헬퍼: [Extensions/UserDefaults+.swift](Controllers/Controllers/Sources/Extensions/UserDefaults+.swift)
- 키는 `StringKey` 네임스페이스에 상수로 정의 — 새 키 추가 시 동일 패턴
- CoreData/Realm/Keychain 미사용. 도입 시 ARCHITECTURE.md에 의사결정 기록 필요

### 위젯 ↔ 앱 데이터 공유
- App Group `UserDefaults`를 단방향(앱 → 위젯)으로 사용
- 위젯이 사용하는 키: `StringKey.BATTERY_LEVEL`, `StringKey.CONTROLLER_CONNECTED`
- 위젯 → 앱 통신, Push, Local Notification 모두 **제거됨** (커밋 `ba362d5` 참조). 다시 도입하지 마세요.

### IAP
- **StoreKit 1** (`SKPaymentQueue`, `SKProductsRequest`) 사용 — iOS 14 지원을 위해 의도적으로 StoreKit 2 미채택
- 옵저버 등록: [AppDelegate.swift:66-68](Controllers/Controllers/Applications/AppDelegate.swift)의 `addStoreKitQueue()`
- 영수증 검증은 별도 브랜치 (`hotfix/1.0.12-iapverify`)에서 작업 중. 본 브랜치에는 미반영
- 상품 ID는 절대 코드에 하드코딩 금지 — `ProductIDs.plist`에서 로드

### 컬러
- 컬러는 `ColorAsset.xcassets`의 컬러셋으로 정의하고 `UIColor.color(name:)` ([UIColor+.swift](Controllers/Controllers/Sources/Extensions/UIColor+.swift))로 접근
- **다크모드 필수**: 신규 컬러는 Any/Dark Appearance 모두 정의

### 명명
- 파일/타입: PascalCase (`MainTabBarController`, `GameControllerManager`)
- enum case: lowerCamelCase. 단, 기존 `TabType.controlelr` 오타는 미수정 상태(별도 작업으로 분리)
- 모든 텍스트 현재 하드코딩 상태 — Localization은 DESIGN.md 로드맵 참조

## 진행 중인 변경 사항

| 브랜치 | 작업 내용 | 머지 전 주의점 |
|---|---|---|
| `refactor/#8-uikit--swiftui` | UIKit → SwiftUI 전환 | 컨벤션이 바뀔 수 있음. main에 작업 시 UIKit 유지 |
| `Feature/macOSTarget` | macOS 타깃 추가 | App Open 로직, ControllerView SwiftUI 추가 |
| `Feature/AccesorySetupKit` | AccessorySetupKit 도입 검토 | 현재 페어링은 GameController 프레임워크가 자동 처리 |
| `hotfix/1.0.12-iapverify` | 영수증 검증 핫픽스 | StoreKit 1 영수증 검증 로직 |

## 상세 문서

- [ARCHITECTURE.md](ARCHITECTURE.md) — 각 아키텍처 결정의 근거·트레이드오프·대안
- [DESIGN.md](DESIGN.md) — 디자인 토큰 As-Is 인벤토리와 토큰화 로드맵
- [docs/index.md](docs/index.md) — 전체 문서 카탈로그 및 작성 컨벤션
- [README.md](README.md) — 외부용 앱 소개

---

*기준 브랜치: `claude/happy-chaum-c8de73` · 최종 갱신: 2026-05-20*
