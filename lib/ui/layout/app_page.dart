import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../backgrounds/showcase_background.dart';
import '../glass/glass_presets.dart';
import '../glass/glass_theme.dart';
import '../widgets/glass_back_button.dart';

/// The standard catalog-page shell.
///
/// Reproduces — pixel-identically — the ~60-line structure that was
/// copy-pasted across the six catalog pages:
///
/// `GlassPage → Scaffold(extendBodyBehindAppBar) → GlassAppBar(back button)
/// → GlassScrollEdgeEffect → CustomScrollView(top spacer, 34pt title,
/// padded content column, 100pt bottom clearance)`
///
/// Usage:
/// ```dart
/// AppPage(
///   title: 'Surfaces',
///   children: [
///     SectionTitle(title: 'GlassAppBar'),
///     ...
///   ],
/// )
/// ```
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.children,
    this.background,
    this.settings,
    this.appBarActions,
    this.wrapInTransparentMaterial = false,
  });

  /// Large page title (iOS 26 inline style, 34pt w700).
  final String title;

  /// Page content, laid out in a start-aligned column with 24pt padding.
  final List<Widget> children;

  /// Page background; defaults to [ShowcaseBackground].
  final Widget? background;

  /// Ambient glass settings; defaults to [RecommendedGlassSettings.standard].
  final LiquidGlassSettings? settings;

  /// Optional action widgets for the app bar.
  final List<Widget>? appBarActions;

  /// Wraps the body in a transparent [Material] — needed by pages that use
  /// Material ink widgets (containers page did this).
  final bool wrapInTransparentMaterial;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    Widget body = GlassScrollEdgeEffect(
      topFadeHeight: topInset + 44 + 40,
      fadeBottom: false,
      child: CustomScrollView(
        slivers: [
          // Space for the app bar + safe area
          SliverToBoxAdapter(child: SizedBox(height: topInset + 44)),
          // ── Large page title (iOS 26 inline style) ──────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (wrapInTransparentMaterial) {
      body = Material(type: MaterialType.transparency, child: body);
    }

    return GlassPage(
      background: background ?? const ShowcaseBackground(),
      settings: settings ?? RecommendedGlassSettings.standard,
      statusBarStyle: GlassThemeHelper.statusBarStyle(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(
          leading: const GlassBackButton(),
          actions: appBarActions,
        ),
        body: body,
      ),
    );
  }
}
