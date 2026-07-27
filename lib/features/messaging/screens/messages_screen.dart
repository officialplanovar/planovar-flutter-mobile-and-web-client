import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/chat_socket.dart';
import '../../../core/mock/mock_notification_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/models/vendor_model.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _service = MessagingService();
  final _socket = ChatSocket();
  final _notifService = MockNotificationService();
  final _searchCtrl = TextEditingController();

  List<ConversationModel> _all = [];
  List<ConversationModel> _filtered = [];
  bool _loading = true;
  String _myId = '';

  @override
  void initState() {
    super.initState();
    _resolveMyId();
    _load();
    _connectSocket();
  }

  Future<void> _resolveMyId() async {
    final id = await _service.myId();
    if (id != null && mounted) _myId = id;
  }

  @override
  void dispose() {
    _socket.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  /// Live-updates the list: joins every conversation room and refetches on any
  /// incoming message (updates preview, ordering and unread counts).
  Future<void> _connectSocket() async {
    await _socket.connect();
    _socket.onReady(_joinAll);
    _socket.onMessage(_onSocketMessage);
    _joinAll();
  }

  void _joinAll() {
    for (final c in _all) {
      _socket.join(c.id);
    }
  }

  /// Optimistically update the list on an incoming message: bump unread (unless
  /// it's ours), refresh the preview and move it to the top. Race-free vs a
  /// server refetch. Unknown conversations trigger a refetch to pull them in.
  void _onSocketMessage(Map<String, dynamic> data) {
    if (!mounted) return;
    final convId = data['conversationId'] as String?;
    if (convId == null) return;
    final idx = _all.indexWhere((c) => c.id == convId);
    if (idx < 0) {
      _load();
      return;
    }
    final senderId = data['senderId'] as String?;
    final content = data['content'] as String?;
    final mine = senderId != null && senderId == _myId;
    final bumped = _all[idx].copyWith(
      unreadCount: mine ? _all[idx].unreadCount : _all[idx].unreadCount + 1,
      lastMessage: content ?? _all[idx].lastMessage,
      lastMessageAt: DateTime.now(),
    );
    _all.removeAt(idx);
    _all.insert(0, bumped);
    setState(() {});
    _filter(_searchCtrl.text);
  }

  /// Clears a conversation's unread locally when it's opened (the chat marks it
  /// read server-side).
  void _markReadLocal(String convId) {
    final idx = _all.indexWhere((c) => c.id == convId);
    if (idx >= 0 && _all[idx].unreadCount > 0) {
      _all[idx] = _all[idx].copyWith(unreadCount: 0);
      setState(() {});
      _filter(_searchCtrl.text);
    }
  }

  Future<void> _load() async {
    final convs = await _service.getConversations();
    if (!mounted) return;
    setState(() {
      _all = convs;
      _loading = false;
    });
    _filter(_searchCtrl.text); // preserve any active search
    _joinAll(); // join rooms for any new conversations
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _all.where((c) {
        if (c.isGroup == true) {
          final name = c.groupName?.toLowerCase() ?? '';
          final msg = c.lastMessage?.toLowerCase() ?? '';
          return name.contains(q) || msg.contains(q);
        }
        final name = c.vendor?.businessName.toLowerCase() ?? '';
        final msg = c.lastMessage?.toLowerCase() ?? '';
        return name.contains(q) || msg.contains(q);
      }).toList();
    });
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 24) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${diff.inDays}d ago';
  }

  String _fmtAmount(double amount) {
    final s = amount.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifService.unreadCount;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [context.c.primaryLight, context.c.background],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Messages',
                              style: GoogleFonts.urbanist(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: context.c.textPrimary,
                              ),
                            ),
                            Text(
                              'Stay Connected with your Vendors',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: context.c.textHint,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.notifications),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: context.c.primaryLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '1',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.c.surface,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: context.c.textHint,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: _filter,
                              style: GoogleFonts.urbanist(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Search conversations',
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: context.c.textHint,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filtered.isEmpty
                    ? Center(
                        child: Text(
                          'No conversations yet',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: context.c.textHint,
                          ),
                        ),
                      )
                    : ListView.separated(
                        // Cap the row width on wide/desktop screens so
                        // conversations don't stretch edge-to-edge.
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              ((context.screenWidth - 760) / 2).clamp(0.0, 400.0),
                        ),
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 16),
                        itemBuilder: (context, i) {
                          final conv = _filtered[i];
                          return _ConversationTile(
                            conversation: conv,
                            timeStr: _formatTime(conv.lastMessageAt),
                            fmtAmount: _fmtAmount,
                            onTap: () {
                              _markReadLocal(conv.id);
                              if (conv.isGroup == true) {
                                context.push(
                                  AppRoutes.eventGroupChat,
                                  extra: {
                                    'eventId': conv.eventId ?? '',
                                    'eventName': conv.groupName ?? 'Group Chat',
                                    'conversationId': conv.id,
                                    'groupVendors': conv.groupVendors,
                                  },
                                );
                              } else {
                                context.push(AppRoutes.conversationDetailPath(conv.id));
                              }
                            },
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
  final String timeStr;
  final String Function(double) fmtAmount;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.timeStr,
    required this.fmtAmount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final conv = conversation;
    final vendor = conv.vendor;
    final hasPending = conv.pendingQuoteAmount != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: context.c.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            conv.isGroup == true
                ? _GroupAvatarStack(vendors: conv.groupVendors)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: vendor?.coverUrl != null
                        ? Image.network(
                            vendor!.coverUrl!,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 54,
                              height: 54,
                              color: context.c.primaryLight,
                              child: const Icon(Icons.store, color: AppColors.primary),
                            ),
                          )
                        : Container(
                            width: 54,
                            height: 54,
                            color: context.c.primaryLight,
                            child: const Icon(Icons.store, color: AppColors.primary),
                          ),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.isGroup == true
                              ? (conv.groupName ?? 'Group Chat')
                              : (vendor?.businessName ?? 'Vendor'),
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeStr,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (conv.isGroup == true)
                    Text(
                      'Group · ${conv.groupVendors.length} vendors',
                      style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textHint),
                    )
                  else if (hasPending)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Quote sent - ₦${fmtAmount(conv.pendingQuoteAmount!)} · ',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: context.c.textHint,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          'Tap to Review',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      conv.lastMessage ?? '',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textHint,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (conv.unreadCount > 0)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${conv.unreadCount}',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GroupAvatarStack extends StatelessWidget {
  final List<VendorModel> vendors;
  const _GroupAvatarStack({required this.vendors});

  @override
  Widget build(BuildContext context) {
    final shown = vendors.take(3).toList();
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        children: [
          // light purple background circle
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: context.c.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.group_rounded, color: AppColors.primary, size: 22),
          ),
          // stacked mini-avatars — bottom right corner
          ...shown.asMap().entries.map((entry) {
            final i = entry.key;
            final v = entry.value;
            return Positioned(
              right: i * 12.0,
              bottom: 0,
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: ClipOval(
                  child: v.coverUrl != null
                      ? Image.network(v.coverUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary,
                            child: Center(
                              child: Text(v.businessName[0],
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ))
                      : Container(
                          color: AppColors.primary,
                          child: Center(
                            child: Text(v.businessName[0],
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
