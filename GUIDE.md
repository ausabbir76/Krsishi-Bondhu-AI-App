# KrishiBondhu AI — Backend Integration Guide

This guide covers everything needed to connect the app to a live backend. All AI features currently use mock data. Each swap is a one-line change in the feature's `providers.dart`.

---

## 1. Environment Setup

All API config lives in `lib/core/config/app_env.dart` via `--dart-define`:

```json
// env/dev.json
{
  "API_BASE_URL": "https://dev-api.krishibondhu.ai",
  "ENV": "dev",
  "NETWORK_LOGS": "true"
}
```

```json
// env/prod.json
{
  "API_BASE_URL": "https://api.krishibondhu.ai",
  "ENV": "prod",
  "NETWORK_LOGS": "false"
}
```

Run with:
```bash
flutter run --dart-define-from-file=env/dev.json
```

---

## 2. Authentication

The auth interceptor (`lib/core/network/interceptors/auth_interceptor.dart`) already attaches `Bearer <token>` to every request. You only need to store the token after login.

**Steps:**
1. Create `lib/features/auth/` using the `_template` folder as a base.
2. On successful login, write the token:
```dart
await ref.read(secureStorageProvider).write(
  SecureStorageKeys.accessToken,
  response.accessToken,
);
```
3. On logout, clear it:
```dart
await ref.read(secureStorageProvider).deleteAll();
```
4. Wire `AccountController.signIn()` / `signOut()` in `lib/features/settings/account.dart` to your auth flow.

---

## 3. Swapping Mock → Real: One Line Per Feature

Every feature repository has two methods: a real one and a `*Mock` one. The provider file is the only place to change.

### Disease Scan
**File:** `lib/features/disease/providers.dart`
```dart
// Before (mock):
final result = await ref.read(diseaseRepositoryProvider).analyzeMock(path, locale: locale);

// After (real):
final result = await ref.read(diseaseRepositoryProvider).analyze(path, locale: locale);
```

### Satellite Analysis
**File:** `lib/features/satellite/providers.dart`
```dart
// Before:
.fetchMock(district, locale: locale);

// After:
.fetch(district, locale: locale);
```

### Soil Analysis
**File:** `lib/features/soil/providers.dart`
```dart
// Before:
.analyzeMock(location.trim(), locale: locale);

// After:
.analyze(location.trim(), locale: locale);
```

### Weather Forecast
**File:** `lib/features/weather/providers.dart`
```dart
// Before:
.fetchMock(district, locale: locale);

// After:
.fetch(district, locale: locale);
```

### Market Prices
**File:** `lib/features/market/providers.dart`
```dart
// Before:
.fetchMockPrices();

// After:
.fetchPrices();
```

### AI Assistant
**File:** `lib/features/assistant/providers.dart` — inside `ChatController.send()`:
```dart
// Before:
final result = await ref.read(assistantRepositoryProvider).sendMock(...);

// After:
final result = await ref.read(assistantRepositoryProvider).send(...);
```

---

## 4. API Contract Reference

Each repository documents its endpoint. Summary:

| Feature | Method | Endpoint |
|---------|--------|----------|
| Disease | POST multipart | `/disease/detect` |
| Satellite | GET | `/satellite/analysis?district=&locale=` |
| Soil | POST JSON | `/soil/analyze` |
| Weather | GET | `/weather/forecast?district=&locale=` |
| Market | GET | `/market/prices` |
| Assistant | POST JSON | `/assistant/chat` |

All responses are decoded in the repository's `decode:` lambda — update `fromJson` factories if the real API shape differs from the mock.

---

## 5. Adding a New Feature

Copy `lib/features/_template/` and follow this checklist:

```
lib/features/your_feature/
├── data/
│   ├── your_model.dart          # Domain model + fromJson/toJson
│   └── your_repository.dart     # ApiClient calls + mock variant
├── presentation/
│   └── your_screen.dart         # ConsumerWidget using AppPage shell
└── providers.dart               # Repository provider + controller/FutureProvider
```

1. Add route name in `lib/app/router/routes.dart`
2. Add `_route(Routes.yourFeature, child: const YourScreen())` in `app_router.dart`
3. Add a `SolidTile` entry in `features/home/presentation/tabs/tools_tab.dart`
4. Add l10n strings to `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`, then run `flutter gen-l10n`

---

## 6. Localization (Adding Strings)

Edit `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`, then regenerate:

```bash
flutter gen-l10n
```

Parametrized strings use ICU syntax:
```json
"loadFailed": "Failed to load: {error}",
"@loadFailed": { "placeholders": { "error": { "type": "String" } } }
```

---

## 7. Error Handling Pattern

All repositories return `Result<T>`. Never throw to the UI layer:

```dart
final result = await repository.fetch(...);
state = switch (result) {
  Success(:final value) => AsyncData(value),
  Failure(:final error) => AsyncError(error, StackTrace.current),
};
```

The `AppException` hierarchy (`lib/core/errors/app_exception.dart`) covers:
- `NetworkException` — no connection, timeout
- `ServerException` — 4xx/5xx with `statusCode`
- `UnauthorizedException` — 401/403 → trigger re-login
- `ParsingException` — bad response shape
- `StorageException` — local storage failure
- `UnknownException` — catch-all

---

## 8. Connectivity Guard

Use `isOnlineProvider` to gate network calls:

```dart
final isOnline = ref.watch(isOnlineProvider);
if (!isOnline) {
  state = AsyncError(NetworkException('No internet connection'), StackTrace.current);
  return;
}
```

---

## 9. Secure Token Refresh

When the backend returns 401, add a refresh interceptor in `lib/core/network/interceptors/auth_interceptor.dart`:

```dart
@override
void onError(DioException err, ErrorInterceptorHandler handler) async {
  if (err.response?.statusCode == 401) {
    // 1. Call refresh endpoint
    // 2. Write new token via secureStorage
    // 3. Retry original request
  }
  handler.next(err);
}
```

---

## 10. Testing

- `test/widget_test.dart` — smoke test; override `keyValueStorageProvider` with `_FakeStorage`
- `test/router_test.dart` — verifies all route names are registered

For new features, add:
```dart
test('repository returns Success on valid response', () async {
  // Use a mock ApiClient or DioAdapter
});
```

---

## 11. Build & Release

```bash
# Android APK
flutter build apk --dart-define-from-file=env/prod.json

# Android App Bundle (Play Store)
flutter build appbundle --dart-define-from-file=env/prod.json

# iOS
flutter build ipa --dart-define-from-file=env/prod.json
```

Bump version in `pubspec.yaml`:
```yaml
version: 1.1.0+2   # name+buildNumber
```

---

## 12. Roadmap Features (Planned)

These are already listed in the UI as "Coming Soon":

| Feature | Notes |
|---------|-------|
| Drone monitoring | New feature screen under Tools |
| IoT sensor integration | Likely a new data stream provider |
| Smart irrigation | Could extend Weather + Soil screens |
| Livestock health | New feature following `_template` pattern |
| Pest forecasting | Extend Disease feature or new screen |
| Crop insurance | Likely external link or new feature |

Each follows the same pattern: copy `_template`, add route, add tile in `tools_tab.dart`.
