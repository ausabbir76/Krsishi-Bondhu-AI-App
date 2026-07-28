import 'package:flutter/cupertino.dart';

/// Standard section title — 24pt bold, theme-aware.
///
/// Replaces the byte-identical private `_SectionTitle` that was copy-pasted
/// in six catalog pages.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.label.resolveFrom(context),
      ),
    );
  }
}

/// Small muted sub-section label (13pt, 50% label color).
///
/// Replaces the duplicated `_QualityLabel` / `_SubSectionLabel` helpers.
class SubSectionLabel extends StatelessWidget {
  const SubSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        color:
            CupertinoColors.label.resolveFrom(context).withValues(alpha: 0.5),
      ),
    );
  }
}
