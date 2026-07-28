import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Brightness-aware glass helpers.
///
/// Replaces the `isDark ? GlassStatusBarStyle.light : GlassStatusBarStyle.dark`
/// ternary that was repeated across the app.
///
/// Named `GlassThemeHelper` because the liquid_glass_widgets package
/// already exports a `GlassTheme` class.
abstract final class GlassThemeHelper {
  /// The correct status bar style for the current theme.
  static GlassStatusBarStyle statusBarStyle(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    return isDark ? GlassStatusBarStyle.light : GlassStatusBarStyle.dark;
  }
}
