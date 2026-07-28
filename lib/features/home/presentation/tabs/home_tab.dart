import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../ui/ui.dart';
import '../home_quick_menu.dart';


/// Home tab — the app's landing page, mirroring the marketing site:
/// hero, stats, module showcase, how-it-works, crops, roadmap teaser.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final gradient = isDark
        ? KrishiColors.primaryGradientDark
        : KrishiColors.primaryGradientLight;

    final crops = [
      l10n.cropRice,
      l10n.cropMaize,
      l10n.cropPotato,
      l10n.cropTomato,
      l10n.cropCabbage,
      l10n.cropChili,
      l10n.cropOnion,
      l10n.cropCucumber,
      l10n.cropEggplant,
      l10n.cropLentil,
      l10n.cropJute,
      l10n.cropBanana,
      l10n.cropMango,
      l10n.cropMustard,
      l10n.cropWatermelon,
    ];

    final roadmap = [
      l10n.roadmapDrone,
      l10n.roadmapIot,
      l10n.roadmapIrrigation,
      l10n.roadmapLivestock,
      l10n.roadmapPest,
      l10n.roadmapInsurance,
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                16,
                AppSpacing.pageHorizontal,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero ─────────────────────────────────────────────
                  Row(
                    children: [
                      KrishiChip(label: l10n.heroChip),
                      const Spacer(),
                      // Liquid-glass popover: the mini menu morphs out of this
                      // 3-dot button and expands downward (topRight anchors the
                      // menu's top corner to the trigger). Fixed height so the
                      // content scrolls instead of overflowing on short screens.
                      GlassPopover(
                        popoverWidth: 260,
                        popoverHeight: 320,
                        popoverBorderRadius: 22,
                        alignment: GlassMenuAlignment.topRight,
                        quality: GlassQuality.premium,
                        settings: RecommendedGlassSettings.homeBottomBar
                            .copyWith(
                          blur: 12,
                          backerColor: KrishiColors.card
                              .resolveFrom(context)
                              .withValues(alpha: 0.92),
                        ),
                        triggerBuilder: (context, toggle) => GlassButton(
                          onTap: toggle,
                          width: 44,
                          height: 44,
                          settings: RecommendedGlassSettings.interactive,
                          icon: Icon(
                            CupertinoIcons.ellipsis,
                            size: 22,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        contentBuilder: (context, close) =>
                            QuickMenuContent(onClose: close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.heroCountry,
                    style: AppTextStylesLocal.hero(context),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        LinearGradient(colors: gradient).createShader(bounds),
                    child: Text(
                      l10n.heroHeadline,
                      style: AppTextStylesLocal.hero(
                        context,
                      ).copyWith(color: CupertinoColors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.heroDescription,
                    style: TextStyle(fontSize: 15, height: 1.4, color: muted),
                  ),
                  const SizedBox(height: 20),
                  // CTA row — SolidButton: same stretchy press feel as
                  // GlassButton but a plain opaque fill, so nothing behind
                  // it is captured per frame (performance policy).
                  Row(
                    children: [
                      Expanded(
                        child: SolidButton(
                          onTap: () => context.pushNamed(Routes.diseaseScan),
                          child: Text(
                            l10n.ctaScanCrop,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.cardGap),
                      Expanded(
                        child: SolidButton(
                          onTap: () => context.pushNamed(Routes.weather),
                          child: Text(
                            l10n.ctaWeatherToday,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: CupertinoColors.label.resolveFrom(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.cardGap),

                  // ── Stats ───────────────────────────────────────────
                  // IntrinsicHeight + stretch → all three cards adopt the
                  // tallest one's height, so captions of different line
                  // counts still yield three identical boxes.
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        StatCard(
                          value: '95%',
                          caption: l10n.statDetectionAccuracy,
                        ),
                        const SizedBox(width: AppSpacing.cardGap),
                        StatCard(value: '24/7', caption: l10n.statAiAssistant),
                        const SizedBox(width: AppSpacing.cardGap),
                        StatCard(value: '50+', caption: l10n.statSupportedCrops),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.cardGap),

                  // ── Modules ─────────────────────────────────────────
                  SectionTitle(title: l10n.modulesTitle),
                  const SizedBox(height: 6),
                  Text(
                    l10n.modulesSubtitle,
                    style: TextStyle(fontSize: 14, color: muted),
                  ),
                  const SizedBox(height: 16),
                  ..._moduleCards(context, l10n),
                  const SizedBox(height: AppSpacing.cardGap),

                  // ── How it works ────────────────────────────────────
                  SectionTitle(title: l10n.howTitle),
                  const SizedBox(height: 16),
                  StepRow(
                    number: 1,
                    title: l10n.step1Title,
                    description: l10n.step1Desc,
                  ),
                  const SizedBox(height: 16),
                  StepRow(
                    number: 2,
                    title: l10n.step2Title,
                    description: l10n.step2Desc,
                  ),
                  const SizedBox(height: 16),
                  StepRow(
                    number: 3,
                    title: l10n.step3Title,
                    description: l10n.step3Desc,
                  ),
                  const SizedBox(height: AppSpacing.section),

                  // ── Crops ───────────────────────────────────────────
                  SectionTitle(title: l10n.cropsTitle),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        // Horizontal crop chips (full-bleed scroll)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
              ),
              itemCount: crops.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) =>
                  Center(child: KrishiChip(label: crops[i])),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.section,
              AppSpacing.pageHorizontal,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Roadmap teaser ────────────────────────────────────
                SectionTitle(title: l10n.roadmapTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.roadmapSubtitle,
                  style: TextStyle(fontSize: 14, color: muted),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in roadmap) KrishiChip(label: '🔜 $item'),
                  ],
                ),
                const SizedBox(height: AppSpacing.bottomBarClearance),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _moduleCards(BuildContext context, AppLocalizations l10n) {
    final modules = [
      (
        CupertinoIcons.mic_fill,
        AppColors.green,
        l10n.moduleVoiceTitle,
        l10n.moduleVoiceDesc,
        null,
      ),
      (
        CupertinoIcons.camera_viewfinder,
        AppColors.red,
        l10n.moduleDiseaseTitle,
        l10n.moduleDiseaseDesc,
        Routes.diseaseScan,
      ),
      (
        CupertinoIcons.globe,
        AppColors.cyan,
        l10n.moduleSatelliteTitle,
        l10n.moduleSatelliteDesc,
        Routes.satellite,
      ),
      (
        CupertinoIcons.layers_alt_fill,
        AppColors.orange,
        l10n.moduleSoilTitle,
        l10n.moduleSoilDesc,
        Routes.soil,
      ),
      (
        CupertinoIcons.cloud_sun_rain_fill,
        AppColors.blue,
        l10n.moduleWeatherTitle,
        l10n.moduleWeatherDesc,
        Routes.weather,
      ),
      (
        CupertinoIcons.cart_fill,
        AppColors.purple,
        l10n.moduleMarketTitle,
        l10n.moduleMarketDesc,
        null,
      ),
    ];

    return [
      for (final (icon, color, title, desc, route) in modules) ...[
        SolidTile(
          title: title,
          subtitle: desc,
          icon: icon,
          accentColor: color,
          onTap: route != null ? () => context.pushNamed(route) : null,
        ),
        const SizedBox(height: AppSpacing.cardGap),
      ],
    ];
  }
}

/// Local hero type recipe (larger than the shared page title).
abstract final class AppTextStylesLocal {
  static TextStyle hero(BuildContext context) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.5,
    color: CupertinoColors.label.resolveFrom(context),
  );
}
