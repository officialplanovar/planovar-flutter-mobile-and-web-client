import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/mock/mock_messaging_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/vendor_model.dart';

class EventGroupChatScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String? conversationId;
  final List<VendorModel> groupVendors;

  const EventGroupChatScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    this.conversationId,
    this.groupVendors = const [],
  });

  @override
  State<EventGroupChatScreen> createState() => _EventGroupChatScreenState();
}

class _EventGroupChatScreenState extends State<EventGroupChatScreen> {
  final _service = MockMessagingService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  static const _currentUserId = 'user-001';
  static const _myName = 'Adaeze';
  static const _myAvatar = 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100';

  List<MessageModel> _messages = [];
  bool _loading = true;

  // fallback hardcoded messages used when no conversationId provided
  static const _fallbackMessages = [
    _GCMsg(id: 'm1', senderId: 'user-001', text: 'Hey everyone, how is the event preparation going?', time: '9:10 AM', senderName: 'Adaeze', avatarUrl: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100'),
    _GCMsg(id: 'm2', senderId: 'vendor-03', text: 'We\'re all set for the photography! Arriving at 8am sharp.', time: '9:15 AM', senderName: 'Lumière Photography', avatarUrl: 'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=100'),
    _GCMsg(id: 'm3', senderId: 'vendor-02', text: 'Cake delivery confirmed for 10am. 4-tier champagne & strawberry.', time: '9:20 AM', senderName: 'Sugared Dreams', avatarUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=100'),
    _GCMsg(id: 'm4', senderId: 'user-001', text: 'Perfect! Please make sure you coordinate with the venue manager on arrival.', time: '9:25 AM', senderName: 'Adaeze', avatarUrl: 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.conversationId != null) {
      final msgs = await _service.getMessages(widget.conversationId!);
      if (mounted) {
        setState(() {
          _messages = msgs;
          _loading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } else {
      setState(() => _loading = false);
    }
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Resolve sender display info from groupVendors list
  ({String name, String? avatarUrl}) _senderInfo(String senderId) {
    if (senderId == _currentUserId) return (name: _myName, avatarUrl: _myAvatar);
    for (final v in widget.groupVendors) {
      if (v.id == senderId) return (name: v.businessName, avatarUrl: v.coverUrl);
    }
    return (name: 'Vendor', avatarUrl: null);
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // Member avatars for header: my avatar + vendor avatars (max 3 shown)
    final memberAvatars = <String?>[_myAvatar, ...widget.groupVendors.map((v) => v.coverUrl)];
    final onlineCount = (widget.groupVendors.length + 1 > 2) ? 2 : widget.groupVendors.length;
    final totalCount = widget.groupVendors.length + 1; // vendors + organiser

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildHeader(context, memberAvatars, onlineCount, totalCount),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : widget.conversationId != null
                    ? _buildLiveList()
                    : _buildFallbackList(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildLiveList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (ctx, i) {
        final msg = _messages[i];
        final showDate = i == 0 || !_isSameDay(_messages[i - 1].createdAt, msg.createdAt);
        return Column(
          children: [
            if (showDate) _buildDateSeparator(msg.createdAt),
            _buildLiveMessage(msg),
          ],
        );
      },
    );
  }

  Widget _buildFallbackList() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.all(16),
      itemCount: _fallbackMessages.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) return _buildDateLabel('Today');
        final msg = _fallbackMessages[i - 1];
        return _buildFallbackMessage(msg);
      },
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final isToday = _isSameDay(date, now);
    final label = isToday ? 'Today' : '${date.day}/${date.month}/${date.year}';
    return _buildDateLabel(label);
  }

  Widget _buildDateLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: GoogleFonts.urbanist(fontSize: 12, color: const Color(0xFF9CA3AF))),
          ),
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        ],
      ),
    );
  }

  Widget _buildLiveMessage(MessageModel msg) {
    final isMe = msg.senderId == _currentUserId;
    final info = _senderInfo(msg.senderId);
    return _buildBubble(
      isMe: isMe,
      text: msg.content ?? '',
      time: _formatTime(msg.createdAt),
      senderName: info.name,
      avatarUrl: info.avatarUrl,
    );
  }

  Widget _buildFallbackMessage(_GCMsg msg) {
    final isMe = msg.senderId == _currentUserId;
    return _buildBubble(
      isMe: isMe,
      text: msg.text,
      time: msg.time,
      senderName: msg.senderName,
      avatarUrl: msg.avatarUrl,
    );
  }

  Widget _buildBubble({
    required bool isMe,
    required String text,
    required String time,
    required String senderName,
    String? avatarUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _Avatar(url: avatarUrl, size: 28),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: isMe ? const LinearGradient(colors: [Color(0xFFAB52F5), Color(0xFF7420D0)]) : null,
              color: isMe ? null : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1)),
              ],
            ),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(senderName,
                        style: GoogleFonts.urbanist(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                Text(text,
                    style: GoogleFonts.urbanist(fontSize: 14, color: isMe ? Colors.white : const Color(0xFF1A1A2E))),
                const SizedBox(height: 3),
                Text(time,
                    style: GoogleFonts.urbanist(
                        fontSize: 10,
                        color: isMe ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF9CA3AF))),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            _Avatar(url: avatarUrl, size: 28),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<String?> memberAvatars, int onlineCount, int totalCount) {
    final shown = memberAvatars.take(3).toList();
    return Container(
      color: AppColors.primaryLight,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16, right: 16, bottom: 14,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF1A1A2E)),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 20.0 * shown.length + 16,
            height: 36,
            child: Stack(
              children: shown.asMap().entries.map((entry) {
                return Positioned(
                  left: entry.key * 20.0,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: ClipOval(child: _Avatar(url: entry.value, size: 36)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.eventName,
                    style: GoogleFonts.urbanist(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$onlineCount of $totalCount members online',
                    style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.primary)),
              ],
            ),
          ),
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFAB52F5), Color(0xFF7420D0)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 12, right: 12, top: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.attach_file_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      style: GoogleFonts.urbanist(fontSize: 14),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: GoogleFonts.urbanist(fontSize: 14, color: const Color(0xFF9CA3AF)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const Icon(Icons.mic_rounded, color: Color(0xFF9CA3AF), size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              if (_msgCtrl.text.trim().isEmpty) return;
              _msgCtrl.clear();
            },
            child: Container(
              width: 46, height: 46,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFAB52F5), Color(0xFF7420D0)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar helper ─────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String? url;
  final double size;
  const _Avatar({this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return ClipOval(
        child: Image.network(url!, width: size, height: size, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder()),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: size, height: size,
        decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
        child: const Icon(Icons.person, color: AppColors.primary, size: 14),
      );
}

// ─── Fallback message model ────────────────────────────────────────────────────
class _GCMsg {
  final String id, senderId, text, time, senderName, avatarUrl;
  const _GCMsg({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.senderName,
    required this.avatarUrl,
  });
}
