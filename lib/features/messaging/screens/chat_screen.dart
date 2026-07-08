import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../core/services/chat_socket.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/chat_orders_service.dart';
import '../../calls/call_screen.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/models/invoice_model.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/quote_model.dart';
import '../../../shared/widgets/chat_order_cards.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _service = MessagingService();
  final _orders = ChatOrdersService();
  final _socket = ChatSocket();
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  List<MessageModel> _messages = [];
  ConversationModel? _conversation;
  bool _loading = true;

  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) _currentUserId = auth.user.id;
    _resolveMyId();
    _load();
    _connectSocket();
  }

  /// Resolve the real current-user id (bearer auth) so message alignment works
  /// even when the AuthBloc user is empty.
  Future<void> _resolveMyId() async {
    final id = await _service.myId();
    if (id != null && id.isNotEmpty && mounted && id != _currentUserId) {
      setState(() => _currentUserId = id);
    }
  }

  @override
  void dispose() {
    _socket.leave(widget.conversationId);
    _socket.dispose();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _connectSocket() async {
    await _socket.connect();
    // Join once the server has authenticated us (and re-join on reconnect).
    _socket.onReady(() => _socket.join(widget.conversationId));
    _socket.join(widget.conversationId);
    _socket.onMessage((data) {
      final msg = MessageModel.fromJson(data);
      if (msg.conversationId != widget.conversationId) return;
      if (_messages.any((m) => m.id == msg.id)) return; // dedupe
      if (!mounted) return;
      setState(() => _messages.add(msg));
      _socket.markRead(widget.conversationId);
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
    _socket.onCallIncoming((d) {
      if (d['conversationId'] != widget.conversationId) return;
      if (!mounted) return;
      _openCall(); // auto-join the room (callee)
    });
  }

  Future<void> _load() async {
    try {
      final convos = await _service.getConversations();
      final msgs = await _service.getMessages(widget.conversationId);
      if (mounted) {
        setState(() {
          _conversation =
              convos.where((c) => c.id == widget.conversationId).firstOrNull;
          _messages = msgs;
          _loading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Chat-order actions (client side) ──────────────────────────────────────

  void _snack(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  String _err(Object e) => e.toString().replaceFirst('Exception: ', '');

  Future<void> _acceptQuote(String quoteId) async {
    try {
      await _orders.acceptQuote(quoteId);
      await _load();
      _snack('Quote accepted — invoice created 🎉');
    } catch (e) {
      _snack(_err(e));
    }
  }

  Future<void> _declineQuote(String quoteId) async {
    try {
      await _orders.declineQuote(quoteId);
      await _load();
      _snack('Quote declined');
    } catch (e) {
      _snack(_err(e));
    }
  }

  Future<void> _toggleTodo(String todoId) async {
    try {
      await _orders.toggleTodo(todoId);
      await _load();
    } catch (e) {
      _snack(_err(e));
    }
  }

  String _money(double v) {
    final s = v.toInt().toString();
    final b = StringBuffer('₦');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
      b.write(s[i]);
    }
    return b.toString();
  }

  Future<void> _showQuoteDetail(QuoteModel q) {
    Widget row(String label, String value, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            Expanded(
              child: Text(label,
                  style: GoogleFonts.urbanist(
                      fontSize: bold ? 15 : 13.5,
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                      color: bold ? context.c.textPrimary : context.c.textSecondary)),
            ),
            Text(value,
                style: GoogleFonts.urbanist(
                    fontSize: bold ? 16 : 13.5,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                    color: bold ? AppColors.primary : context.c.textPrimary)),
          ]),
        );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text(q.quoteNumber ?? 'Quote',
                    style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: context.c.textPrimary)),
                const SizedBox(height: 2),
                Text(
                  'Version ${q.version} · valid till ${q.validUntil.day}/${q.validUntil.month}/${q.validUntil.year}',
                  style: GoogleFonts.urbanist(fontSize: 12.5, color: context.c.textSecondary),
                ),
                const SizedBox(height: 16),
                Text('Line items',
                    style: GoogleFonts.urbanist(
                        fontSize: 13, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
                const SizedBox(height: 4),
                ...q.lineItems.map((li) => row(li.label, _money(li.amount))),
                const Divider(height: 20),
                row('Total', _money(q.amount), bold: true),
                if (q.paymentTerms.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text('Payment terms',
                      style: GoogleFonts.urbanist(
                          fontSize: 13, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
                  const SizedBox(height: 4),
                  ...q.paymentTerms.map((t) => row(
                        '${t.label}${t.dueLabel != null ? ' · ${t.dueLabel}' : ''}',
                        '${t.percentage.toInt()}%',
                      )),
                ],
                if (((q.notes ?? q.description) ?? '').isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text('Note from the vendor',
                      style: GoogleFonts.urbanist(
                          fontSize: 13, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
                  const SizedBox(height: 4),
                  Text((q.notes ?? q.description)!,
                      style: GoogleFonts.urbanist(fontSize: 13.5, color: context.c.textPrimary)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showReviewSheet(String bookingId) {
    var rating = 5;
    var submitting = false;
    final ctrl = TextEditingController();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text('Leave a review',
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setSheet(() => rating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 36,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ctrl,
                  maxLines: 3,
                  style: GoogleFonts.urbanist(color: context.c.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Share your experience…',
                    hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
                    filled: true,
                    fillColor: context.c.background,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: submitting
                        ? null
                        : () async {
                            if (ctrl.text.trim().isEmpty) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                const SnackBar(content: Text('Add a short comment')),
                              );
                              return;
                            }
                            setSheet(() => submitting = true);
                            try {
                              await _orders.submitReview(bookingId,
                                  rating: rating, body: ctrl.text.trim());
                              if (ctx.mounted) Navigator.pop(ctx);
                              await _load();
                              _snack('Review submitted ⭐');
                            } catch (e) {
                              setSheet(() => submitting = false);
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(_err(e))),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(submitting ? 'Submitting…' : 'Submit review'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _payMilestone(PaymentMilestone m) async {
    MilestoneCheckout checkout;
    try {
      checkout = await _orders.payMilestone(m.id);
    } catch (e) {
      _snack(_err(e));
      return;
    }
    final launched = await launchUrl(
      Uri.parse(checkout.authorizationUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted) return;
    if (!launched) {
      _snack('Could not open the payment page');
      return;
    }
    final done = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Finish payment',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w800)),
        content: Text(
          'Tap "I\'ve paid" once you\'ve completed the ₦${checkout.chargeAmount.toStringAsFixed(0)} '
          'payment (incl. ₦${checkout.feeAmount.toStringAsFixed(0)} transaction fee) on Paystack.',
          style: GoogleFonts.urbanist(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not yet')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("I've paid")),
        ],
      ),
    );
    if (done != true) return;
    try {
      final confirmed = await _orders.verifyPayment(checkout.reference);
      await _load();
      _snack(confirmed
          ? 'Payment received 🎉'
          : 'Payment is still processing — we\'ll update it shortly');
    } catch (e) {
      _snack(_err(e));
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

  void _openCall() {
    final name = _conversation?.vendor?.businessName ?? 'Vendor';
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CallScreen(
        conversationId: widget.conversationId,
        peerName: name,
      ),
    ));
  }

  void _startCall() {
    _socket.inviteCall(widget.conversationId); // ring the other side
    _openCall();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();
    // Send over the socket; the server persists + broadcasts back to the room
    // (including us), and the onMessage listener appends it — single source.
    _socket.sendMessage(conversationId: widget.conversationId, content: text);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final label = isToday ? 'Today' : '${date.day}/${date.month}/${date.year}';
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendor = _conversation?.vendor;
    final name = vendor?.businessName ?? 'Chat';
    return Scaffold(
      backgroundColor: context.c.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(name, vendor?.coverUrl),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? Center(
                          child: Text('Say hello 👋',
                              style: GoogleFonts.urbanist(color: context.c.textHint)),
                        )
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          itemCount: _messages.length,
                          itemBuilder: (context, i) {
                            final msg = _messages[i];
                            final showDate = i == 0 ||
                                !_isSameDay(_messages[i - 1].createdAt, msg.createdAt);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDate) _buildDateSeparator(msg.createdAt),
                                _buildMessage(msg),
                              ],
                            );
                          },
                        ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String? avatarUrl) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 10, 10),
      decoration: BoxDecoration(
        color: context.c.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: context.c.textPrimary),
            onPressed: () => context.pop(),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: context.c.primaryLight,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? const Icon(Icons.store, size: 18, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                  fontSize: 16, fontWeight: FontWeight.w800, color: context.c.textPrimary),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded, color: AppColors.primary),
            onPressed: _startCall,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel msg) {
    final isMe = msg.senderId == _currentUserId;

    // ── Chat-order structured cards ──
    if ((msg.type == 'quote' || msg.type == 'quote_revised') && msg.quote != null) {
      final q = msg.quote!;
      return QuoteCard(
        quote: q,
        onView: () => _showQuoteDetail(q),
        onAccept: q.canRespond ? () => _acceptQuote(q.id) : null,
        onDecline: q.canRespond ? () => _declineQuote(q.id) : null,
      );
    }
    if (msg.type == 'invoice' && msg.invoice != null) {
      return InvoiceCard(invoice: msg.invoice!, onPay: _payMilestone);
    }
    if (msg.type == 'order_request' && msg.booking != null) {
      return OrderRequestCard(booking: msg.booking!);
    }
    if (msg.type == 'todo' && msg.todo != null) {
      return TodoCard(
        todo: msg.todo!,
        currentUserId: _currentUserId,
        onToggle: () => _toggleTodo(msg.todo!.id),
      );
    }
    if (msg.type == 'quote_accepted') {
      return const ChatSystemBanner(
          label: 'Quote accepted', color: Color(0xFF047857), bg: Color(0xFFF0FDF4));
    }
    if (msg.type == 'quote_declined' ||
        msg.type == 'quote_expired' ||
        msg.type == 'invoice_declined' ||
        msg.type == 'order_declined') {
      return ChatSystemBanner(
        label: msg.type == 'quote_expired' ? 'Quote expired' : 'Declined',
        color: const Color(0xFFDC2626),
        bg: const Color(0xFFFEF2F2),
        icon: Icons.cancel_rounded,
      );
    }
    if (msg.type == 'invoice_accepted' ||
        msg.type == 'order_accepted' ||
        msg.type == 'booking_confirmed') {
      return const ChatSystemBanner(
          label: 'Confirmed', color: Color(0xFF047857), bg: Color(0xFFF0FDF4));
    }
    if (msg.type == 'milestone_paid' || msg.type == 'deposit_refunded') {
      final amt = msg.metadata['amount'];
      return ChatSystemBanner(
        label: msg.type == 'deposit_refunded'
            ? (amt != null ? 'Deposit refunded · ₦$amt' : 'Deposit refunded')
            : (amt != null ? 'Payment received · ₦$amt' : 'Payment received'),
        color: const Color(0xFF047857),
        bg: const Color(0xFFF0FDF4),
        icon: Icons.payments_rounded,
      );
    }
    if (msg.type == 'timeline_update') {
      return _buildStatusChip(
        label: msg.content ?? 'Order update',
        color: AppColors.primary,
        bg: context.c.primaryLight,
      );
    }
    if (msg.type == 'review_requested') {
      final bId = msg.booking?.id;
      return ReviewRequestCard(
        onReview: bId != null ? () => _showReviewSheet(bId) : null,
      );
    }
    if (msg.type == 'review_submitted') {
      final r = msg.metadata['rating'];
      return ChatSystemBanner(
        label: r != null ? 'Review submitted · $r★' : 'Review submitted ⭐',
        color: const Color(0xFFB45309),
        bg: const Color(0xFFFFFBEB),
        icon: Icons.star_rounded,
      );
    }

    if (msg.type == 'payment_confirmed') {
      return _buildPaymentConfirmed(msg.content ?? 'Payment confirmed');
    }

    if (msg.type == 'payment_pending') {
      return _buildPaymentPending(msg.content ?? 'Payment processing…');
    }

    if (msg.type == 'booking_cancelled') {
      return _buildBookingCancelled(msg.content ?? 'This booking has been cancelled.');
    }

    if (msg.type == 'dispute_raised') {
      return _buildDisputeRaised(msg.content ?? 'A dispute has been raised.');
    }

    if (msg.type == 'review_requested') {
      return _buildReviewRequested(msg.content ?? 'How did it go?');
    }

    if (msg.type == 'review_submitted') {
      return _buildStatusChip(
        label: 'Review submitted ⭐',
        color: const Color(0xFF4CAF50),
        bg: const Color(0xFFF0FDF4),
      );
    }

    if (msg.type == 'refund_requested') {
      return _buildRefundRequested(msg.content ?? 'Refund request submitted.');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 10,
              backgroundColor: context.c.primaryLight,
              backgroundImage: _conversation?.vendor?.coverUrl != null
                  ? NetworkImage(_conversation!.vendor!.coverUrl!)
                  : null,
              child: _conversation?.vendor?.coverUrl == null
                  ? const Icon(Icons.store, size: 10, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(width: 6),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                      colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                    )
                  : null,
              color: isMe ? null : context.c.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              msg.content ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: isMe ? Colors.white : context.c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({required String label, required Color color, required Color bg}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentConfirmed(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: const Color(0xFF86EFAC)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Confirmed',
                  style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700,
                    color: const Color(0xFF15803D))),
                const SizedBox(height: 2),
                Text(content,
                  style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPending(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFDE68A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFEF3C7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFD97706), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Processing',
                  style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700,
                    color: const Color(0xFFD97706))),
                const SizedBox(height: 2),
                Text(content,
                  style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCancelled(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Cancelled',
                  style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444))),
                const SizedBox(height: 2),
                Text(content,
                  style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeRaised(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFBBF24), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.gavel_rounded, color: Color(0xFFD97706), size: 20),
              ),
              const SizedBox(width: 10),
              Text('Dispute Raised',
                style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700,
                  color: const Color(0xFFD97706))),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
            style: GoogleFonts.urbanist(fontSize: 13, color: const Color(0xFF374151))),
          const SizedBox(height: 8),
          Text('Our team will review this dispute within 24 hours.',
            style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textHint)),
        ],
      ),
    );
  }

  Widget _buildReviewRequested(String content) {
    final vendor = _conversation?.vendor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 48, height: 48,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 26),
            ),
          ),
          const SizedBox(height: 12),
          Text('How was your experience?',
            style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.w800,
              color: context.c.textPrimary),
            textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(content,
            style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary),
            textAlign: TextAlign.center),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push(
              AppRoutes.leaveReview,
              extra: {'vendorId': vendor?.id, 'vendorName': vendor?.businessName},
            ),
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('Leave a Review',
                  style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w600,
                    color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefundRequested(String content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        border: Border.all(color: const Color(0xFFFBBF24), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_outlined,
                  color: Color(0xFFD97706), size: 20),
              ),
              const SizedBox(width: 10),
              Text('Refund Requested',
                style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.w700,
                  color: const Color(0xFFD97706))),
            ],
          ),
          const SizedBox(height: 10),
          Text(content,
            style: GoogleFonts.urbanist(fontSize: 13, color: const Color(0xFF374151))),
          const SizedBox(height: 8),
          Text('Refund will be processed within 5–7 business days.',
            style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textHint)),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: context.c.surface,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.c.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.c.divider,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.attach_file_rounded,
                color: Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.c.surfaceElevated,
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: TextField(
                  controller: _msgCtrl,
                  maxLines: null,
                  style: GoogleFonts.urbanist(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.c.divider,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
