import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../../satellite/presentation/satellite_screen.dart'
    show kDistricts, districtLabel;
import '../providers.dart';

/// Weather intelligence — forecast + Bangla farming advisory.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  static IconData _icon(String key) => switch (key) {
        'sun' => CupertinoIcons.sun_max_fill,
        'rain' => CupertinoIcons.cloud_rain_fill,
        'storm' => CupertinoIcons.cloud_bolt_rain_fill,
        _ => CupertinoIcons.cloud_fill,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final district = ref.watch(weatherDistrictProvider);
    final forecast = ref.watch(weatherForecastProvider);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final label = CupertinoColors.label.resolveFrom(context);

    return AppPage(
      title: l10n.weatherTitle,
      background: const KrishiBackground(),
      children: [
        Text(
          l10n.weatherIntro,
          style: TextStyle(fontSize: 14, height: 1.4, color: muted),
        ),
        const SizedBox(height: 20),
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
                    .read(weatherDistrictProvider.notifier)
                    .state = kDistricts[i],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.section),
        forecast.when(
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
          data: (w) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Today hero ────────────────────────────────────────
              SolidCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        l10n.districtToday(
                            districtLabel(l10n, w.district)),
                        style: TextStyle(fontSize: 13, color: muted)),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${w.todayHigh}°',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            height: 1,
                            color: label,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('/ ${w.todayLow}°',
                              style:
                                  TextStyle(fontSize: 20, color: muted)),
                        ),
                        const Spacer(),
                        Icon(
                          CupertinoIcons.cloud_sun_fill,
                          size: 44,
                          color: AppColors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(w.condition,
                        style: TextStyle(fontSize: 15, color: label)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        KrishiChip(label: l10n.humidityChip('${w.humidity}')),
                        const SizedBox(width: 8),
                        KrishiChip(label: l10n.rainChip('${w.rainChance}')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── Alerts (only when active) ─────────────────────────
              if (w.alerts.isNotEmpty) ...[
                for (final alert in w.alerts) ...[
                  SolidCard(
                    child: Row(
                      children: [
                        const Icon(
                            CupertinoIcons.exclamationmark_triangle_fill,
                            size: 20,
                            color: KrishiColors.danger),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(alert,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: label)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.cardGap),
                ],
              ],

              // ── Bangla advisory ───────────────────────────────────
              SolidCard(
                color: KrishiColors.accentFill.resolveFrom(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.lightbulb_fill,
                            size: 17,
                            color:
                                KrishiColors.primary.resolveFrom(context)),
                        const SizedBox(width: 8),
                        Text(l10n.advisoryTitle,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: label)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(w.advisoryBn,
                        style: TextStyle(
                            fontSize: 15, height: 1.5, color: label)),
                    const SizedBox(height: 4),
                    Text(w.advisoryEn,
                        style: TextStyle(
                            fontSize: 13, height: 1.4, color: muted)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.cardGap),

              // ── 4-day strip ───────────────────────────────────────
              SolidCard(
                child: Row(
                  children: [
                    for (final d in w.daily)
                      Expanded(
                        child: Column(
                          children: [
                            Text(d.day,
                                style: TextStyle(
                                    fontSize: 12, color: muted)),
                            const SizedBox(height: 8),
                            Icon(_icon(d.icon),
                                size: 24, color: AppColors.blue),
                            const SizedBox(height: 8),
                            Text('${d.high}°',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: label)),
                            Text('${d.low}°',
                                style: TextStyle(
                                    fontSize: 12, color: muted)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
