import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

class RentalDetailScreen extends StatefulWidget {
  final String listingId;

  const RentalDetailScreen({super.key, required this.listingId});

  @override
  State<RentalDetailScreen> createState() => _RentalDetailScreenState();
}

class _RentalDetailScreenState extends State<RentalDetailScreen> {
  int _tabIndex = 0;

  // Mock rental as completed for demo
  static const bool _isCompleted = true;

  @override
  Widget build(BuildContext context) {
    final listing = MockData.listings.firstWhere(
      (l) => l.id == widget.listingId,
      orElse: () => MockData.listings.first,
    );

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
            child: Column(
              children: [
                Row(
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
                        'Rental Details',
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
                const SizedBox(height: 16),
                // Segmented control
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _SegTab(
                        label: 'Details',
                        active: _tabIndex == 0,
                        onTap: () => setState(() => _tabIndex = 0),
                      ),
                      _SegTab(
                        label: 'Timeline',
                        active: _tabIndex == 1,
                        onTap: () => setState(() => _tabIndex = 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Content ─────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: _tabIndex == 0
                  ? _buildDetailsTab(context, listing)
                  : _buildTimelineTab(context),
            ),
          ),
        ],
      ),
    );
  }

  // ── Details Tab ─────────────────────────────────────────────────────────────

  Widget _buildDetailsTab(BuildContext context, dynamic listing) {
    return Column(
      children: [
        // ── Order Summary Card ────────────────────────────────────────────
        Container(
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
                            errorBuilder: (ctx, e, st) =>
                                _imgPlaceholder(context),
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
              // Pickup / Return row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup',
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '13 Mar, 9am',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: context.c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Lagos Island studio',
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              color: const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Return by',
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '15 Mar, 6pm',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: context.c.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '2 days left',
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Amber deposit banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFFF59E0B), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 16, color: Color(0xFFB45309)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Deposit of ',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                            TextSpan(
                              text: '₦20,000',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' refunded within 48hrs of undamaged return. Late fee: ',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                            TextSpan(
                              text: '₦8,000/day.',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB45309),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Status & Fees Card ────────────────────────────────────────────
        Container(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isCompleted
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isCompleted ? 'Complete' : 'Requested',
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _isCompleted
                            ? const Color(0xFF065F46)
                            : const Color(0xFFB45309),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _feeRow(context, 'Rental duration', '2 days'),
              _feeRow(context, 'Rental fee (2 × ₦8,000)', '₦16,000'),
              _feeRow(context, 'Delivery Fee', '₦1,300'),
              _feeRow(context, 'Refundable deposit', '₦20,000'),
              const Divider(height: 24),
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
                    '₦302,300',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isCompleted)
                _OutlineButton(
                  label: '↻ Re Order',
                  color: AppColors.primary,
                  onTap: () {},
                )
              else
                _RedOutlineButton(
                  label: '⚠ Cancel Rental Request',
                  onPressed: () {},
                ),
            ],
          ),
        ),
      ],
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

  // ── Timeline Tab ─────────────────────────────────────────────────────────────

  Widget _buildTimelineTab(BuildContext context) {
    final steps = [
      _RentalStep(
        number: 1,
        title: 'Rental confirmed & paid',
        subtitle: '12 Mar · Deposit held',
        isComplete: true,
      ),
      _RentalStep(
        number: 2,
        title: 'Picked up',
        subtitle: '13 Mar · 9:20 AM',
        isComplete: true,
      ),
      _RentalStep(
        number: 3,
        title: 'In use',
        subtitle: 'Return by 15 Mar, 6pm · 2 days left',
        isComplete: false,
      ),
      _RentalStep(
        number: 4,
        title: 'Return & deposit refund',
        subtitle: '₦20,000 refunded within 48hrs',
        isComplete: false,
      ),
    ];

    return Column(
      children: [
        // ── Rental Timeline Card ──────────────────────────────────────────
        Container(
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
                'Rental Timeline',
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
                return _buildStep(context, step, isLast);
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Return Reminder Banner ────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3CD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Return reminder',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFB45309),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Return the stand to Lagos Island studio by 15 Mar at 6pm. Clean and pack in original packaging. Late returns: ₦8,000/day extra.',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: const Color(0xFFB45309),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ── Quick Actions Card ────────────────────────────────────────────
        Container(
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
                'Quick Actions',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              if (_isCompleted) ...[
                GlossyButton(
                  label: '💬 View Message History',
                  height: 50,
                  onPressed: () => context.push(AppRoutes.conversationDetail,
                      extra: {'conversationId': 'conv-01'}),
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: '📞 Call Vendor',
                  color: AppColors.primary,
                  onTap: () {},
                ),
              ] else ...[
                GlossyButton(
                  label: '💬 Message Vendor',
                  height: 50,
                  onPressed: () => context.push(AppRoutes.conversationDetail,
                      extra: {'conversationId': 'conv-01'}),
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: '📞 Call Vendor',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: '📋 Download Payment Receipt',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                _OutlineButton(
                  label: '⚠ Raise a Dispute',
                  color: AppColors.error,
                  onTap: () => context.push(AppRoutes.raiseDispute),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, _RentalStep step, bool isLast) {
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

  Widget _imgPlaceholder(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.chair_outlined, color: AppColors.primary, size: 28),
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
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? context.c.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.primary : context.c.textHint,
            ),
          ),
        ),
      ),
    );
  }
}

class _RentalStep {
  final int number;
  final String title;
  final String subtitle;
  final bool isComplete;

  const _RentalStep({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.isComplete,
  });
}
