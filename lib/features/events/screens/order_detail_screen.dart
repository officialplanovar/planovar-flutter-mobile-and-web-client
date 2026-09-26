import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/listing_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/off_platform_notice.dart';
import '../../../l10n/app_localizations.dart';

class OrderDetailScreen extends StatefulWidget {
  final String bookingId;
  final String listingId;
  final String status;

  const OrderDetailScreen({
    super.key,
    this.bookingId = '',
    required this.listingId,
    required this.status,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _bookingService = BookingService();
  final _listingService = ListingService();

  BookingModel? _booking;
  ListingModel? _listing;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      BookingModel? booking;
      if (widget.bookingId.isNotEmpty) {
        booking = await _bookingService.getBooking(widget.bookingId);
      }
      // The booking's nested listing carries no media, so fetch the full
      // listing (real image/title) by id.
      final listingId = booking?.listingId.isNotEmpty == true
          ? booking!.listingId
          : widget.listingId;
      ListingModel? listing;
      if (listingId.isNotEmpty) {
        listing = await _listingService.getListing(listingId);
      }
      if (!mounted) return;
      setState(() {
        _booking = booking;
        _listing = listing;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (_loading) {
      return Scaffold(
        backgroundColor: context.c.background,
        appBar: AppBar(title: Text(t.orderDetails)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final booking = _booking;
    final listing = _listing;
    if (booking == null && listing == null) {
      return Scaffold(
        backgroundColor: context.c.background,
        appBar: AppBar(title: Text(t.orderDetails)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              t.orderCouldNotLoad,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    // Real status: prefer the booking's, fall back to the routed label.
    final status = booking?.status ?? widget.status;
    final isCompleted = status == 'completed';
    final isCancelled = status == 'cancelled';

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: context.c.primaryLight,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    t.orderDetails,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          // ── Body ────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummaryCard(context, booking, listing),
                  const SizedBox(height: 16),
                  _buildStatusCard(context, status),
                  if (booking != null) ...[
                    const SizedBox(height: 16),
                    _buildFeeBreakdownCard(context, booking),
                  ],
                  if (booking != null && booking.milestones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildPaymentHistoryCard(context, booking),
                  ],
                  if (booking != null &&
                      (booking.milestones.isNotEmpty || booking.feeLines.isNotEmpty)) ...[
                    const SizedBox(height: 12),
                    const OffPlatformPaymentNotice(),
                  ],
                  if (booking?.requirements?.isNotEmpty == true) ...[
                    const SizedBox(height: 16),
                    _buildRequirementsCard(context, booking!.requirements!),
                  ],
                  const SizedBox(height: 24),
                  _buildBottomButton(context, isCompleted, isCancelled),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(
    BuildContext context,
    BookingModel? booking,
    ListingModel? listing,
  ) {
    final t = AppLocalizations.of(context);
    final title = listing?.title ?? booking?.listing?.title ?? t.orderFallback;
    final media = listing?.media ?? const <String>[];
    final vendorName = booking?.vendor?.businessName ??
        listing?.vendor?.businessName ??
        t.vendorLabel;
    final eventDate = booking?.eventDate;
    final amount = booking?.finalAmount ?? booking?.quoteAmount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: media.isNotEmpty
                    ? Image.network(
                        media.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, st) => _imgPlaceholder(context),
                      )
                    : _imgPlaceholder(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (eventDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        Formatters.date(eventDate),
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Text(
                      vendorName,
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: context.c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (booking?.eventLocation?.isNotEmpty == true) ...[
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: context.c.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    booking!.eventLocation!,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (amount != null) ...[
            const Divider(height: 24),
            Row(
              children: [
                Text(
                  t.total,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  Formatters.currency(amount),
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Current-status indicator driven purely by the real booking status —
  /// no fabricated dates or amounts.
  Widget _buildStatusCard(BuildContext context, String status) {
    final t = AppLocalizations.of(context);
    final (label, bg, fg) = _statusStyle(status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            t.statusHeading,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.c.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsCard(BuildContext context, String requirements) {
    final t = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.requirements,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            requirements,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              height: 1.5,
              color: context.c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _cardTitle(BuildContext context, String text) => Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: context.c.textPrimary,
        ),
      );

  Widget _feeRow(BuildContext context, String label, String value,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                color: bold ? context.c.textPrimary : context.c.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: context.c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeBreakdownCard(BuildContext context, BookingModel b) {
    final t = AppLocalizations.of(context);
    final rows = <Widget>[];
    if (b.feeLines.isNotEmpty) {
      for (final line in b.feeLines) {
        rows.add(_feeRow(context, line.label, Formatters.currency(line.amount)));
      }
    } else {
      final subtotal = b.invoiceSubtotal;
      if (subtotal != null) {
        rows.add(_feeRow(context, t.orderSubtotal, Formatters.currency(subtotal)));
      }
      if ((b.deliveryFee ?? 0) > 0) {
        rows.add(_feeRow(context, t.orderDeliveryFee, Formatters.currency(b.deliveryFee!)));
      }
      if ((b.depositAmount ?? 0) > 0) {
        rows.add(_feeRow(context, t.orderDeposit, Formatters.currency(b.depositAmount!)));
      }
    }
    final total = b.invoiceTotal ?? b.finalAmount ?? b.quoteAmount;
    if (rows.isEmpty && total == null) return const SizedBox.shrink();
    return _card(context, children: [
      _cardTitle(context, t.orderFeeBreakdown),
      const SizedBox(height: 8),
      ...rows,
      if (total != null) ...[
        Divider(color: context.c.border, height: 20),
        _feeRow(context, t.orderTotal, Formatters.currency(total), bold: true),
      ],
    ]);
  }

  Widget _buildPaymentHistoryCard(BuildContext context, BookingModel b) {
    final t = AppLocalizations.of(context);
    return _card(context, children: [
      _cardTitle(context, t.orderPaymentHistory),
      const SizedBox(height: 4),
      ...b.milestones.map((m) {
        final paid = m.isPaid;
        final sub = paid && m.paidAt != null
            ? '${t.orderPaid} · ${Formatters.date(m.paidAt!)}'
            : (m.dueAt != null
                ? '${t.orderDue} · ${Formatters.date(m.dueAt!)}'
                : t.orderPending);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                paid ? Icons.check_circle_rounded : Icons.schedule_rounded,
                size: 20,
                color: paid ? const Color(0xFF10B981) : context.c.textHint,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.label,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.c.textPrimary,
                      ),
                    ),
                    Text(
                      sub,
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        color: context.c.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.currency(m.amount),
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        );
      }),
    ]);
  }

  (String, Color, Color) _statusStyle(String status) {
    final t = AppLocalizations.of(context);
    switch (status) {
      case 'completed':
        return (t.statusDelivered, const Color(0xFFD1FAE5), const Color(0xFF065F46));
      case 'confirmed':
        return (
          t.statusOrderConfirmed,
          const Color(0xFFD1FAE5),
          const Color(0xFF065F46)
        );
      case 'active':
        return (
          t.statusOutForDelivery,
          const Color(0xFFEDE9FE),
          AppColors.primary
        );
      case 'cancelled':
        return (t.cancelledLabel, const Color(0xFFFFE4E6), const Color(0xFFEF4444));
      default:
        return (
          t.statusOrderPlaced,
          const Color(0xFFFEF3C7),
          const Color(0xFFB45309)
        );
    }
  }

  Widget _buildBottomButton(
      BuildContext context, bool isCompleted, bool isCancelled) {
    final t = AppLocalizations.of(context);
    if (isCancelled) {
      return const SizedBox.shrink();
    }
    if (isCompleted) {
      return const SizedBox.shrink();
    }
    return _RedOutlineButton(
      label: t.cancelOrderWarn,
      onPressed: () => context.push(AppRoutes.cancelOrder),
    );
  }

  Widget _imgPlaceholder(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.shopping_bag_outlined,
            color: AppColors.primary, size: 28),
      );
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _RedOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _RedOutlineButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
            ),
          ),
        ),
      ),
    );
  }
}
