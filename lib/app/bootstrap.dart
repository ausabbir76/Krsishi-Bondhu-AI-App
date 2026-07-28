import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';
import '../core/storage/key_value_storage.dart';
import 'app.dart';

/// Single entry point for app initialization.
///
/// Everything a production app needs at startup happens here — in order:
///  1. Flutter bindings
///  2. Liquid glass engine ([LiquidGlassWidgets.initialize])
///  3. Persistent storage
///  4. Global error handlers
///  5. runApp inside a guarded zone with Riverpod + glass wrap
///
/// `main.dart` stays a one-liner: `void main() => bootstrap();`
Future<void> bootstrap() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Liquid glass shaders/engine — must run before any glass widget.
      await LiquidGlassWidgets.initialize();

      // Storage ready before first frame so theme loads synchronously.
      final prefs = await SharedPreferences.getInstance();

      // Route framework errors through our logger.
      FlutterError.onError = (details) {
        AppLogger.e(
          'FlutterError: ${details.exceptionAsString()}',
          error: details.exception,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.e('Uncaught platform error', error: error, stackTrace: stack);
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [
            keyValueStorageProvider.overrideWithValue(SharedPrefsStorage(prefs)),
          ],
          child: LiquidGlassWidgets.wrap(child: const App()),
        ),
      );
    },
    (error, stack) =>
        AppLogger.e('Uncaught zone error', error: error, stackTrace: stack),
  );
}
