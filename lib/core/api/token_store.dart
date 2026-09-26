import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the Better Auth bearer token in the device keychain/keystore.
class TokenStore {
  static const _key = 'planovar_client_auth_token';
  final FlutterSecureStorage _storage;

  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> save(String token) => _storage.write(key: _key, value: token);

  /// Reads the token. The keychain/keystore can transiently throw a
  /// PlatformException right after the app resumes from background (device
  /// still locked / store not yet available). Since this runs on every API
  /// request, swallow the error and treat it as "no token" so the request
  /// pipeline never crashes on resume.
  Future<String?> read() async {
    try {
      return await _storage.read(key: _key);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() => _storage.delete(key: _key);
  Future<bool> hasToken() async => (await read())?.isNotEmpty ?? false;
}
