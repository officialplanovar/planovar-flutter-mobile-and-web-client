import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../models/invoice_model.dart';
import '../models/message_model.dart';
import '../models/quote_model.dart';
import '../models/todo_model.dart';

String _money(double v) {
  final s = v.toInt().toString();
  final b = StringBuffer('₦');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

// ─── Inline status banner (accepted / declined / milestone paid, etc.) ────────

class ChatSystemBanner extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData icon;

  const ChatSystemBanner({
    super.key,
    required this.label,
    required this.color,
    required this.bg,
    this.icon = Icons.check_circle_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.urbanist(
                    fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Color accent;
  final Color accentBg;
  final Widget child;
  const _CardShell({required this.accent, required this.accentBg, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

// ─── Quote card ───────────────────────────────────────────────────────────────

class QuoteCard extends StatefulWidget {
  final QuoteModel quote;
  final Future<void> Function()? onAccept;
  final Future<void> Function()? onDecline;
  final VoidCallback? onView;

  const QuoteCard({
    super.key,
    required this.quote,
    this.onAccept,
    this.onDecline,
    this.onView,
  });

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _busy = false;

  Future<void> _run(Future<void> Function()? fn) async {
    if (fn == null || _busy) return;
    setState(() => _busy = true);
    try {
      await fn();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quote;
    const amber = Color(0xFFB45309);
    return _CardShell(
      accent: amber,
      accentBg: const Color(0xFFFFFBEB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_rounded, size: 20, color: amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  q.vendor?.businessName != null
                      ? 'Quote from ${q.vendor!.businessName}'
                      : 'Quote',
                  style: GoogleFonts.urbanist(
                      fontSize: 15, fontWeight: FontWeight.w800, color: context.c.textPrimary),
                ),
              ),
              if (q.version > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: amber.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('v${q.version}',
                      style: GoogleFonts.urbanist(
                          fontSize: 11, fontWeight: FontWeight.w700, color: amber)),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            q.canRespond
                ? 'Valid till ${_date(q.validUntil)}'
                : _statusLabel(q.status),
            style: GoogleFonts.urbanist(
                fontSize: 12, fontWeight: FontWeight.w600, color: amber),
          ),
          const SizedBox(height: 10),
          ...q.lineItems.map((li) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(li.label,
                          style: GoogleFonts.urbanist(
                              fontSize: 13, color: context.c.textSecondary)),
                    ),
                    Text(_money(li.amount),
                        style: GoogleFonts.urbanist(
                            fontSize: 13, fontWeight: FontWeight.w600, color: context.c.textPrimary)),
                  ],
                ),
              )),
          const Divider(height: 16),
          Row(
            children: [
              Text('Total',
                  style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
              const Spacer(),
              Text(_money(q.amount),
                  style: GoogleFonts.urbanist(
                      fontSize: 17, fontWeight: FontWeight.w800, color: amber)),
            ],
          ),
          if (widget.onView != null) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: widget.onView,
              child: Text('View details',
                  style: GoogleFonts.urbanist(
                      fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
          if (q.canRespond && (widget.onAccept != null || widget.onDecline != null)) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (widget.onDecline != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _busy ? null : () => _run(widget.onDecline),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                if (widget.onDecline != null && widget.onAccept != null)
                  const SizedBox(width: 10),
                if (widget.onAccept != null)
                  Expanded(
                    child: FilledButton(
                      onPressed: _busy ? null : () => _run(widget.onAccept),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _busy
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Accept'),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Invoice card (with per-milestone pay) ────────────────────────────────────

class InvoiceCard extends StatefulWidget {
  final InvoiceModel invoice;
  final Future<void> Function(PaymentMilestone milestone)? onPay;
  final VoidCallback? onView;

  const InvoiceCard({super.key, required this.invoice, this.onPay, this.onView});

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  String? _payingId;

  Future<void> _pay(PaymentMilestone m) async {
    if (widget.onPay == null || _payingId != null) return;
    setState(() => _payingId = m.id);
    try {
      await widget.onPay!(m);
    } finally {
      if (mounted) setState(() => _payingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inv = widget.invoice;
    const green = Color(0xFF047857);
    return _CardShell(
      accent: green,
      accentBg: const Color(0xFFF0FDF4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, size: 20, color: green),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Invoice · ${inv.invoiceNumber}',
                    style: GoogleFonts.urbanist(
                        fontSize: 15, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
              ),
              Text(_statusLabel(inv.status),
                  style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: green)),
            ],
          ),
          const SizedBox(height: 10),
          ...inv.lineItems.map((li) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  Expanded(
                    child: Text(li.label,
                        style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
                  ),
                  Text(_money(li.amount),
                      style: GoogleFonts.urbanist(
                          fontSize: 13, fontWeight: FontWeight.w600, color: context.c.textPrimary)),
                ]),
              )),
          const Divider(height: 16),
          Row(children: [
            Text('Total',
                style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
            const Spacer(),
            Text(_money(inv.total),
                style: GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w800, color: green)),
          ]),
          if (inv.milestones.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Payment schedule',
                style: GoogleFonts.urbanist(
                    fontSize: 12, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
            const SizedBox(height: 6),
            ...inv.milestones.map((m) => _milestoneRow(context, m, green)),
          ],
        ],
      ),
    );
  }

  Widget _milestoneRow(BuildContext context, PaymentMilestone m, Color green) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.c.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.label,
                    style: GoogleFonts.urbanist(
                        fontSize: 13, fontWeight: FontWeight.w700, color: context.c.textPrimary)),
                Text(
                  '${_money(m.amount)}${m.dueLabel != null ? ' · ${m.dueLabel}' : ''}',
                  style: GoogleFonts.urbanist(fontSize: 11.5, color: context.c.textSecondary),
                ),
              ],
            ),
          ),
          if (m.isPaid)
            Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF047857)),
              SizedBox(width: 4),
              Text('Paid',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF047857))),
            ])
          else if (widget.onPay != null)
            SizedBox(
              height: 34,
              child: FilledButton(
                onPressed: _payingId != null ? null : () => _pay(m),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                ),
                child: _payingId == m.id
                    ? const SizedBox(
                        width: 14, height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Pay'),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Order-request card (client's own request, awaiting vendor) ───────────────

class OrderRequestCard extends StatelessWidget {
  final OrderBookingRef booking;
  const OrderRequestCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final pending = booking.status == 'pending';
    return _CardShell(
      accent: AppColors.primary,
      accentBg: context.c.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.shopping_bag_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(booking.listingTitle ?? 'Order request',
                  style: GoogleFonts.urbanist(
                      fontSize: 14, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
            ),
            if (booking.total != null)
              Text(_money(booking.total!),
                  style: GoogleFonts.urbanist(
                      fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
          ]),
          const SizedBox(height: 6),
          Text(
            pending
                ? 'Awaiting the vendor to accept your request'
                : _statusLabel(booking.status),
            style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Review request card ──────────────────────────────────────────────────────

class ReviewRequestCard extends StatelessWidget {
  final VoidCallback? onReview;
  const ReviewRequestCard({super.key, this.onReview});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      accent: AppColors.primary,
      accentBg: context.c.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.star_rounded, size: 20, color: Color(0xFFF59E0B)),
            const SizedBox(width: 8),
            Expanded(
              child: Text('How did it go?',
                  style: GoogleFonts.urbanist(
                      fontSize: 15, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
            ),
          ]),
          const SizedBox(height: 4),
          Text('Your booking is complete — leave the vendor a review.',
              style: GoogleFonts.urbanist(fontSize: 12.5, color: context.c.textSecondary)),
          if (onReview != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onReview,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Leave a review'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── To-do card (group chat) ──────────────────────────────────────────────────

class TodoCard extends StatefulWidget {
  final TodoModel todo;
  final String currentUserId;
  final Future<void> Function()? onToggle;

  const TodoCard({
    super.key,
    required this.todo,
    required this.currentUserId,
    this.onToggle,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.todo;
    final mine = t.mine(widget.currentUserId);
    return _CardShell(
      accent: AppColors.primary,
      accentBg: context.c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.checklist_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(t.title,
                  style: GoogleFonts.urbanist(
                      fontSize: 14, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
            ),
            Text('${t.doneCount}/${t.totalCount}',
                style: GoogleFonts.urbanist(
                    fontSize: 12, fontWeight: FontWeight.w700, color: context.c.textSecondary)),
          ]),
          if (t.description != null && t.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(t.description!,
                style: GoogleFonts.urbanist(fontSize: 12.5, color: context.c.textSecondary)),
          ],
          if (t.dueAt != null) ...[
            const SizedBox(height: 4),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.schedule_rounded, size: 13, color: context.c.textHint),
              const SizedBox(width: 4),
              Text('Due ${_date(t.dueAt!)}',
                  style: GoogleFonts.urbanist(fontSize: 11.5, color: context.c.textHint)),
            ]),
          ],
          if (mine != null && widget.onToggle != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _busy
                  ? null
                  : () async {
                      setState(() => _busy = true);
                      try {
                        await widget.onToggle!();
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
              child: Row(children: [
                Icon(
                  mine.isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  size: 20,
                  color: mine.isDone ? AppColors.primary : context.c.textHint,
                ),
                const SizedBox(width: 8),
                Text(mine.isDone ? 'You completed your task' : 'Mark your task done',
                    style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: mine.isDone ? AppColors.primary : context.c.textPrimary)),
                if (_busy) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                      width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              ]),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── helpers ──────────────────────────────────────────────────────────────────

String _statusLabel(String status) {
  switch (status) {
    case 'accepted':
      return 'Accepted';
    case 'rejected':
    case 'declined':
      return 'Declined';
    case 'expired':
      return 'Expired';
    case 'superseded':
      return 'Updated — see the latest quote';
    case 'paid':
      return 'Paid';
    case 'partially_paid':
      return 'Partially paid';
    case 'cancelled':
      return 'Cancelled';
    case 'confirmed':
      return 'Confirmed';
    default:
      return status.isEmpty ? '' : status[0].toUpperCase() + status.substring(1);
  }
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';
