import 'package:dio/dio.dart';

/// Throws a readable Exception when a response is not 2xx.
/// (ApiClient passes 4xx through so we can surface API error messages.)
void ensureOk(Response res) {
  final code = res.statusCode ?? 0;
  if (code >= 200 && code < 300) return;
  final data = res.data;
  String msg = 'Request failed ($code)';
  if (data is Map && data['message'] != null) {
    final m = data['message'];
    msg = m is List ? m.join(', ') : m.toString();
  }
  throw Exception(friendlyApiMessage(msg, code));
}

/// Turns raw backend/validation strings (e.g. Better Auth's
/// "[body.email] Invalid email address; [body.password] Too small: expected
/// string to have >=1 characters") into a short, user-facing message.
String friendlyApiMessage(String raw, [int code = 0]) {
  final lower = raw.toLowerCase();
  if (lower.contains('email') &&
      (lower.contains('invalid') || lower.contains('valid'))) {
    return 'Please enter a valid email address.';
  }
  if (lower.contains('password') &&
      (lower.contains('too small') ||
          lower.contains('at least') ||
          lower.contains('>='))) {
    return 'Your password must be at least 8 characters.';
  }
  if (lower.contains('already exists') ||
      lower.contains('already registered') ||
      lower.contains('existing user') ||
      code == 409) {
    return 'An account with these details already exists. Try signing in.';
  }
  if (lower.contains('invalid') && lower.contains('otp')) {
    return 'That code is incorrect or has expired. Request a new one.';
  }
  if (raw.contains('[body.') || lower.contains('expected string')) {
    return 'Please check your details and try again.';
  }
  if (code == 401) return 'Your session has expired. Please sign in again.';
  return raw;
}
