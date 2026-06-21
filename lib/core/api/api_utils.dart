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
  throw Exception(msg);
}
