import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_messaging_service.dart';
import '../../../core/mock/mock_notification_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _messagingService = MockMessagingService();
  final _notifService = MockNotificationService();
  final _searchCtrl = TextEditingController();
  List<ConversationModel> _conversations = [];
  List<ConversationModel> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_filter);
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final convos = await _messagingService.getConversations();
    setState(() {
      _conversations = convos;
      _filtered = convos;
      _loading = false;
    });
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _conversations
          : _conversations.where((c) =>
              c.vendor?.businessName.toLowerCase().contains(q) == true ||
              c.lastMessage?.toLowerCase().contains(q) == true).toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_filter);
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Messages'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push(AppRoutes.notifications),
              ),
              if (_notifService.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: ShimmerList(itemCount: 5, itemHeight: 72),
                  )
                : _filtered.isEmpty
                    ? const EmptyState(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'No conversations yet',
                        subtitle: 'When you contact a vendor, your conversation will appear here.',
                      )
                    : ListView.separated(
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
                        itemBuilder: (context, i) {
                          return _ConversationTile(
                            conversation: _filtered[i],
                            onTap: () => context.push(AppRoutes.conversationDetailPath(_filtered[i].id)),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback? onTap;

  const _ConversationTile({required this.conversation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: AppColors.primaryLight,
        child: ClipOval(
          child: AppNetworkImage(
            url: conversation.vendor?.coverUrl,
            width: 52,
            height: 52,
          ),
        ),
      ),
      title: Text(
        conversation.vendor?.businessName ?? 'Vendor',
        style: AppTextStyles.label,
      ),
      subtitle: Text(
        conversation.lastMessage ?? '',
        style: AppTextStyles.caption,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessageAt != null)
            Text(Formatters.messageTime(conversation.lastMessageAt!), style: AppTextStyles.caption),
          const SizedBox(height: 4),
          if (conversation.unreadCount > 0)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${conversation.unreadCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
