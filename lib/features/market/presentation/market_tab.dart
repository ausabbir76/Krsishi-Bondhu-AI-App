import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../../settings/providers.dart';
import '../data/market_price.dart';
import '../providers.dart';

/// Market tab — daily commodity prices + marketplace preview.
class MarketTab extends ConsumerWidget {
  const MarketTab({super.key});

  /// Data-layer category keys (match `MarketPrice.category`); labels are
  /// localized separately in [_categoryLabel].
  static const _categories = [
    'Grains', 'Vegetables', 'Cash crops', 'Pulses', 'Fruits',
  ];

  static String _categoryLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'Grains' => l10n.categoryGrains,
        'Vegetables' => l10n.categoryVegetables,
        'Cash crops' => l10n.categoryCashCrops,
        'Pulses' => l10n.categoryPulses,
        _ => l10n.categoryFruits,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageControllerProvider);
    final prices = ref.watch(filteredPricesProvider);
    final selected = ref.watch(marketCategoryProvider);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return TabContentView(
      title: l10n.marketTitle,
      subtitle: l10n.marketSubtitle,
      children: [
        const SizedBox(height: 20),
        // ── Category filter ──────────────────────────────────────────
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              if (i == 0) {
                return Center(
                  child: KrishiChip(
                    label: l10n.categoryAll,
                    selected: selected == null,
                    onTap: () => ref
                        .read(marketCategoryProvider.notifier)
                        .state = null,
                  ),
                );
              }
              final cat = _categories[i - 1];
              return Center(
                child: KrishiChip(
                  label: _categoryLabel(l10n, cat),
                  selected: selected == cat,
                  onTap: () =>
                      ref.read(marketCategoryProvider.notifier).state = cat,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // ── Prices ───────────────────────────────────────────────────
        prices.when(
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
          data: (list) => Column(
            children: [
              for (final p in list) ...[
                _PriceRow(
                  price: p,
                  displayName: p.nameFor(language),
                  categoryLabel: _categoryLabel(l10n, p.category),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.section),

        // ── Marketplace preview ──────────────────────────────────────
        SectionTitle(title: l10n.marketplaceTitle),
        const SizedBox(height: 6),
        Text(
          l10n.marketplaceSubtitle,
          style: TextStyle(fontSize: 14, color: muted),
        ),
        const SizedBox(height: 12),
        SolidTile(
          title: l10n.mpInputsTitle,
          subtitle: l10n.mpInputsSub,
          icon: CupertinoIcons.bag_fill,
          accentColor: AppColors.green,
          enabled: false,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.mpMachineryTitle,
          subtitle: l10n.mpMachinerySub,
          icon: CupertinoIcons.gear_alt_fill,
          accentColor: AppColors.orange,
          enabled: false,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.mpSellTitle,
          subtitle: l10n.mpSellSub,
          icon: CupertinoIcons.money_dollar_circle_fill,
          accentColor: AppColors.purple,
          enabled: false,
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.price,
    required this.displayName,
    required this.categoryLabel,
  });

  final MarketPrice price;
  final String displayName;
  final String categoryLabel;

  @override
  Widget build(BuildContext context) {
    final up = price.changePercent > 0;
    final flat = price.changePercent == 0;
    final changeColor = flat
        ? KrishiColors.mutedText.resolveFrom(context)
        : up
            ? KrishiColors.primary.resolveFrom(context)
            : KrishiColors.danger;

    return SolidCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(price.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                Text(
                  categoryLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: KrishiColors.mutedText.resolveFrom(context),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)
                    .pricePerKg(price.pricePerKg.toStringAsFixed(2)),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!flat)
                    Icon(
                      up
                          ? CupertinoIcons.arrow_up_right
                          : CupertinoIcons.arrow_down_right,
                      size: 11,
                      color: changeColor,
                    ),
                  const SizedBox(width: 2),
                  Text(
                    '${price.changePercent.abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: changeColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
