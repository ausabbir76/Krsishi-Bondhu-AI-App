import 'package:flutter/material.dart';

/// Labeled slider row with a live value badge.
///
/// Centralizes `_SliderRow` (indicator_parity_demo), `_Slider`
/// (quality_comparison_demo) and the inline CupertinoSlider rows used in
/// other demos.
class LabeledSliderRow extends StatelessWidget {
  const LabeledSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.displayValue,
    this.activeColor,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  /// Formatted value shown in the badge; defaults to 2-decimal.
  final String? displayValue;

  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noOverlay,
              trackHeight: 2,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              activeColor: activeColor ?? const Color(0xFF0A84FF),
              onChanged: onChanged,
            ),
          ),
        ),
        Container(
          width: 44,
          alignment: Alignment.centerRight,
          child: Text(
            displayValue ?? value.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal row of selectable chips.
///
/// Centralizes `_ChipRow` (bottom_bar_tab_width_demo), the scenario chips in
/// searchable_bar_demo and the preset chips in quality_comparison_demo.
class ChipRow extends StatelessWidget {
  const ChipRow({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.accentColor = const Color(0xFF0A84FF),
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < options.length; i++)
          GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: i == selectedIndex
                    ? accentColor.withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: i == selectedIndex
                      ? accentColor
                      : Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                options[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      i == selectedIndex ? FontWeight.w600 : FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
