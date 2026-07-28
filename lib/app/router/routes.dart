/// Central route name/path registry.
///
/// Use these constants with `context.goNamed(...)` / `context.pushNamed(...)`
/// instead of raw strings so typos become compile errors.
abstract final class Routes {
  // ── Shell (5-tab home) ─────────────────────────────────────────────
  static const String home = 'home';
  static const String homePath = '/';

  // ── AI tool screens (pushed from Tools tab / Home showcase) ────────
  static const String diseaseScan = 'disease-scan';
  static const String satellite = 'satellite';
  static const String soil = 'soil';
  static const String weather = 'weather';

  /// Path for a top-level route: `/disease-scan`, `/weather`, ...
  static String pathOf(String name) => '/$name';
}
