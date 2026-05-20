import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_messaging_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../core/utils/formatters.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messagingService = MockMessagingService();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  List<MessageModel> _messages = [];
  ConversationModel? _conversation;
  bool _loading = true;

  static const _currentUserId = 'user-001';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final convos = await _messagingService.getConversations();
    final msgs = await _messagingService.getMessages(widget.conversationId);
    setState(() {
      _conversation = convos.where((c) => c.id == widget.conversationId).firstOrNull;
      _messages = msgs;
      _loading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();

    final msg = await _messagingService.sendMessage(
      conversationId: widget.conversationId,
      content: text,
    );
    setState(() => _messages.add(msg));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: _conversation != null
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    child: ClipOval(
                      child: AppNetworkImage(url: _conversation!.vendor?.coverUrl, width: 36, height: 36),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _conversation!.vendor?.businessName ?? 'Vendor',
                        style: AppTextStyles.label,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 4),
                          Text('Online', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : const Text('Chat'),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final msg = _messages[i];
                      // Date separator
                      final showDate = i == 0 ||
                          !_isSameDay(_messages[i - 1].createdAt, msg.createdAt);
                      return Column(
                        children: [
                          if (showDate) _DateSeparator(date: msg.createdAt),
                          _MessageBubble(
                            message: msg,
                            isMe: msg.senderId == _currentUserId,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Input bar
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file_rounded, color: AppColors.textSecondary),
                          onPressed: () {},
                        ),
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              fillColor: AppColors.divider,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;

  const _DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final label = isToday ? 'Today' : Formatters.date(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: AppTextStyles.caption),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    if (message.type == 'quote' && message.quote != null) {
      return _QuoteCard(message: message, isMe: isMe);
    }
    if (message.type == 'system') {
      return _SystemCard(message: message);
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: isMe ? null : Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.content ?? '',
              style: AppTextStyles.body2.copyWith(
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              Formatters.time(message.createdAt),
              style: AppTextStyles.caption.copyWith(
                color: isMe ? Colors.white70 : AppColors.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const _QuoteCard({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final quote = message.quote!;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFE082)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Row(
                children: [
                  const Icon(Icons.receipt_outlined, size: 16, color: Color(0xFFE65100)),
                  const SizedBox(width: 6),
                  Text(
                    'Quote from ${quote.vendor?.businessName ?? 'Vendor'}',
                    style: AppTextStyles.label.copyWith(color: const Color(0xFFE65100)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFFFE082)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  ...quote.lineItems.take(3).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(item.label, style: AppTextStyles.caption)),
                        Text(Formatters.currency(item.amount), style: AppTextStyles.caption),
                      ],
                    ),
                  )),
                  if (quote.lineItems.length > 3)
                    Text('+${quote.lineItems.length - 3} more items', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                  const Divider(),
                  Row(
                    children: [
                      Text('Total', style: AppTextStyles.label),
                      const Spacer(),
                      Text(Formatters.currency(quote.amount), style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    foregroundColor: const Color(0xFFE65100),
                    side: const BorderSide(color: Color(0xFFFFE082)),
                  ),
                  child: const Text('View Invoice'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  final MessageModel message;

  const _SystemCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            const SizedBox(height: 6),
            Text('Invoice accepted', style: AppTextStyles.label.copyWith(color: AppColors.success)),
            const SizedBox(height: 2),
            Text(
              'Booking confirmed!',
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
