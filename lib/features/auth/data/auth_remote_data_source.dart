import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';
import '../../../core/constants/app_constants.dart';

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
    await _captureTokenOrThrow(res);
    return _asMap(res.data);
  }

  /// Starts the Google OAuth flow. Asks Better Auth for the provider consent
  /// URL, then hands off to the browser. On web this is a same-tab redirect;
  /// Better Auth returns to [callbackURL] after the Google round-trip.
  Future<void> signInWithGoogle() async {
    final callbackURL = kIsWeb ? Uri.base.origin : AppConstants.apiBaseUrl;
    final res = await _dio.post('/api/auth/sign-in/social', data: {
      'provider': 'google',
      'callbackURL': callbackURL,
    });
    ensureOk(res);
    final url = _asMap(res.data)['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Could not start Google sign-in. Please try again.');
    }
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_self',
    );
  }

  Future<Map<String, dynamic>?> getSession() async {
    final res = await _dio.get('/api/auth/get-session');
    // Bearer plugin returns a fresh token on any authenticated response —
    // capture it so an OAuth/cookie session upgrades to a stored bearer token.
    await _captureToken(res);
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
    await _captureTokenOrThrow(res);
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

  /// Saves the bearer token from the `set-auth-token` header if present.
  /// Returns true when a token was captured. Best-effort (never throws) — used
  /// on sign-up, where the session is established later at OTP verification.
  Future<bool> _captureToken(Response res) async {
    final token = res.headers.value('set-auth-token');
    if (token != null && token.isNotEmpty) {
      await _api.tokenStore.save(token);
      return true;
    }
    return false;
  }

  /// Like [_captureToken] but REQUIRES a token — the app authenticates purely by
  /// bearer token, so a sign-in/verify that yields no token leaves every
  /// subsequent request unauthenticated ("Unauthorised" everywhere). This most
  /// often means the `set-auth-token` response header wasn't readable (a web
  /// CORS `Access-Control-Expose-Headers` / trusted-origin misconfiguration).
  /// Failing loudly here beats a silent "logged-in but tokenless" session.
  Future<void> _captureTokenOrThrow(Response res) async {
    if (await _captureToken(res)) return;
    await _api.tokenStore.clear();
    throw Exception(
      "Signed in, but we couldn't establish a secure session. "
      'Please try again, and if it persists contact support.',
    );
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map<String, dynamic> ? data : <String, dynamic>{};
}
