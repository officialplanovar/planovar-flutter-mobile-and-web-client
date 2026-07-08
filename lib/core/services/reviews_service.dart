import '../api/api_client.dart';
import '../api/api_utils.dart';

class ReviewItem {
  final String name;
  final int rating;
  final String body;
  final DateTime? createdAt;
  const ReviewItem({
    required this.name,
    required this.rating,
    required this.body,
    this.createdAt,
  });
}

class ReviewsService {
  final ApiClient _api;
  ReviewsService({ApiClient? api}) : _api = api ?? ApiClient();

  /// Public reviews for a vendor (newest first).
  Future<List<ReviewItem>> forVendor(String vendorId, {int take = 20}) async {
    final res = await _api.dio.get(
      '/reviews/vendor/$vendorId',
      queryParameters: {'take': take},
    );
    ensureOk(res);
    final data = (res.data as Map)['data'] as List? ?? const [];
    return data.map((r) {
      final m = Map<String, dynamic>.from(r);
      final reviewer = m['reviewer'] as Map?;
      return ReviewItem(
        name: (reviewer?['name'] as String?)?.trim().isNotEmpty == true
            ? reviewer!['name'] as String
            : 'A client',
        rating: (m['rating'] as num?)?.toInt() ?? 0,
        body: m['body'] as String? ?? '',
        createdAt: m['createdAt'] != null
            ? DateTime.tryParse(m['createdAt'] as String)
            : null,
      );
    }).toList();
  }
}
