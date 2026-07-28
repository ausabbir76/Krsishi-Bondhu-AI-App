import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../glass/glass_presets.dart';

/// The standard 44×44 glass back button used in app bars.
///
/// Matches the assistant chat screen's floating back button exactly: a
/// [GlassButton.custom] on its own premium glass layer using the bottom-nav
/// recipe ([RecommendedGlassSettings.homeBottomBar]), so every back button in
/// the app reads as the same material as the tab bar.
class GlassBackButton extends StatelessWidget {
  const GlassBackButton({
    super.key,
    this.quality = GlassQuality.premium,
    this.onTap,
  });

  /// Rendering quality (premium by default, matching the catalog pages).
  final GlassQuality quality;

  /// Custom tap handler; defaults to `Navigator.pop`.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassButton.custom(
      quality: quality,
      useOwnLayer: true,
      settings: RecommendedGlassSettings.homeBottomBar,
      onTap: onTap ?? () => Navigator.of(context).pop(),
      width: 44,
      height: 44,
      child: Icon(
        CupertinoIcons.back,
        size: 22,
        color: CupertinoColors.label.resolveFrom(context),
      ),
    );
  }
}
