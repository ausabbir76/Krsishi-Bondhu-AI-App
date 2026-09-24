import 'package:flutter/foundation.dart';

/// Compile-time environment configuration.
///
/// Values are injected with `--dart-define` (or `--dart-define-from-file`):
/// ```sh
/// flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com
/// flutter build ipa --dart-define-from-file=env/prod.json
/// ```
///
/// Add new keys here as your app grows — one place, compile-time safe.
abstract final class AppEnv {
  /// Base URL for the API client.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://surgery-glowworm-lumpish.ngrok-free.dev',
  );

  /// Environment name: `dev`, `staging`, `prod`.
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  /// Extra verbose network logging (defaults on in debug builds).
  static const bool enableNetworkLogs = bool.fromEnvironment(
    'NETWORK_LOGS',
    defaultValue: !kReleaseMode,
  );

  static bool get isProd => environment == 'prod';
  static bool get isDev => environment == 'dev';
}
