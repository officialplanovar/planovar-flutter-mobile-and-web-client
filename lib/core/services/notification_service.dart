import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/notification_model.dart';

/// Real notifications (the rows the API writes on bookings/quotes/reviews, etc.).
/// Same method shape as the old MockNotificationService.
class NotificationService {
  final ApiClient _api;
  NotificationService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<NotificationModel>> getNotifications() async {
    final res = await _api.dio.get('/notifications');
    ensureOk(res);
    final data = (res.data is Map ? res.data['data'] : res.data) as List? ?? const [];
    return data
        .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<int> unreadCount() async {
    final res = await _api.dio.get('/notifications/unread-count');
    ensureOk(res);
    final d = res.data;
    return (d is Map ? (d['count'] ?? d['unreadCount']) : d) as int? ?? 0;
  }

  Future<bool> markRead(String id) async {
    final res = await _api.dio.patch('/notifications/$id/read');
    ensureOk(res);
    return true;
  }

  Future<bool> markAllRead() async {
    final res = await _api.dio.patch('/notifications/read-all');
    ensureOk(res);
    return true;
  }
}
