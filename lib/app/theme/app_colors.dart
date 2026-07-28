import 'package:flutter/cupertino.dart';

/// Centralized color palette for the app.
///
/// These are the iOS system colors that were previously hardcoded as hex
/// literals throughout the showcase (`0xFF007AFF`, `0xFF34C759`, ...).
/// Use these instead of inline hex values so accents stay consistent and
/// can be re-branded in one place.
abstract final class AppColors {
  // ── iOS system accents ─────────────────────────────────────────────
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);
  static const Color orange = Color(0xFFFF9500);
  static const Color purple = Color(0xFFAF52DE);
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color pink = Color(0xFFFF2D55);
  static const Color red = Color(0xFFFF3B30);
  static const Color cyan = Color(0xFF5AC8FA);
  static const Color indigo = Color(0xFF5856D6);
  static const Color systemBlue = Color(0xFF0A84FF);

  // ── Brand gradients used by demo/launcher cards ────────────────────
  static const List<Color> musicGradient = [Color(0xFF8B0000), Color(0xFFFA2D48)];
  static const List<Color> messagesGradient = [Color(0xFF0A4D20), Color(0xFF34C759)];
  static const List<Color> podcastsGradient = [Color(0xFF4A1A6B), Color(0xFFA855F7)];
  static const List<Color> sheetsGradient = [Color(0xFF0E4D92), Color(0xFF5AC8FA)];
  static const List<Color> amberGradient = [Color(0xFFFFB340), Color(0xFFE58600)];
  static const List<Color> brightnessGradient = [Color(0xFF1C1C2E), Color(0xFF5AC8FA)];
  static const List<Color> indicatorGradient = [Color(0xFF5E3AFF), Color(0xFF0A84FF)];

  // ── Backgrounds ────────────────────────────────────────────────────
  /// Deep navy base of the dark showcase background.
  static const Color darkBackgroundBase = Color(0xFF020715);

  /// Scaffold background used by several demos.
  static const Color demoScaffoldBackground = Color(0xFF0A0A0F);

  /// The classic Apple grouped background (light) / black (dark) used by
  /// all Apple app clones (was copy-pasted 4x as `_kBackground`).
  static const CupertinoDynamicColor appBackground =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF2F2F7),
    darkColor: Color(0xFF000000),
  );

  /// The navy/purple gradient stops shared by several component demos.
  static const List<Color> demoGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF0F3460),
    Color(0xFF533483),
  ];
}

/// KrishiBondhu AI brand palette — matched to the marketing site's green
/// theme (krishibondhu-ai.lovable.app). Dynamic colors resolve per brightness:
/// bright leaf-green accents on a near-black green in dark mode, forest green
/// on warm off-white in light mode.
abstract final class KrishiColors {
  /// Primary brand green (site `--primary`).
  static const CupertinoDynamicColor primary =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF188A4E), // forest green (light)
    darkColor: Color(0xFF4CD97B), // bright leaf green (dark)
  );

  /// Brighter glow green used for gradients/highlights (site `--primary-glow`).
  static const CupertinoDynamicColor glow =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF3FCB7E),
    darkColor: Color(0xFF7CE9A3),
  );

  /// Page background (site `--background`).
  static const CupertinoDynamicColor background =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF7FAF5),
    darkColor: Color(0xFF0C1510),
  );

  /// Solid card fill (site `--card`). Used by [SolidCard] — content surfaces
  /// are deliberately opaque (no glass/blur) for performance.
  static const CupertinoDynamicColor card =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF15231B),
  );

  /// Hairline border for solid cards (site `--border`).
  static const CupertinoDynamicColor cardBorder =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFDCE5DA),
    darkColor: Color(0x1AFFFFFF),
  );

  /// Fill for the elevated composer / header pills on the assistant screen.
  /// Tuned to sit *close to* the page [background] rather than contrast hard
  /// with it: a soft off-white (not stark white) in light mode, and a touch
  /// lighter than [card] in dark mode so the pills don't read as murky holes.
  static const CupertinoDynamicColor pillFill =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFEDF2EC), // light: soft off-white, below stark white
    darkColor: Color(0xFF1C2E24), // dark: a step lighter than card
  );

  /// Muted green-grey secondary text (site `--muted-foreground`).
  static const CupertinoDynamicColor mutedText =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFF66736A),
    darkColor: Color(0xFF9DB3A4),
  );

  /// Soft tinted fill for accent chips/badges (site `--accent`).
  static const CupertinoDynamicColor accentFill =
      CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE4F3E6),
    darkColor: Color(0xFF1D3327),
  );

  /// Primary gradient for hero text / CTA buttons (site `--gradient-primary`).
  static const List<Color> primaryGradientDark = [
    Color(0xFF35B56A),
    Color(0xFF7CE9A3),
  ];
  static const List<Color> primaryGradientLight = [
    Color(0xFF188A4E),
    Color(0xFF3FCB7E),
  ];

  /// Semantic status colors (reuse iOS system palette).
  static const Color danger = AppColors.red;
  static const Color warning = AppColors.orange;
  static const Color info = AppColors.cyan;
}
