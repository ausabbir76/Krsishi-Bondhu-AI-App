import 'package:flutter/cupertino.dart';

/// Centralized text styles.
///
/// These capture the recurring type recipes that were previously inlined
/// dozens of times across the showcase (34/w700/-0.5 page titles,
/// 22-24/bold section titles, 13-15 muted body text, ...).
///
/// All styles that need theme-aware colors take a [BuildContext] and
/// resolve through [CupertinoColors] so they adapt to light/dark mode.
abstract final class AppTextStyles {
  /// Large page title — `fontSize: 34, w700, letterSpacing: -0.5`.
  static TextStyle pageTitle(BuildContext context) => TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.label.resolveFrom(context),
        letterSpacing: -0.5,
      );

  /// Page subtitle shown under [pageTitle].
  static TextStyle pageSubtitle(BuildContext context) => TextStyle(
        fontSize: 15,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      );

  /// Hero subtitle (17pt) used on the Explore tab.
  static TextStyle heroSubtitle(BuildContext context) => TextStyle(
        fontSize: 17,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
        letterSpacing: -0.2,
      );

  /// Section title — `fontSize: 24, bold` (catalog pages).
  static TextStyle sectionTitle(BuildContext context) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.label.resolveFrom(context),
      );

  /// Sub-section title — `fontSize: 22, w700, -0.3` (home tab "Widget Catalog").
  static TextStyle subsectionTitle(BuildContext context) => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.label.resolveFrom(context),
        letterSpacing: -0.3,
      );

  /// Card title — 16pt/w600.
  static TextStyle cardTitle(BuildContext context) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.label.resolveFrom(context),
      );

  /// Card subtitle — small muted caption.
  static TextStyle cardSubtitle(BuildContext context) => TextStyle(
        fontSize: 12,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
      );

  /// Muted body text (13pt at 60% label).
  static TextStyle mutedBody(BuildContext context) => TextStyle(
        fontSize: 13,
        color: CupertinoColors.label.resolveFrom(context).withValues(alpha: 0.6),
      );

  /// Section label in ALL-CAPS with letter spacing (demo control panels).
  static const TextStyle capsLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: Color(0xB3FFFFFF), // white70
  );
}
