import 'package:dio/dio.dart';

/// Web-safe socket-error detection (avoids importing `dart:io`, which breaks
/// `flutter build web`). On web there is no `SocketException`, so this is false
/// and Dio's `connectionError` covers connectivity failures instead.
bool _isSocketError(Object? e) =>
    e != null && e.runtimeType.toString() == 'SocketException';

/// User-facing error handling for the networking layer.
///
/// The goal: nothing technical (`Exception:`, `DioException`, `SocketException`,
/// stack traces, URLs, status codes, raw JSON) ever reaches a snackbar or
/// dialog. Networking failures are turned into short, friendly English strings
/// here, once, so the many display sites that do `e.toString()` /
/// `.replaceFirst('Exception: ', '')` render something safe for free.
///
/// NOTE: messages are English-only for now. The app is multilingual, but
/// localizing every error string is out of scope — see follow-up.

/// An exception that already carries a message safe to show the user.
///
/// [toString] returns just that message (no `Exception: ` prefix), so both
/// `Text('$e')` and `Text(e.toString().replaceFirst('Exception: ', ''))`
/// render the friendly text. Backend 4xx/409 messages are preserved verbatim
/// (some flows match on them), so this stays compatible with
/// `e.toString().contains('...')` checks.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

const String _kNoInternet =
    'No internet connection. Please check your network and try again.';
const String _kSlow = 'This is taking longer than usual. Please try again.';
const String _kServer =
    'Something went wrong on our end. Please try again shortly.';
const String _kGeneric = 'Something went wrong. Please try again.';
const String _kBadRequest = 'Please check your details and try again.';
const String _kSessionExpired = 'Your session has expired. Please sign in again.';
const String _kForbidden = "You don't have permission to do that.";
const String _kNotFound = "We couldn't find what you were looking for.";
const String _kConflict =
    'That conflicts with the current state. Please refresh and try again.';
const String _kTooMany =
    "You're doing that too quickly. Please wait a moment and try again.";

/// Pulls the human-readable message out of a NestJS error body
/// (`{ statusCode, message, error }`, where `message` is a String or String[]).
String? backendMessage(dynamic data) {
  if (data is Map && data['message'] != null) {
    final m = data['message'];
    final s = m is List ? m.join(', ') : m.toString();
    return s.trim().isEmpty ? null : s.trim();
  }
  return null;
}

/// Strips leading technical prefixes ("Exception: ", "DioException [..]: ",
/// "SocketException: ", "_TypeError: ", etc.) from an error string.
String stripTechnicalPrefixes(String input) {
  var s = input.trim();
  // Drop a leading "SomethingException [...]: " or "SomethingException: ".
  final prefix = RegExp(r'^[A-Za-z_]*Exception(\s*\[[^\]]*\])?\s*:\s*');
  while (prefix.hasMatch(s)) {
    s = s.replaceFirst(prefix, '').trim();
  }
  return s;
}

/// True when a string looks like leaked internals rather than a message meant
/// for a person (used to decide whether a backend string is safe to show).
bool _isTechnical(String s) {
  final l = s.toLowerCase();
  return l.contains('exception') ||
      l.contains('http://') ||
      l.contains('https://') ||
      l.contains('stack trace') ||
      l.contains('errno') ||
      l.contains('socketexception') ||
      l.contains('null check') ||
      l.contains("type '") ||
      s.contains('{') ||
      s.contains('}') ||
      s.contains('[body.');
}

/// Turns raw backend/validation strings (e.g. Better Auth's
/// "[body.email] Invalid email address; [body.password] Too small: expected
/// string to have >=1 characters") into a short, user-facing message. Falls
/// back to the raw string when it is already presentable.
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
    return _kBadRequest;
  }
  if (code == 401) return _kSessionExpired;
  return raw;
}

/// Runs a backend 4xx message through [friendlyApiMessage] and returns it only
/// if the result is safe to show; otherwise null.
String? _refinedBackend(String? backend, int code) {
  if (backend == null) return null;
  final refined = friendlyApiMessage(backend, code);
  return _isTechnical(refined) ? null : refined;
}

/// Maps an HTTP status code + response body to a user-facing message.
///
/// 4xx bodies from the backend are preserved (they are written for users, and
/// some flows match on them) unless they look technical; 5xx are always
/// replaced with a neutral "our end" message so nothing internal leaks.
String messageForStatus(int code, dynamic data) {
  final backend = backendMessage(data);
  final friendlyBackend = _refinedBackend(backend, code);
  switch (code) {
    case 400:
    case 422:
      return friendlyBackend ?? _kBadRequest;
    case 401:
      return _kSessionExpired;
    case 403:
      return friendlyBackend ?? _kForbidden;
    case 404:
      return friendlyBackend ?? _kNotFound;
    case 409:
      return friendlyBackend ?? _kConflict;
    case 429:
      return _kTooMany;
    case 500:
    case 502:
    case 503:
    case 504:
      return _kServer;
    default:
      if (code >= 500) return _kServer;
      if (code >= 400) return friendlyBackend ?? _kGeneric;
      return _kGeneric;
  }
}

/// The single entry point: turn any thrown error into a friendly message.
///
/// Returns an empty string for a cancelled request (the caller can safely
/// ignore it and show nothing).
String humanizeError(Object? error) {
  if (error == null) return _kGeneric;

  if (error is ApiException) return error.message;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return _kNoInternet;
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return _kSlow;
      case DioExceptionType.cancel:
        return '';
      case DioExceptionType.badCertificate:
        return _kGeneric;
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        return messageForStatus(code, error.response?.data);
      case DioExceptionType.unknown:
        if (_isSocketError(error.error)) return _kNoInternet;
        return _kGeneric;
    }
  }

  if (_isSocketError(error)) return _kNoInternet;

  // Our own thrown Exception(...) values already hold friendly text; unwrap the
  // "Exception: " prefix. Anything that still looks technical is replaced.
  final raw = stripTechnicalPrefixes(error.toString());
  if (raw.isEmpty || _isTechnical(raw)) return _kGeneric;
  return raw;
}
