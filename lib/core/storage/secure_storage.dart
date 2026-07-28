import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstraction over encrypted storage for sensitive values
/// (auth tokens, API keys, refresh tokens).
abstract interface class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// [FlutterSecureStorage]-backed implementation (Keychain / Keystore).
class FlutterSecureStorageImpl implements SecureStorage {
  const FlutterSecureStorageImpl([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// Well-known secure storage keys.
abstract final class SecureStorageKeys {
  static const String accessToken = 'auth.access_token';
  static const String refreshToken = 'auth.refresh_token';
}

/// Provider for secure storage.
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => const FlutterSecureStorageImpl(),
);
