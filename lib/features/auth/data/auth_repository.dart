import 'dart:math';
import '../../../core/api/api_client.dart';
import '../../../shared/models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Real auth backed by the Planovar API. Mirrors the old MockAuthService
/// method shapes so AuthBloc can use it as a drop-in replacement.
///
/// Signup-order note: the client onboarding collects the password AFTER the
/// OTP step (register → OTP → phone → location → password → categories).
/// Better Auth needs a password at sign-up, so `signUp` generates a strong
/// temporary password and `setPassword` later swaps it for the real one via
/// /api/auth/change-password. If the app dies mid-onboarding, the user can
/// recover through the forgot-password (OTP reset) flow.
class AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepository({AuthRemoteDataSource? remote})
      : _remote = remote ?? AuthRemoteDataSource(ApiClient());

  /// Held in memory only, for the change-password call at the password step.
  static String? _tempPassword;

  Future<UserModel> signIn({required String email, required String password}) async {
    final data = await _remote.signInEmail(email: email, password: password);
    return UserModel.fromJson(_extractUser(data));
  }

  /// Launches the Google OAuth flow (redirects the browser to Google).
  Future<void> signInWithGoogle() => _remote.signInWithGoogle();

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final pw = password.isNotEmpty ? password : _generateTempPassword();
    if (password.isEmpty) _tempPassword = pw;
    final data = await _remote.signUpEmail(name: fullName, email: email, password: pw);
    try {
      await _remote.sendOtp(email: email, type: 'email-verification');
    } catch (_) {}
    return UserModel.fromJson(_extractUser(data));
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    await _remote.verifyEmailOtp(email: email, otp: otp);
    return true;
  }

  /// Swaps the temp signup password for the user's chosen one.
  Future<bool> setPassword(String newPassword) async {
    final current = _tempPassword;
    if (current == null) {
      // Signup happened with a real password (or app restarted) — nothing to do.
      return false;
    }
    await _remote.changePassword(
        currentPassword: current, newPassword: newPassword);
    _tempPassword = null;
    return true;
  }

  Future<bool> forgotPassword({required String email}) async {
    await _remote.sendOtp(email: email, type: 'forget-password');
    return true;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _remote.resetPasswordOtp(email: email, otp: otp, password: newPassword);
    return true;
  }

  Future<UserModel> getMe() async {
    final session = await _remote.getSession();
    if (session == null) throw Exception('No active session');
    return UserModel.fromJson(_extractUser(session));
  }

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? image,
  }) async {
    final data = await _remote.updateProfile({
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
    });
    return UserModel.fromJson(_extractUser(data));
  }

  /// Saves location + category preferences, resolving picker names to IDs.
  /// Best-effort: a failed lookup never blocks onboarding.
  Future<bool> setPreferences({
    String? country,
    String? city,
    List<String>? categoryPrefs,
  }) async {
    try {
      if (country != null) {
        final countries = await _remote.countries();
        final c = countries.where((e) =>
            (e['name'] as String).toLowerCase() == country.toLowerCase());
        if (c.isNotEmpty) {
          final countryId = c.first['id'] as String;
          String? cityId;
          if (city != null) {
            final cities = await _remote.cities(countryId);
            final match = cities.where((e) =>
                (e['name'] as String).toLowerCase() == city.toLowerCase());
            if (match.isNotEmpty) cityId = match.first['id'] as String;
          }
          await _remote.updateProfile({
            'preferredCountryId': countryId,
            if (cityId != null) 'preferredCityId': cityId,
          });
        }
      }
      if (categoryPrefs != null && categoryPrefs.isNotEmpty) {
        final cats = await _remote.categories();
        final ids = <String>[];
        for (final pref in categoryPrefs) {
          final match = cats.where((c) {
            final name = (c['name'] as String).toLowerCase();
            final p = pref.toLowerCase();
            return name == p || name.contains(p) || p.contains(name);
          });
          if (match.isNotEmpty) ids.add(match.first['id'] as String);
        }
        if (ids.isNotEmpty) {
          await _remote.setCategoryPreferences(ids.toSet().toList());
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() => _remote.signOut();

  String _generateTempPassword() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789!@#%';
    final rng = Random.secure();
    return List.generate(24, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  /// Better Auth returns `{ user: {...}, session: {...} }` (or a bare user).
  Map<String, dynamic> _extractUser(Map<String, dynamic> data) {
    final raw = data['user'] ?? data;
    final m = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    m['id'] = (m['id'] ?? '').toString();
    m['email'] ??= '';
    m['name'] ??= m['email'];
    m['firstName'] ??= (m['name'] as String).split(' ').first;
    m['lastName'] ??= ((m['name'] as String).split(' ').length > 1
        ? (m['name'] as String).split(' ').last
        : '');
    m['role'] ??= 'CLIENT';
    return m;
  }
}
