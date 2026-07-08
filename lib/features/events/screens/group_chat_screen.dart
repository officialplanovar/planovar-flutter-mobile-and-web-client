import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/chat_orders_service.dart';
import '../../../core/services/chat_socket.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/chat_order_cards.dart';
import '../../../shared/widgets/create_todo_sheet.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

/// Real event GROUP chat — get-or-creates the conversation (auto-adds every
/// event vendor), streams messages over the socket, supports to-dos, and free
/// chat. Quotes/invoices are DM-only, so they don't appear here.
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
  final _service = MessagingService();
  final _orders = ChatOrdersService();
  final _socket = ChatSocket();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  String _currentUserId = '';
  String? _conversationId;
  ConversationModel? _conversation;
  List<MessageModel> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) _currentUserId = auth.user.id;
    _resolveMyId();
    _load(connect: true);
  }

  Future<void> _resolveMyId() async {
    final id = await _service.myId();
    if (id != null && id.isNotEmpty && mounted && id != _currentUserId) {
      setState(() => _currentUserId = id);
    }
  }

  @override
  void dispose() {
    if (_conversationId != null) _socket.leave(_conversationId!);
    _socket.dispose();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool connect = false}) async {
    try {
      final conv = await _service.getOrCreateEventGroup(widget.eventId);
      final msgs = await _service.getMessages(conv.id);
      if (!mounted) return;
      setState(() {
        _conversation = conv;
        _conversationId = conv.id;
        _messages = msgs;
        _loading = false;
      });
      if (connect) _connectSocket(conv.id);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connectSocket(String convId) async {
    await _socket.connect();
    _socket.onReady(() => _socket.join(convId));
    _socket.join(convId);
    _socket.onMessage((data) {
      final msg = MessageModel.fromJson(data);
      if (msg.conversationId != convId) return;
      if (_messages.any((m) => m.id == msg.id)) return;
      if (!mounted) return;
      setState(() => _messages.add(msg));
      _socket.markRead(convId);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _conversationId == null) return;
    _msgCtrl.clear();
    _socket.sendMessage(conversationId: _conversationId!, content: text);
  }

  Future<void> _toggleTodo(String todoId) async {
    try {
      await _orders.toggleTodo(todoId);
      await _load();
    } catch (_) {}
  }

  void _addTodo() {
    if (_conversation == null || _conversationId == null) return;
    final members = _conversation!.participants
        .map((p) => TodoMemberOption(userId: p.userId, name: p.name))
        .toList();
    if (members.isEmpty) {
      members.add(TodoMemberOption(userId: _currentUserId, name: 'You'));
    }
    showCreateTodoSheet(
      context,
      conversationId: _conversationId!,
      members: members,
      currentUserId: _currentUserId,
      onCreated: _load,
    );
  }

  String _senderName(String id) {
    if (id == _currentUserId) return 'You';
    for (final p in _conversation?.participants ?? const <ChatParticipant>[]) {
      if (p.userId == id) return p.name;
    }
    return 'Member';
  }

  @override
  Widget build(BuildContext context) {
    final memberCount =
        _conversation?.participants.length ?? (widget.groupVendors.length + 1);
    return Scaffold(
      backgroundColor: context.c.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(memberCount),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? Center(
                          child: Text('No messages yet — say hello 👋',
                              style: GoogleFonts.urbanist(color: context.c.textHint)))
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          itemCount: _messages.length,
                          itemBuilder: (context, i) => _buildMessage(_messages[i]),
                        ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int memberCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 10),
      decoration: BoxDecoration(
        color: context.c.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: context.c.textPrimary),
            onPressed: () => context.pop(),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: context.c.primaryLight, shape: BoxShape.circle),
            child: const Icon(Icons.groups_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                        fontSize: 16, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
                Text('$memberCount members',
                    style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textSecondary)),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Add a to-do',
            icon: const Icon(Icons.playlist_add_check_rounded, color: AppColors.primary),
            onPressed: _addTodo,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel msg) {
    if (msg.type == 'todo' && msg.todo != null) {
      return TodoCard(
        todo: msg.todo!,
        currentUserId: _currentUserId,
        onToggle: () => _toggleTodo(msg.todo!.id),
      );
    }
    if (msg.type == 'milestone_paid' || msg.type == 'deposit_refunded') {
      return const ChatSystemBanner(
          label: 'Payment update', color: Color(0xFF047857), bg: Color(0xFFF0FDF4), icon: Icons.payments_rounded);
    }
    if (msg.type == 'booking_confirmed' ||
        msg.type == 'order_accepted' ||
        msg.type == 'quote_accepted') {
      return const ChatSystemBanner(
          label: 'Confirmed', color: Color(0xFF047857), bg: Color(0xFFF0FDF4));
    }

    // Plain chat bubble
    final isMe = msg.senderId == _currentUserId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 2),
              child: Text(_senderName(msg.senderId),
                  style: GoogleFonts.urbanist(
                      fontSize: 11, fontWeight: FontWeight.w600, color: context.c.textHint)),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(colors: [Color(0xFFAB52F5), Color(0xFF7420D0)])
                  : null,
              color: isMe ? null : context.c.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              border: isMe ? null : Border.all(color: context.c.border),
            ),
            child: Text(
              msg.content ?? '',
              style: GoogleFonts.urbanist(
                  fontSize: 14, color: isMe ? Colors.white : context.c.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(top: BorderSide(color: context.c.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgCtrl,
              style: GoogleFonts.urbanist(color: context.c.textPrimary),
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Message the group…',
                hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
                filled: true,
                fillColor: context.c.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.c.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: context.c.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
