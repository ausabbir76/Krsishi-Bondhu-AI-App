import 'package:flutter/cupertino.dart';

/// Handy BuildContext shortcuts used across features.
extension ContextX on BuildContext {
  /// Current Cupertino brightness.
  Brightness get brightness => CupertinoTheme.of(this).brightness ?? Brightness.dark;

  /// `true` in dark mode (theme-derived; use for widget-local styling).
  bool get isDark => brightness == Brightness.dark;

  /// Screen size shortcuts.
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get viewPadding => MediaQuery.paddingOf(this);

  /// Top inset + the 44pt glass app bar — the offset repeated across pages.
  double get topBarOffset => MediaQuery.paddingOf(this).top + 44;
}
