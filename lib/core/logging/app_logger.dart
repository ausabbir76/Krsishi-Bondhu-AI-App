import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// App-wide structured logger.
///
/// Usage:
/// ```dart
/// ref.read(loggerProvider).i('User signed in');
/// AppLogger.instance.e('Request failed', error: e, stackTrace: st);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger instance = Logger(
    level: kReleaseMode ? Level.warning : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      colors: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(String message) => instance.d(message);
  static void i(String message) => instance.i(message);
  static void w(String message, {Object? error}) =>
      instance.w(message, error: error);
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      instance.e(message, error: error, stackTrace: stackTrace);
}

/// Provider so services can take the logger as a dependency (testable).
final loggerProvider = Provider<Logger>((ref) => AppLogger.instance);
