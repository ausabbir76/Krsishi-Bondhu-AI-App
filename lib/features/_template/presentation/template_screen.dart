import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../ui/ui.dart';
import '../providers.dart';

/// Template screen — copy this whole `_template` folder to start a feature.
///
/// The recipe:
/// 1. `AppPage` gives you the full liquid-glass page shell (background,
///    app bar with back button, edge fades, large title).
/// 2. Watch a provider; render its AsyncValue states.
/// 3. All data logic lives in the repository — screens only present.
///
/// To register: add a route name in app/router/routes.dart and a `_route`
/// entry in app/router/app_router.dart. Navigate with
/// `context.pushNamed(Routes.yourFeature)`.
class TemplateScreen extends ConsumerWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(templateItemsProvider);

    return AppPage(
      title: 'Template',
      children: [
        const SectionTitle(title: 'Items'),
        const SizedBox(height: 16),
        items.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: GlassProgressIndicator.circular(),
            ),
          ),
          error: (error, _) => InfoCard(
            child: Text(
              'Something went wrong: $error',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          data: (list) => Column(
            children: [
              for (final item in list) ...[
                LauncherTile(
                  title: item.title,
                  subtitle: item.subtitle,
                  icon: CupertinoIcons.cube,
                  accentColor: const Color(0xFF0A84FF),
                  onTap: () {
                    GlassToast.show(context, message: 'Tapped ${item.title}');
                  },
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
