import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/theme_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/account.dart';
import '../../settings/presentation/settings_tab.dart';
import '../../settings/providers.dart';
import '../providers.dart';

/// Content of the home quick-menu — a compact "mini settings" screen shown
/// inside a [GlassPopover] that morphs out of the home 3-dot button.
///
/// The popover is floating navigation chrome, so it is intentionally glass;
/// this widget renders the controls (account, dark mode, language,
/// notifications, settings shortcut) directly on that morphing glass surface.
///
/// [onClose] dismisses the popover — the popover passes its own `close`
/// callback here so actions like "All settings" can close before navigating.
class QuickMenuContent extends ConsumerWidget {
  const QuickMenuContent({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDark = ref.watch(isDarkModeProvider);
    final language = ref.watch(languageControllerProvider);
    final notifications = ref.watch(notificationPrefsProvider);
    final account = ref.watch(accountControllerProvider);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Account header ─────────────────────────────────────────
          _AccountHeader(
            account: account,
            onSignIn: () {
              onClose();
              GlassToast.show(context, message: l10n.accountToast);
            },
            onSignOut: () =>
                ref.read(accountControllerProvider.notifier).signOut(),
          ),
          const SizedBox(height: 12),
          _Divider(),
          const SizedBox(height: 10),

          // ── Appearance ─────────────────────────────────────────────
          _MenuSectionLabel(l10n.sectionAppearance),
          const SizedBox(height: 4),
          _MenuRow(
            icon:
                isDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
            iconColor: isDark ? AppColors.indigo : AppColors.orange,
            title: l10n.darkMode,
            trailing: CupertinoSwitch(
              value: isDark,
              activeTrackColor: primary,
              onChanged: (_) =>
                  ref.read(themeControllerProvider.notifier).toggle(),
            ),
          ),
          const SizedBox(height: 10),

          // ── Language ───────────────────────────────────────────────
          _MenuSectionLabel(l10n.sectionLanguage),
          const SizedBox(height: 4),
          Row(
            children: [
              _LangPill(
                label: 'English',
                selected: language == 'en',
                onTap: () => ref
                    .read(languageControllerProvider.notifier)
                    .setLanguage('en'),
              ),
              const SizedBox(width: 8),
              _LangPill(
                label: 'বাংলা',
                selected: language == 'bn',
                onTap: () => ref
                    .read(languageControllerProvider.notifier)
                    .setLanguage('bn'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Notifications ──────────────────────────────────────────
          _MenuSectionLabel(l10n.sectionNotifications),
          const SizedBox(height: 4),
          for (final key in NotificationPrefs.keys.keys)
            _MenuRow(
              icon: CupertinoIcons.bell_fill,
              iconColor: AppColors.cyan,
              title: SettingsTab.notifLabel(l10n, key),
              trailing: CupertinoSwitch(
                value: notifications[key] ?? true,
                activeTrackColor: primary,
                onChanged: (_) =>
                    ref.read(notificationPrefsProvider.notifier).toggle(key),
              ),
            ),
          const SizedBox(height: 10),
          _Divider(),
          const SizedBox(height: 10),

          // ── All settings shortcut ──────────────────────────────────
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onClose();
              ref.read(homeTabIndexProvider.notifier).state = kSettingsTabIndex;
            },
            child: Row(
              children: [
                Icon(CupertinoIcons.gear_alt_fill, size: 20, color: primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.quickMenuAllSettings,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label.resolveFrom(context),
                    ),
                  ),
                ),
                Icon(CupertinoIcons.chevron_right, size: 16, color: muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Account row: avatar + name/email, or a sign-in prompt when signed out.
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({
    required this.account,
    required this.onSignIn,
    required this.onSignOut,
  });

  final AccountUser? account;
  final VoidCallback onSignIn;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = KrishiColors.primary.resolveFrom(context);
    final muted = KrishiColors.mutedText.resolveFrom(context);
    final label = CupertinoColors.label.resolveFrom(context);
    final user = account;

    if (user == null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSignIn,
        child: Row(
          children: [
            _Avatar(
              child: Icon(CupertinoIcons.person_fill,
                  color: primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.signInTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: label,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.signInSubtitle,
                    style: TextStyle(fontSize: 12, color: muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right, size: 16, color: muted),
          ],
        ),
      );
    }

    return Row(
      children: [
        _Avatar(
          child: Text(
            user.initial,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: label,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.email,
                style: TextStyle(fontSize: 12, color: muted),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onSignOut,
          behavior: HitTestBehavior.opaque,
          child: Icon(CupertinoIcons.square_arrow_right,
              size: 20, color: muted),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final primary = KrishiColors.primary.resolveFrom(context);
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: primary.withValues(alpha: 0.4)),
      ),
      child: child,
    );
  }
}

/// Hairline separator sized for the glass popover surface.
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: KrishiColors.cardBorder.resolveFrom(context),
    );
  }
}

class _MenuSectionLabel extends StatelessWidget {
  const _MenuSectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: KrishiColors.mutedText.resolveFrom(context),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 19, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
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

class _LangPill extends StatelessWidget {
  const _LangPill({
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
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? primary.withValues(alpha: 0.2) : null,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            border: Border.all(
              color: selected
                  ? primary
                  : KrishiColors.cardBorder.resolveFrom(context),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
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
