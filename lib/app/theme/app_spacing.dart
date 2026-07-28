/// Centralized layout metrics.
///
/// Captures the magic numbers that repeated throughout the showcase:
/// the 44pt glass app-bar height, 24pt horizontal page padding, the 64pt
/// bottom bar height used by the Apple app clones, etc.
abstract final class AppSpacing {
  // ── Page layout ────────────────────────────────────────────────────
  /// Standard horizontal page padding.
  static const double pageHorizontal = 24;

  /// Vertical gap between cards in a grid/list.
  static const double cardGap = 14;

  /// Standard section spacing.
  static const double section = 32;

  /// Bottom padding so scroll content clears the floating bottom bar.
  static const double bottomBarClearance = 120;

  /// Bottom padding for catalog pages.
  static const double pageBottomClearance = 100;

  // ── Glass bars ─────────────────────────────────────────────────────
  /// Height of [GlassAppBar] content area.
  static const double appBarHeight = 44;

  /// Bottom bar height used by the Apple app clones (`_kBarH`).
  static const double clonesBarHeight = 64;

  /// Horizontal padding around clone bottom bars (`_kPaddingH`).
  static const double clonesBarPaddingH = 20;

  /// Vertical padding around clone bottom bars (`_kPaddingV`).
  static const double clonesBarPaddingV = 16;

  /// Spacing between clone bar elements (`_kSpacing`).
  static const double clonesBarSpacing = 8;

  // ── Common radii ───────────────────────────────────────────────────
  static const double radiusSmall = 12;
  static const double radiusMedium = 16;
  static const double radiusLarge = 20;
}
