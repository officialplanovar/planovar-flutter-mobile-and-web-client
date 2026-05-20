import '../../shared/models/notification_model.dart';
import 'mock_data.dart';

class MockNotificationService {
  static const _delay = Duration(milliseconds: 400);
  final List<NotificationModel> _notifications = List.from(MockData.notifications);

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(_delay);
    return List.from(_notifications);
  }

  Future<bool> markRead(String id) async {
    await Future.delayed(_delay);
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    }
    return true;
  }

  Future<bool> markAllRead() async {
    await Future.delayed(_delay);
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    return true;
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
