import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';

class OrderDetailScreen extends StatelessWidget {
  final String listingId;
  final String status;

  const OrderDetailScreen({
    super.key,
    required this.listingId,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final listing = MockData.listings.firstWhere(
      (l) => l.id == listingId,
      orElse: () => MockData.listings.first,
    );
    final isCompleted = status == 'completed';
    final isPending = status.toLowerCase().contains('pending') ||
        status == 'Order placed' ||
        status == 'Order Confirmed' ||
        status == 'In Production' ||
        status == 'Out for Delivery';

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
                    'Order Details',
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
                  // ── Order Summary Card ──────────────────────────────────
                  _buildOrderSummaryCard(context, listing),
                  const SizedBox(height: 16),
                  // ── Booking Timeline Card ───────────────────────────────
                  _buildTimelineCard(context, isCompleted),
                  const SizedBox(height: 16),
                  // ── Banner ─────────────────────────────────────────────
                  _buildBanner(context, isPending, isCompleted),
                  const SizedBox(height: 24),
                  // ── Bottom Button ──────────────────────────────────────
                  _buildBottomButton(context, isCompleted, isPending),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, dynamic listing) {
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
                child: listing.media.isNotEmpty
                    ? Image.network(
                        listing.media.first,
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
                      listing.title,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '13 Mar 2026',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: context.c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      listing.vendor?.businessName ?? 'Vendor',
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
          const SizedBox(height: 14),
          // Status row
          Row(
            children: [
              Text(
                'Status',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: context.c.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Order placed',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Fee rows
          _feeRow(context, 'Platform Fee', '₦2,300'),
          _feeRow(context, 'Delivery (Lagos Island → Lekki)', '₦5,000'),
          _feeRow(context, 'Sub-total', '₦307,300'),
          const Divider(height: 24),
          // Total
          Row(
            children: [
              Text(
                'Total',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '₦ 302,300',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feeRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textSecondary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context, bool isCompleted) {
    final steps = [
      _OrderTimelineStep(
        number: 1,
        title: 'Order placed',
        subtitle: '12 May 2026, 10:47 AM · Paid ₦91,700',
        isComplete: true,
      ),
      _OrderTimelineStep(
        number: 2,
        title: 'Vendor confirmed',
        subtitle: '12 May 2026, 11:15 AM · Sugared Dreams accepted',
        isComplete: true,
      ),
      _OrderTimelineStep(
        number: 3,
        title: 'In Production',
        subtitle: 'Your cake is being crafted · Est. ready 16 May',
        isComplete: isCompleted,
      ),
      _OrderTimelineStep(
        number: 4,
        title: 'Ready for Pick up',
        subtitle: 'Ready for pick up at 23 Afe way Lagos',
        isComplete: isCompleted,
      ),
      _OrderTimelineStep(
        number: 5,
        title: 'Picked Up',
        subtitle: '15 Admiralty Way, Lekki Phase 1',
        isComplete: isCompleted,
      ),
    ];

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
          Text(
            'Booking Timeline',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isLast = i == steps.length - 1;
            return _buildTimelineStep(context, step, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
      BuildContext context, _OrderTimelineStep step, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: step.isComplete ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: step.isComplete
                    ? null
                    : Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  '${step.number}',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: step.isComplete ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: context.c.border,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 28, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: step.isComplete
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    step.isComplete ? 'Complete' : 'Pending',
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: step.isComplete
                          ? const Color(0xFF065F46)
                          : const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context, bool isPending, bool isCompleted) {
    if (isCompleted) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_shipping_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Order Delivered: You have ',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'a 3 day',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: ' window for return/refund',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textPrimary,
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

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.c.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Estimated delivery: ',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: '3–5 business days',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' from order confirmation',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textPrimary,
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

  Widget _buildBottomButton(
      BuildContext context, bool isCompleted, bool isPending) {
    if (isCompleted) {
      return _OutlineButton(
        label: '↻ Re Order',
        color: AppColors.primary,
        onTap: () {},
      );
    }
    if (isPending) {
      return _RedOutlineButton(
        label: '⚠ Cancel Order',
        onPressed: () => context.push(AppRoutes.cancelOrder),
      );
    }
    // delivered
    return _RedOutlineButton(
      label: '⚠ Request Refund',
      onPressed: () => context.push(AppRoutes.requestRefund),
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

class _OutlineButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderTimelineStep {
  final int number;
  final String title;
  final String subtitle;
  final bool isComplete;

  const _OrderTimelineStep({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.isComplete,
  });
}
