import 'package:dio/dio.dart';

import 'api_error.dart';

// Re-exported so the many services/screens that import api_utils.dart also get
// `humanizeError`, `ApiException`, and `friendlyApiMessage` without a new import.
export 'api_error.dart';

/// Throws a user-facing [ApiException] when a response is not 2xx.
///
/// ApiClient lets every HTTP status through (see its `validateStatus`) so this
/// helper — not Dio — is the single place that decides an HTTP response is a
/// failure, and it always throws a friendly, already-humanized message.
void ensureOk(Response res) {
  final code = res.statusCode ?? 0;
  if (code >= 200 && code < 300) return;
  throw ApiException(messageForStatus(code, res.data), statusCode: code);
}
