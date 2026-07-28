import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../../assistant/presentation/assistant_tab.dart';
import '../../market/presentation/market_tab.dart';
import '../../settings/presentation/settings_tab.dart';
import '../providers.dart';
import 'tabs/home_tab.dart';
import 'tabs/tools_tab.dart';

/// App shell — glass bottom tab bar hosting the five main sections.
///
/// Glass is used only for this floating navigation chrome; the tab bodies
/// render solid-fill content over [KrishiBackground].
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedTab = ref.watch(homeTabIndexProvider);
    // GlassScaffold pins the bottom bar to the screen edge and relies on the
    // system nav inset for spacing. Two cases leave it with zero breathing
    // room, so we add our own lift:
    //  • devices without a system nav-bar inset (gesture nav with the hint
    //    bar hidden) report viewPadding.bottom == 0 → bar glued to the edge;
    //  • an open keyboard collapses the safe-area padding and the resized
    //    scaffold parks the bar flush against the keyboard.
    // viewPadding (not padding) is read because it survives keyboard opening.
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final double barLift = keyboard > 0 ? 8 : (systemBottom > 0 ? 0 : 10);
    final tabs = [
      GlassTab(
        label: l10n.tabHome,
        icon: const Icon(CupertinoIcons.house),
        activeIcon: const Icon(CupertinoIcons.house_fill),
      ),
      GlassTab(
        label: l10n.tabAssistant,
        icon: const Icon(CupertinoIcons.chat_bubble_2),
        activeIcon: const Icon(CupertinoIcons.chat_bubble_2_fill),
      ),
      GlassTab(
        label: l10n.tabTools,
        icon: const Icon(CupertinoIcons.square_grid_2x2),
        activeIcon: const Icon(CupertinoIcons.square_grid_2x2_fill),
      ),
      GlassTab(
        label: l10n.tabMarket,
        icon: const Icon(CupertinoIcons.cart),
        activeIcon: const Icon(CupertinoIcons.cart_fill),
      ),
      GlassTab(
        label: l10n.tabSettings,
        icon: const Icon(CupertinoIcons.gear),
        activeIcon: const Icon(CupertinoIcons.gear_solid),
      ),
    ];

    return GlassScaffold(
      background: const KrishiBackground(),
      statusBarStyle: GlassThemeHelper.statusBarStyle(context),
      settings: RecommendedGlassSettings.standard,
      topEdgeFade: true,
      bottomBar: Padding(
        padding: EdgeInsets.only(bottom: barLift),
        child: GlassTabBar.bottom(
          selectedIndex: selectedTab,
          onTabSelected: (i) =>
              ref.read(homeTabIndexProvider.notifier).state = i,
          interactionBehavior: GlassInteractionBehavior.full,
          selectedIconColor: KrishiColors.primary.resolveFrom(context),
          iconSize: 28,
          labelFontSize: 10,
          iconLabelSpacing: 0,
          verticalPadding: 0,
          settings: RecommendedGlassSettings.homeBottomBar,
          tabs: tabs,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: switch (selectedTab) {
          0 => const HomeTab(key: ValueKey('home')),
          1 => const AssistantTab(key: ValueKey('assistant')),
          2 => const ToolsTab(key: ValueKey('tools')),
          3 => const MarketTab(key: ValueKey('market')),
          _ => const SettingsTab(key: ValueKey('settings')),
        },
      ),
    );
  }
}
