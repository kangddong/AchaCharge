# DESIGN.md

> AchaCharge의 디자인 토큰 현황(As-Is)과 토큰화 로드맵(To-Be)을 정리합니다. 현재 토큰화 수준은 **초기 단계**이며, 대부분의 폰트·여백·텍스트가 하드코딩 상태입니다.

## 개요

본 프로젝트는 의도된 디자인 시스템이 존재하지 않으며, "필요할 때 만든 값"이 ViewController 곳곳에 흩어져 있습니다. 이 문서의 목표는:

1. 현재 어떤 토큰이 존재하는지 (**As-Is 인벤토리**)
2. 어떤 우선순위로 토큰화를 진행할지 (**To-Be 로드맵**)
3. 신규 작업 시 따를 명명·다크모드 정책

을 명문화하는 것입니다.

---

## As-Is: 정의된 토큰

### 컬러

토큰화된 컬러는 `ColorAsset.xcassets`의 2개뿐입니다. 나머지는 `UIColor.systemXxx` 또는 직접 RGB 값으로 하드코딩되어 있습니다.

| 이름 | Light | Dark | 위치 |
|---|---|---|---|
| `tabBarBackgroundColor` | `#F9F9F9` | `#111113` | `ColorAsset.xcassets/tabBarBackgroundColor.colorset` |
| `tabBarTintColor` | `#D8D8D8` | `#1F1F1F` | `ColorAsset.xcassets/tabBarTintColor.colorset` |
| `Controller` | (정의됨) | (정의됨) | `Assets.xcassets/Controller.colorset` |
| `AccentColor` | 미설정 | 미설정 | `Assets.xcassets/AccentColor.colorset` |

**접근 헬퍼**: [Extensions/UIColor+.swift](Controllers/Controllers/Sources/Extensions/UIColor+.swift)
```swift
UIColor.color(name: "tabBarBackgroundColor")
```

**다크모드 지원**: 정의된 컬러셋은 Any/Dark Appearance 모두 정의됨. 신규 컬러도 동일 정책.

### 폰트

> ❌ **폰트 토큰 미정의**. 커스텀 폰트 등록 없음(`Info.plist`의 `UIAppFonts` 없음), `Font` enum 또는 `UIFont` extension 없음.

현재 사용 중인 시스템 폰트 사이즈(전부 하드코딩):

| 사용처 | 값 |
|---|---|
| `batteryStateLabel` | `UIFont.boldSystemFont(ofSize: 25)` |
| `refreshButton`, `testButton` | `UIFont.systemFont(ofSize: 24, weight: .semibold)` |
| `CircularProgressBarView` 내부 텍스트 | `UIFont.systemFont(ofSize: 25)` |

### Spacing / Layout

> ❌ **Spacing 토큰 미정의**. 4/8/16/24 등 베이스 스케일 없음.

현재 하드코딩된 주요 값:

| 항목 | 값 |
|---|---|
| `loadingView` 높이 | 120 |
| `indicatorView` 사이즈 | 80 |
| `gamePadImageView` | 180 × 130 |
| `batteryStateLabel` top margin | 36 |
| `refreshButton` top margin | 57 |
| `testButton` 사이즈 | 100 |
| `CircularProgressBar` line width | 20 |
| `CircularProgressBar` radius | 160 |

### 효과 (그림자, 코너, 보더)

> ❌ **효과 토큰 미정의**. 정식 토큰 없이 부분적으로만 적용.

현재 사용 중:
- `CircularProgressBarView`: `CAShapeLayer.lineCap = .round` (둥근 선 끝)
- 색 투명도: `UIColor.systemGreen.withAlphaComponent(0.3)`

### 이미지 / 아이콘

- 커스텀 이미지: `AppIcon.appiconset` (1개 PNG)
- **나머지는 SF Symbols 사용** — 유지보수 간단
  - `gamecontroller.fill` / `gamecontroller` (탭바, 게임패드 표시)
  - `gearshape.fill` / `gearshape` (설정 탭)
  - `arrow.clockwise` (새로고침)

**위젯 에셋**: `ControllersWidget/Assets.xcassets`에 `AccentColor`, `WidgetBackground` 컬러셋 별도 존재.

### Localization

> ❌ **미구현**. `Localizable.strings` / `.xcstrings` 모두 없음. 모든 사용자 노출 텍스트가 하드코딩.

현재 하드코딩된 텍스트 예시:
- "Not connected.."
- "Refresh"
- "IAP Test"
- "Controller", "Setting" (TabType 표시명)

`Base.lproj`에 `LaunchScreen.storyboard`만 존재 — 다국어 분기 없음.

---

## As-Is: 공통 컴포넌트 인벤토리

명시적인 "DesignSystem" 폴더는 없으며, 컴포넌트가 기능 폴더에 흩어져 있습니다.

| 컴포넌트 | 위치 | 용도 |
|---|---|---|
| `CircularProgressBarView` | [Sources/Controller/CircularProgressBarView.swift](Controllers/Controllers/Sources/Controller/CircularProgressBarView.swift) | 메인 화면 원형 배터리 게이지 |
| `MainTabBarController` 스타일링 | [Sources/MainTabBarController.swift:67-74](Controllers/Controllers/Sources/MainTabBarController.swift) | 탭바 상단 경계선·색상 |
| `ProgressBar`, `CircularProgressBar` (위젯) | `ControllersWidget/ProgressBar.swift` | 위젯용 배터리 게이지 (SwiftUI) |

> ⚠️ 앱과 위젯에서 비슷한 "원형 게이지" 컴포넌트가 별도로 존재합니다. UIKit/SwiftUI 분리 때문이긴 하지만, 향후 디자인 토큰 공유 시점에 매개변수(컬러·두께·라벨 폰트)를 통일 권장.

---

## To-Be: 토큰화 로드맵

우선순위 순. 각 항목은 별도 작업으로 분리 가능한 단위.

### 🥇 1순위 — 폰트 토큰

현재 가장 분산되어 있어 변경 시 누락 위험이 가장 큰 항목.

**제안 구조**:
```swift
// Sources/DesignSystem/Font+Token.swift (신규)
extension UIFont {
    enum Token {
        static let title       = UIFont.systemFont(ofSize: 25, weight: .bold)
        static let body        = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let button      = UIFont.systemFont(ofSize: 24, weight: .semibold)
        static let captionMono = UIFont.monospacedDigitSystemFont(ofSize: 25, weight: .regular)
    }
}
```

**적용 대상**: `batteryStateLabel`, `refreshButton`, `testButton`, `CircularProgressBarView` 텍스트

### 🥈 2순위 — Spacing 토큰

8pt 그리드 베이스 권장 (iOS 인터페이스 가이드라인 친화적).

**제안 구조**:
```swift
// Sources/DesignSystem/Spacing.swift (신규)
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}
```

**전환 시 주의**: 120/180/130 같은 큰 값은 컴포넌트 사이즈이지 spacing이 아니므로, "컴포넌트 사이즈"와 "여백"을 구분해서 분류.

### 🥉 3순위 — Localization (`.xcstrings`)

iOS 16+ 의 `.xcstrings`(String Catalog) 권장. deployment target과 충돌하면 Legacy `.strings` 사용.

**최소 지원 언어**: 한국어(`ko`) + 영어(`en`)

**1차 추출 대상 키**:
- `controller_tab_title`, `setting_tab_title`
- `controller_not_connected`, `controller_refresh`
- `setting_iap_test`

### 4순위 — 컬러 토큰 확장

시스템 컬러 의존도를 낮추고 시맨틱 컬러를 도입.

**제안 추가 항목**:
- `accentColor` (브랜드 컬러 — 현재 미설정 상태)
- `batteryLevelHigh`, `batteryLevelMedium`, `batteryLevelLow` (현재 `systemGreen`만 사용)
- `surfacePrimary`, `surfaceSecondary` (배경 계층화)

신규 컬러는 모두 Light/Dark 둘 다 정의 필수.

### 5순위 — DesignSystem 폴더 신설 + 컴포넌트 라이브러리

`Controllers/Sources/DesignSystem/` 신설:

```
Sources/
├── DesignSystem/
│   ├── Tokens/
│   │   ├── Font+Token.swift
│   │   ├── Spacing.swift
│   │   └── Colors.swift
│   ├── Components/
│   │   ├── CircularGauge.swift   (UIKit/SwiftUI 공통화)
│   │   └── PrimaryButton.swift
│   └── README.md
```

기존 `Sources/Controller/CircularProgressBarView.swift` 와 위젯의 `ProgressBar.swift` 를 `CircularGauge` 컴포넌트로 통합.

---

## 명명 규칙

### 컬러
- 컴포넌트 종속: `{component}{Variant}Color` — 예: `tabBarBackgroundColor`, `tabBarTintColor`
- 시맨틱: `{semantic}Color` — 예: `accentColor`, `batteryLevelLow`

### 폰트 토큰
- 역할 기반: `title`, `body`, `caption`, `button` (사이즈 직접 표기 지양)

### Spacing
- 사이즈 스케일: `xs`, `sm`, `md`, `lg`, `xl`, `xxl`

### 이미지
- SF Symbols 우선 사용
- 커스텀 이미지셋이 필요한 경우 `{domain}_{role}` 패턴 (예: `controller_dualsense`)

---

## 다크모드 정책

- **모든 신규 컬러는 Any Appearance + Dark Appearance 두 가지 모두 정의 필수**
- 시스템 컬러(`.label`, `.systemBackground` 등)는 자동 다크모드 적용되므로 안전
- 하드코딩 RGB 사용 금지 — 반드시 컬러셋으로 등록

---

## 컴포넌트 통합 가이드 (UIKit ↔ SwiftUI)

위젯 SwiftUI 컴포넌트가 메인 앱(UIKit)에서 재사용되는 경우는 현재 없습니다. 단, 두 곳 모두에 비슷한 "원형 게이지"가 존재하므로, 디자인 토큰을 도입한 뒤 다음 중 한 가지 방식으로 통합 권장:

- 옵션 A: SwiftUI로 통일하고 UIKit 측에서 `UIHostingController`로 래핑
- 옵션 B: 토큰만 공유(폰트·컬러·spacing)하고 컴포넌트 코드는 분리 유지

선택 시점은 ARCHITECTURE.md 결정 #1(UIKit→SwiftUI 마이그레이션)의 결과에 의존합니다.

---

*기준 브랜치: `claude/happy-chaum-c8de73` · 최종 갱신: 2026-05-20*
