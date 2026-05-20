import 'package:flutter/material.dart';
import '../../../core/mock/mock_notification_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifService = MockNotificationService();
  List<NotificationModel> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notifs = await _notifService.getNotifications();
    setState(() {
      _notifications = notifs;
      _loading = false;
    });
  }

  Future<void> _markAllRead() async {
    await _notifService.markAllRead();
    _load();
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today_rounded;
      case 'quote':
        return Icons.receipt_outlined;
      case 'payment':
        return Icons.payment_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'booking':
        return AppColors.primary;
      case 'quote':
        return AppColors.warning;
      case 'payment':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: _loading
          ? const Padding(padding: EdgeInsets.all(16), child: ShimmerList(itemCount: 5))
          : _notifications.isEmpty
              ? const EmptyState(icon: Icons.notifications_off_outlined, title: 'No notifications')
              : ListView.separated(
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final notif = _notifications[i];
                    final typeColor = _colorForType(notif.type);
                    return Container(
                      color: notif.isRead ? null : AppColors.primaryLight.withValues(alpha: 0.3),
                      child: InkWell(
                        onTap: () async {
                          await _notifService.markRead(notif.id);
                          _load();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_iconForType(notif.type), color: typeColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(notif.title, style: AppTextStyles.label),
                                        ),
                                        if (!notif.isRead)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notif.body,
                                      style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.relativeTime(notif.createdAt),
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
