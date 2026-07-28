import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/ui.dart';
import '../providers.dart';

/// Settings tab — appearance, language, account, notifications, about.
class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  /// Localized label for a notification-preference [key]. Shared with the
  /// home quick-menu, which shows the same toggles.
  static String notifLabel(AppLocalizations l10n, String key) =>
      switch (key) {
        'weatherAlerts' => l10n.notifWeatherAlerts,
        'priceUpdates' => l10n.notifPriceUpdates,
        _ => l10n.notifCropReminders,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = ref.watch(isDarkModeProvider);
    final language = ref.watch(languageControllerProvider);
    final notifications = ref.watch(notificationPrefsProvider);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return TabContentView(
      title: l10n.settingsTitle,
      subtitle: l10n.settingsSubtitle,
      children: [
        const SizedBox(height: AppSpacing.section),

        // ── Appearance ───────────────────────────────────────────────
        SectionTitle(title: l10n.sectionAppearance),
        const SizedBox(height: 12),
        SolidCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              _SettingRow(
                icon: isDark
                    ? CupertinoIcons.moon_fill
                    : CupertinoIcons.sun_max_fill,
                iconColor: isDark ? AppColors.indigo : AppColors.orange,
                title: l10n.darkMode,
                trailing: CupertinoSwitch(
                  value: isDark,
                  activeTrackColor: primary,
                  onChanged: (_) =>
                      ref.read(themeControllerProvider.notifier).toggle(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.section),

        // ── Language ─────────────────────────────────────────────────
        SectionTitle(title: l10n.sectionLanguage),
        const SizedBox(height: 12),
        SolidCard(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              _LanguageOption(
                label: 'English',
                selected: language == 'en',
                onTap: () => ref
                    .read(languageControllerProvider.notifier)
                    .setLanguage('en'),
              ),
              _LanguageOption(
                label: 'বাংলা',
                selected: language == 'bn',
                onTap: () => ref
                    .read(languageControllerProvider.notifier)
                    .setLanguage('bn'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.languageNote,
          style: TextStyle(fontSize: 12, color: muted),
        ),
        const SizedBox(height: AppSpacing.section),

        // ── Account ──────────────────────────────────────────────────
        SectionTitle(title: l10n.sectionAccount),
        const SizedBox(height: 12),
        SolidTile(
          title: l10n.signInTitle,
          subtitle: l10n.signInSubtitle,
          icon: CupertinoIcons.person_crop_circle_fill,
          accentColor: primary,
          onTap: () => GlassToast.show(
            context,
            message: l10n.accountToast,
          ),
        ),
        const SizedBox(height: AppSpacing.section),

        // ── Notifications ────────────────────────────────────────────
        SectionTitle(title: l10n.sectionNotifications),
        const SizedBox(height: 12),
        SolidCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (final key in NotificationPrefs.keys.keys)
                _SettingRow(
                  icon: CupertinoIcons.bell_fill,
                  iconColor: AppColors.cyan,
                  title: notifLabel(l10n, key),
                  trailing: CupertinoSwitch(
                    value: notifications[key] ?? true,
                    activeTrackColor: primary,
                    onChanged: (_) => ref
                        .read(notificationPrefsProvider.notifier)
                        .toggle(key),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.section),

        // ── About ────────────────────────────────────────────────────
        SectionTitle(title: l10n.sectionAbout),
        const SizedBox(height: 12),
        SolidCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.16),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: const Text('🌾', style: TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                      Text(l10n.versionLabel('1.0.0'),
                          style: TextStyle(fontSize: 12, color: muted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.aboutDescription,
                style: TextStyle(fontSize: 13, height: 1.4, color: muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? primary.withValues(alpha: 0.2) : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? primary
                  : CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
      ),
    );
  }
}
