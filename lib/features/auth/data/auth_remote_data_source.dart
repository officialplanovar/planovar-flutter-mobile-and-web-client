import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';

/// Thin wrapper over the Better Auth endpoints (/api/auth/*) plus the
/// profile/preference endpoints the client onboarding uses.
/// Captures the `set-auth-token` header (bearer plugin) into secure storage.
class AuthRemoteDataSource {
  final ApiClient _api;
  AuthRemoteDataSource(this._api);

  Dio get _dio => _api.dio;

  Future<Map<String, dynamic>> signUpEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('/api/auth/sign-up/email', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    ensureOk(res);
    await _captureToken(res);
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>> signInEmail({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('/api/auth/sign-in/email',
        data: {'email': email, 'password': password});
    ensureOk(res);
    await _captureToken(res);
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>?> getSession() async {
    final res = await _dio.get('/api/auth/get-session');
    if (res.statusCode == 200 && res.data is Map) return _asMap(res.data);
    return null;
  }

  Future<void> sendOtp({required String email, String type = 'email-verification'}) async {
    final res = await _dio.post('/api/auth/email-otp/send-verification-otp',
        data: {'email': email, 'type': type});
    ensureOk(res);
  }

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final res = await _dio
        .post('/api/auth/email-otp/verify-email', data: {'email': email, 'otp': otp});
    ensureOk(res);
    await _captureToken(res);
    return _asMap(res.data);
  }

  Future<void> resetPasswordOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    final res = await _dio.post('/api/auth/email-otp/reset-password',
        data: {'email': email, 'otp': otp, 'password': password});
    ensureOk(res);
  }

  /// Sets the real password after temp-password signup (see AuthRepository).
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await _dio.post('/api/auth/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'revokeOtherSessions': false,
    });
    ensureOk(res);
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/api/auth/sign-out');
    } catch (_) {}
    await _api.tokenStore.clear();
  }

  // ── Profile & preferences ────────────────────────────────────────────────

  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/users/me');
    ensureOk(res);
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> changes) async {
    final res = await _dio.patch('/users/me', data: changes);
    ensureOk(res);
    return _asMap(res.data);
  }

  Future<void> setCategoryPreferences(List<String> categoryIds) async {
    final res =
        await _dio.post('/users/me/preferences', data: {'categoryIds': categoryIds});
    ensureOk(res);
  }

  // ── Reference data (for mapping picker names → IDs) ─────────────────────

  Future<List<Map<String, dynamic>>> countries() async {
    final res = await _dio.get('/locations/countries');
    ensureOk(res);
    return List<Map<String, dynamic>>.from(res.data as List? ?? const []);
  }

  Future<List<Map<String, dynamic>>> cities(String countryId) async {
    final res = await _dio.get('/locations/countries/$countryId/cities');
    ensureOk(res);
    return List<Map<String, dynamic>>.from(res.data as List? ?? const []);
  }

  Future<List<Map<String, dynamic>>> categories() async {
    final res = await _dio.get('/categories');
    ensureOk(res);
    return List<Map<String, dynamic>>.from(res.data as List? ?? const []);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  Future<void> _captureToken(Response res) async {
    final token = res.headers.value('set-auth-token');
    if (token != null && token.isNotEmpty) {
      await _api.tokenStore.save(token);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map<String, dynamic> ? data : <String, dynamic>{};
}
