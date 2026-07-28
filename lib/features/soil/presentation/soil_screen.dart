import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../data/soil_analysis.dart';
import '../providers.dart';

/// Soil intelligence — enter a location, get crop & fertilizer guidance.
class SoilScreen extends ConsumerStatefulWidget {
  const SoilScreen({super.key});

  @override
  ConsumerState<SoilScreen> createState() => _SoilScreenState();
}

class _SoilScreenState extends ConsumerState<SoilScreen> {
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final analysis = ref.watch(soilControllerProvider);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return AppPage(
      title: l10n.soilTitle,
      background: const KrishiBackground(),
      children: [
        Text(
          l10n.soilIntro,
          style: TextStyle(fontSize: 14, height: 1.4, color: muted),
        ),
        const SizedBox(height: 20),
        GlassTextField(
          controller: _locationController,
          placeholder: l10n.locationPlaceholder,
          settings: RecommendedGlassSettings.input,
          textInputAction: TextInputAction.done,
          onSubmitted: (v) =>
              ref.read(soilControllerProvider.notifier).analyze(v),
          prefixIcon: Icon(CupertinoIcons.location_solid,
              size: 18, color: primary),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SizedBox(
          width: double.infinity,
          child: SolidButton(
            onTap: () => ref
                .read(soilControllerProvider.notifier)
                .analyze(_locationController.text),
            enabled: !analysis.isLoading,
            child: analysis.isLoading
                ? const GlassProgressIndicator.circular(size: 20)
                : Text(
                    l10n.analyzeSoil,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        switch (analysis) {
          AsyncData(:final value) when value != null =>
            _SoilResultView(analysis: value),
          AsyncError(:final error) => SolidCard(
              child: Text(l10n.analysisFailed('$error'),
                  style: const TextStyle(fontSize: 14)),
            ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _SoilResultView extends StatelessWidget {
  const _SoilResultView({required this.analysis});

  final SoilAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SolidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.layers_alt_fill,
                      size: 18, color: AppColors.orange),
                  const SizedBox(width: 8),
                  Text(l10n.soilReportTitle(analysis.location),
                      style: TextStyle(fontSize: 13, color: muted)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _NutrientBlock(label: 'pH', value: '${analysis.ph}'),
                  _NutrientBlock(label: 'N', value: analysis.nitrogen),
                  _NutrientBlock(label: 'P', value: analysis.phosphorus),
                  _NutrientBlock(label: 'K', value: analysis.potassium),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.recommendedCropLabel,
                  style: TextStyle(fontSize: 13, color: muted)),
              const SizedBox(height: 4),
              Text(
                analysis.recommendedCrop,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: KrishiColors.primary.resolveFrom(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(l10n.expectedYieldLabel(analysis.expectedYield),
                  style: TextStyle(fontSize: 14, color: label)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.scissors,
                      size: 17, color: AppColors.green),
                  const SizedBox(width: 8),
                  Text(l10n.fertilizerPlan,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: label)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                analysis.fertilizerAdvice,
                style: TextStyle(fontSize: 14, height: 1.4, color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutrientBlock extends StatelessWidget {
  const _NutrientBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: KrishiColors.primary.resolveFrom(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: KrishiColors.mutedText.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
