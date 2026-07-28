import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'showcase_background.dart';

/// KrishiBondhu brand background — solid green-tinted base with two static
/// green glow orbs (plain radial gradients, no shaders/blur — cheap to paint).
///
/// Deliberately simpler than [ShowcaseBackground]: content surfaces in this
/// app are solid, so the backdrop only needs a soft brand wash behind the
/// glass navigation chrome.
class KrishiBackground extends StatelessWidget {
  const KrishiBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final glow = KrishiColors.glow.resolveFrom(context);
    return Container(
      color: KrishiColors.background.resolveFrom(context),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: GlowOrb(
              size: 480,
              colors: [
                glow.withValues(alpha: isDark ? 0.14 : 0.20),
                glow.withValues(alpha: isDark ? 0.04 : 0.07),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          Positioned(
            bottom: -140,
            right: -120,
            child: GlowOrb(
              size: 460,
              colors: [
                glow.withValues(alpha: isDark ? 0.10 : 0.14),
                Colors.transparent,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
