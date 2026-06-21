import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the Better Auth bearer token in the device keychain/keystore.
class TokenStore {
  static const _key = 'planovar_client_auth_token';
  final FlutterSecureStorage _storage;

  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> save(String token) => _storage.write(key: _key, value: token);
  Future<String?> read() => _storage.read(key: _key);
  Future<void> clear() => _storage.delete(key: _key);
  Future<bool> hasToken() async => (await read())?.isNotEmpty ?? false;
}
