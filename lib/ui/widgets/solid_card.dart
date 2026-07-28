import 'package:flutter/cupertino.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Opaque content card — the standard surface for everything that scrolls.
///
/// Plain [Container] with a solid [KrishiColors.card] fill and hairline
/// border: no glass, no blur, no shaders. Glass is reserved for floating
/// navigation chrome (tab bar, app bar, menus, sheets); scrollable content
/// uses this for performance.
class SolidCard extends StatelessWidget {
  const SolidCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = AppSpacing.radiusMedium,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  /// Override fill color (defaults to [KrishiColors.card]).
  final Color? color;

  /// Optional tap handler; wraps the card in a [GestureDetector].
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? KrishiColors.card.resolveFrom(context),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: KrishiColors.cardBorder.resolveFrom(context)),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: card);
  }
}

/// A tappable solid row tile: tinted icon box + title + subtitle + chevron.
///
/// Solid-fill sibling of the glass `LauncherTile` — same layout, no shader.
class SolidTile extends StatelessWidget {
  const SolidTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.onTap,
    this.trailing,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  /// Trailing widget; defaults to a chevron.
  final Widget? trailing;

  /// When false the tile is dimmed (used for "coming soon" entries).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final label = CupertinoColors.label.resolveFrom(context);
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SolidCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: KrishiColors.mutedText.resolveFrom(context),
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  CupertinoIcons.chevron_right,
                  color: label.withValues(alpha: 0.35),
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}

/// Compact stat block: big value + small caption (e.g. "95%" / "Accuracy").
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.caption,
  });

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SolidCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: KrishiColors.primary.resolveFrom(context),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: KrishiColors.mutedText.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small rounded pill chip with a tinted background (crops, tags, statuses).
class KrishiChip extends StatelessWidget {
  const KrishiChip({
    super.key,
    required this.label,
    this.color,
    this.onTap,
    this.selected = false,
  });

  final String label;

  /// Accent; defaults to [KrishiColors.primary].
  final Color? color;
  final VoidCallback? onTap;

  /// Selected chips get a stronger fill.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? KrishiColors.primary.resolveFrom(context);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? accent.withValues(alpha: 0.28)
            : KrishiColors.accentFill.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? accent
              : KrishiColors.cardBorder.resolveFrom(context),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected
              ? CupertinoColors.label.resolveFrom(context)
              : KrishiColors.mutedText.resolveFrom(context),
        ),
      ),
    );
    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}

/// Numbered how-it-works step row: green number badge + title + description.
class StepRow extends StatelessWidget {
  const StepRow({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  final int number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: KrishiColors.mutedText.resolveFrom(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
