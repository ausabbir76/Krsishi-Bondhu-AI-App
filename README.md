# KrishiBondhu AI 🌾

An AI-powered agricultural assistant app for Bangladeshi farmers. Built with Flutter, featuring crop disease detection, satellite field intelligence, soil analysis, weather forecasting, market prices, and a bilingual (English/Bangla) AI chat assistant.

---

## Features

| Tab | Description |
|-----|-------------|
| **Home** | Hero landing, stats, module showcase, crop chips, roadmap |
| **Assistant** | Multi-session AI chat, persisted history, Bangla/English |
| **Tools** | Hub for all 4 AI analysis screens |
| **Market** | Daily commodity prices with category filter |
| **Settings** | Theme (dark/light), language, notifications, account |

### AI Tool Screens
- **Disease Scan** — Pick or capture a crop photo → AI diagnosis with organic/chemical treatment + prevention advice
- **Satellite** — Select a district → NDVI, crop health, water stress, flood risk, yield estimate
- **Soil** — Enter a location → NPK levels, recommended crop, fertilizer plan
- **Weather** — Select a district → 4-day forecast + Bangla farming advisory

---

## Tech Stack

- **Flutter** 3.x / Dart 3.x
- **Riverpod 3.x** — state management
- **GoRouter** — navigation
- **Dio** — HTTP client
- **liquid_glass_widgets** — iOS 26-style glass UI (nav chrome only)
- **SharedPreferences** — key-value persistence
- **flutter_secure_storage** — token storage
- **connectivity_plus** — network status
- **image_picker** — camera/gallery access
- **flutter_localizations** — en/bn l10n via generated `AppLocalizations`

---

## Project Structure

```
lib/
├── main.dart                    # Entry point → bootstrap()
├── app/
│   ├── app.dart                 # Root CupertinoApp.router
│   ├── bootstrap.dart           # Init: glass engine, storage, error handlers
│   ├── router/                  # GoRouter + route name constants
│   └── theme/                   # AppColors, AppTextStyles, AppSpacing, ThemeController
├── core/
│   ├── config/app_env.dart      # --dart-define env vars
│   ├── connectivity/            # isOnlineProvider
│   ├── errors/                  # AppException hierarchy + Result<T>
│   ├── logging/app_logger.dart
│   ├── network/                 # ApiClient (Dio wrapper), interceptors
│   └── storage/                 # KeyValueStorage, SecureStorage
├── features/
│   ├── _template/               # Copy this to scaffold a new feature
│   ├── assistant/               # Chat controller, sessions, repository
│   ├── disease/                 # ScanController, DiseaseRepository
│   ├── home/                    # HomeScreen shell, tabs, quick-menu
│   ├── market/                  # MarketRepository, price filter
│   ├── satellite/               # SatelliteRepository, district picker
│   ├── settings/                # Language, theme, notifications, account
│   ├── soil/                    # SoilController, SoilRepository
│   └── weather/                 # WeatherRepository, forecast
├── l10n/                        # Generated AppLocalizations (en + bn)
└── ui/                          # Shared design system
    ├── backgrounds/             # KrishiBackground, ShowcaseBackground, GradientBackground
    ├── glass/                   # GlassPresets, GlassThemeHelper
    ├── layout/                  # AppPage, TabContentView
    └── widgets/                 # SolidCard, SolidTile, SolidButton, KrishiChip, ...
```

---

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.x
- Dart SDK ≥ 3.12.2

### Run

```bash
flutter pub get
flutter run
```

### With environment variables

```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENV=dev
```

Or use a file:

```bash
flutter run --dart-define-from-file=env/dev.json
```

### Build

```bash
# Android
flutter build apk --dart-define-from-file=env/prod.json

# iOS
flutter build ipa --dart-define-from-file=env/prod.json
```

---

## Backend Status

All AI features currently use **mock data**. Each repository has a `*Mock` method active and a real `*` method ready. See [GUIDE.md](GUIDE.md) for the full backend integration plan.

---

## Localization

ARB files are in `lib/l10n/`. After editing, regenerate:

```bash
flutter gen-l10n
```

Supported locales: `en`, `bn`.

---

## Tests

```bash
flutter test
```

- `test/widget_test.dart` — app boots and renders home
- `test/router_test.dart` — all route names registered

---

## License

Private — not published to pub.dev.
