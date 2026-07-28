import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/key_value_storage.dart';

/// App language preference: 'en' or 'bn'. Persisted across launches.
///
/// v1 stores the preference and shows it in Settings; wiring it into
/// `CupertinoApp.locale` + full Bangla .arb coverage is the l10n pass.
class LanguageController extends Notifier<String> {
  static const _storageKey = 'app.language';

  @override
  String build() =>
      ref.read(keyValueStorageProvider).getString(_storageKey) ?? 'en';

  void setLanguage(String code) {
    if (code == state) return;
    state = code;
    ref.read(keyValueStorageProvider).setString(_storageKey, code);
  }
}

final languageControllerProvider =
    NotifierProvider<LanguageController, String>(LanguageController.new);

/// Notification toggles, persisted individually.
class NotificationPrefs extends Notifier<Map<String, bool>> {
  static const keys = {
    'weatherAlerts': 'Weather & flood alerts',
    'priceUpdates': 'Daily market prices',
    'cropReminders': 'Crop care reminders',
  };
  static const _prefix = 'notif.';

  @override
  Map<String, bool> build() {
    final storage = ref.read(keyValueStorageProvider);
    return {
      for (final key in keys.keys)
        key: storage.getBool('$_prefix$key') ?? true,
    };
  }

  void toggle(String key) {
    final next = {...state, key: !(state[key] ?? true)};
    state = next;
    ref
        .read(keyValueStorageProvider)
        .setBool('$_prefix$key', value: next[key]!);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefs, Map<String, bool>>(
        NotificationPrefs.new);
