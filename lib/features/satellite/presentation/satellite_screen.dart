import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../providers.dart';

/// Common districts offered in the picker; the API accepts any district name.
/// These are data-layer keys — display labels come from [districtLabel].
const kDistricts = [
  'Rangpur', 'Dhaka', 'Bogura', 'Rajshahi', 'Khulna',
  'Sylhet', 'Chattogram', 'Barishal', 'Mymensingh', 'Dinajpur',
];

/// Localized display name for a district key.
String districtLabel(AppLocalizations l10n, String key) => switch (key) {
      'Rangpur' => l10n.districtRangpur,
      'Dhaka' => l10n.districtDhaka,
      'Bogura' => l10n.districtBogura,
      'Rajshahi' => l10n.districtRajshahi,
      'Khulna' => l10n.districtKhulna,
      'Sylhet' => l10n.districtSylhet,
      'Chattogram' => l10n.districtChattogram,
      'Barishal' => l10n.districtBarishal,
      'Mymensingh' => l10n.districtMymensingh,
      _ => l10n.districtDinajpur,
    };

/// Satellite intelligence — NDVI and field conditions for a district.
class SatelliteScreen extends ConsumerWidget {
  const SatelliteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final district = ref.watch(satelliteDistrictProvider);
    final analysis = ref.watch(satelliteAnalysisProvider);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return AppPage(
      title: l10n.satelliteTitle,
      background: const KrishiBackground(),
      children: [
        Text(
          l10n.satelliteIntro,
          style: TextStyle(fontSize: 14, height: 1.4, color: muted),
        ),
        const SizedBox(height: 20),
        SubSectionLabel(label: l10n.districtLabel),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kDistricts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => Center(
              child: KrishiChip(
                label: districtLabel(l10n, kDistricts[i]),
                selected: kDistricts[i] == district,
                onTap: () => ref
                    .read(satelliteDistrictProvider.notifier)
                    .state = kDistricts[i],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        analysis.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: GlassProgressIndicator.circular(),
            ),
          ),
          error: (error, _) => SolidCard(
            child: Text(l10n.loadFailed('$error'),
                style: const TextStyle(fontSize: 14)),
          ),
          data: (a) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NDVI hero card
              SolidCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.globe,
                            size: 18, color: AppColors.cyan),
                        const SizedBox(width: 8),
                        Text(
                            l10n.districtSuffix(
                                districtLabel(l10n, a.district)),
                            style: TextStyle(fontSize: 13, color: muted)),
                        const Spacer(),
                        KrishiChip(label: a.cropHealth),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'NDVI ${a.ndvi.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: KrishiColors.primary.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Simple NDVI bar (0–1)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 8,
                        child: Row(
                          children: [
                            Expanded(
                              flex: (a.ndvi * 100).round(),
                              child: Container(
                                color: KrishiColors.primary
                                    .resolveFrom(context),
                              ),
                            ),
                            Expanded(
                              flex: 100 - (a.ndvi * 100).round(),
                              child: Container(
                                color: KrishiColors.accentFill
                                    .resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),
              SolidTile(
                title: l10n.waterStress,
                subtitle: a.waterStress,
                icon: CupertinoIcons.drop_fill,
                accentColor: AppColors.blue,
                trailing: const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.cardGap),
              SolidTile(
                title: l10n.floodRisk,
                subtitle: a.floodRisk,
                icon: CupertinoIcons.waveform_path,
                accentColor: AppColors.indigo,
                trailing: const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.cardGap),
              SolidTile(
                title: l10n.yieldEstimate,
                subtitle: a.yieldEstimate,
                icon: CupertinoIcons.chart_bar_alt_fill,
                accentColor: AppColors.orange,
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
