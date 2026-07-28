import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../ui/ui.dart';

/// Tools tab — hub of every AI module plus upcoming roadmap features.
class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TabContentView(
      title: l10n.toolsTitle,
      subtitle: l10n.toolsSubtitle,
      children: [
        const SizedBox(height: AppSpacing.section),
        SectionTitle(title: l10n.sectionDiagnose),
        const SizedBox(height: 12),
        SolidTile(
          title: l10n.moduleDiseaseTitle,
          subtitle: l10n.toolDiseaseSub,
          icon: CupertinoIcons.camera_viewfinder,
          accentColor: AppColors.red,
          onTap: () => context.pushNamed(Routes.diseaseScan),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.moduleSatelliteTitle,
          subtitle: l10n.toolSatelliteSub,
          icon: CupertinoIcons.globe,
          accentColor: AppColors.cyan,
          onTap: () => context.pushNamed(Routes.satellite),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.moduleSoilTitle,
          subtitle: l10n.toolSoilSub,
          icon: CupertinoIcons.layers_alt_fill,
          accentColor: AppColors.orange,
          onTap: () => context.pushNamed(Routes.soil),
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.moduleWeatherTitle,
          subtitle: l10n.toolWeatherSub,
          icon: CupertinoIcons.cloud_sun_rain_fill,
          accentColor: AppColors.blue,
          onTap: () => context.pushNamed(Routes.weather),
        ),
        const SizedBox(height: AppSpacing.section),
        SectionTitle(title: l10n.sectionComingSoon),
        const SizedBox(height: 12),
        SolidTile(
          title: l10n.comingDroneTitle,
          subtitle: l10n.comingDroneSub,
          icon: CupertinoIcons.airplane,
          accentColor: AppColors.indigo,
          enabled: false,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.comingIotTitle,
          subtitle: l10n.comingIotSub,
          icon: CupertinoIcons.dot_radiowaves_left_right,
          accentColor: AppColors.purple,
          enabled: false,
        ),
        const SizedBox(height: AppSpacing.cardGap),
        SolidTile(
          title: l10n.comingLivestockTitle,
          subtitle: l10n.comingLivestockSub,
          icon: CupertinoIcons.paw,
          accentColor: AppColors.green,
          enabled: false,
        ),
      ],
    );
  }
}
