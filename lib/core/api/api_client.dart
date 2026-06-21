import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'token_store.dart';

/// Shared Dio client for the Planovar API.
///
/// Attaches the Better Auth bearer token (from [TokenStore]) on every request.
/// `validateStatus` lets 4xx through so callers can read structured error bodies
/// instead of catching DioException for ordinary validation failures.
class ApiClient {
  final Dio dio;
  final TokenStore tokenStore;

  ApiClient({Dio? dio, TokenStore? tokenStore})
      : tokenStore = tokenStore ?? TokenStore(),
        dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              headers: {'Content-Type': 'application/json'},
              validateStatus: (status) => status != null && status < 500,
            )) {
    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await this.tokenStore.read();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              handler.next(options);
            },
          ),
        );

    // Concise request/response/error logging (debug builds only).
    if (kDebugMode) {
      this.dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                debugPrint('→ ${options.method} ${options.uri}');
                handler.next(options);
              },
              onResponse: (response, handler) {
                debugPrint(
                  '← ${response.statusCode} ${response.requestOptions.method} '
                  '${response.requestOptions.uri}',
                );
                handler.next(response);
              },
              onError: (err, handler) {
                debugPrint(
                  '✗ ${err.requestOptions.method} ${err.requestOptions.uri} '
                  '→ ${err.response?.statusCode ?? err.type.name}: ${err.message}',
                );
                handler.next(err);
              },
            ),
          );
    }
  }
}
