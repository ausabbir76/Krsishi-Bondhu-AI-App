import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/key_value_storage.dart';

/// App-wide brightness controller.
///
/// Replaces the old private `_BrightnessScope` InheritedWidget in main.dart.
/// The selected brightness is persisted via [KeyValueStorage] and restored
/// on the next launch.
///
/// Usage — read:
/// ```dart
/// final brightness = ref.watch(themeControllerProvider);
/// ```
/// Usage — toggle:
/// ```dart
/// ref.read(themeControllerProvider.notifier).toggle();
/// ```
class ThemeController extends Notifier<Brightness> {
  static const _storageKey = 'app.brightness';

  @override
  Brightness build() {
    final stored = ref.read(keyValueStorageProvider).getString(_storageKey);
    return stored == 'light' ? Brightness.light : Brightness.dark;
  }

  /// Switches between dark and light mode and persists the choice.
  void toggle() {
    state = state == Brightness.dark ? Brightness.light : Brightness.dark;
    ref
        .read(keyValueStorageProvider)
        .setString(_storageKey, state == Brightness.light ? 'light' : 'dark');
  }

  /// Sets an explicit [brightness] and persists the choice.
  void setBrightness(Brightness brightness) {
    if (state == brightness) return;
    state = brightness;
    ref
        .read(keyValueStorageProvider)
        .setString(_storageKey, brightness == Brightness.light ? 'light' : 'dark');
  }
}

/// Global theme (brightness) provider.
final themeControllerProvider =
    NotifierProvider<ThemeController, Brightness>(ThemeController.new);

/// Convenience provider: `true` when the app is in dark mode.
final isDarkModeProvider = Provider<bool>(
  (ref) => ref.watch(themeControllerProvider) == Brightness.dark,
);
