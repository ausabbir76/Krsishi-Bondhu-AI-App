import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/providers.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/theme_controller.dart';

/// Root widget of the application.
///
/// Wires together the router, the theme controller and the language
/// preference (persisted en/bn locale from Settings).
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = ref.watch(themeControllerProvider);
    final router = ref.watch(routerProvider);
    final language = ref.watch(languageControllerProvider);
    final isDark = brightness == Brightness.dark;

    return CupertinoApp.router(
      title: 'KrishiBondhu AI',
      theme: CupertinoThemeData(brightness: brightness),
      routerConfig: router,
      locale: Locale(language),
      // Localizations: generated AppLocalizations (lib/l10n/*.arb) plus the
      // Material/Cupertino defaults for framework-internal strings.
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      // Provide a matching Material Theme for Scaffold-based pages.
      builder: (context, child) => Theme(
        data: isDark
            ? ThemeData.dark(useMaterial3: false)
            : ThemeData.light(useMaterial3: false),
        child: child!,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
