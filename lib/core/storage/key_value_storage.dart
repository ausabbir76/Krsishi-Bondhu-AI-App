import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction over simple key-value persistence.
///
/// Backed by [SharedPreferences] in production; swap in a fake for tests
/// by overriding [keyValueStorageProvider].
abstract interface class KeyValueStorage {
  String? getString(String key);
  Future<bool> setString(String key, String value);
  bool? getBool(String key);
  Future<bool> setBool(String key, {required bool value});
  int? getInt(String key);
  Future<bool> setInt(String key, int value);
  Future<bool> remove(String key);
}

/// [SharedPreferences]-backed implementation.
class SharedPrefsStorage implements KeyValueStorage {
  SharedPrefsStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);
}

/// Provider for key-value storage.
///
/// Overridden in [bootstrap] with the real [SharedPreferences] instance —
/// reading it before bootstrap completes throws intentionally.
final keyValueStorageProvider = Provider<KeyValueStorage>(
  (ref) => throw UnimplementedError(
    'keyValueStorageProvider must be overridden in bootstrap()',
  ),
);
