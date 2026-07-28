import 'package:flutter/widgets.dart';

/// Small colored pill badge, e.g. "PREMIUM" / "STANDARD".
///
/// Replaces the `_QualityBadge` duplicated in interactive_page and
/// overlays_page (and similar pills in quality_comparison_demo).
class QualityBadge extends StatelessWidget {
  const QualityBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
