import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_utils.dart';

/// Uploads images to the API, which stores them and returns a public URL.
class UploadService {
  final ApiClient _api;
  UploadService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<String> _upload(String path, Uint8List bytes, String filename) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    final res = await _api.dio.post(path, data: form);
    ensureOk(res);
    return (res.data as Map)['url'] as String;
  }

  /// Uploads an event cover image and returns its URL.
  Future<String> uploadEventCover(Uint8List bytes, String filename) =>
      _upload('/upload/event/cover', bytes, filename);
}
