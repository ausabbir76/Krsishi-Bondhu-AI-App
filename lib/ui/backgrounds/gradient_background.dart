import 'package:flutter/widgets.dart';

import '../../app/theme/app_colors.dart';

/// The navy → purple gradient background shared by several component demos.
///
/// Was copy-pasted (as an inline `Container` or a free `_buildBackground()`
/// function) in bottom_bar_tab_width, searchable_bar, text_field,
/// shape_debug and stretch_test demos.
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, this.colors = AppColors.demoGradient});

  /// Gradient stops, top-left → bottom-right.
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}
