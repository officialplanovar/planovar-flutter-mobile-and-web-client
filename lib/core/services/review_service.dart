import '../api/api_client.dart';
import '../api/api_utils.dart';

class ReviewService {
  final ApiClient _api;
  ReviewService({ApiClient? api}) : _api = api ?? ApiClient();

  /// Submit a review for a COMPLETED booking (verified-interaction gate
  /// is enforced server-side).
  Future<void> submit({
    required String bookingId,
    required int rating,
    String? title,
    required String body,
  }) async {
    final res = await _api.dio.post('/reviews', data: {
      'bookingId': bookingId,
      'rating': rating,
      if (title != null && title.isNotEmpty) 'title': title,
      'body': body,
    });
    ensureOk(res);
  }
}
