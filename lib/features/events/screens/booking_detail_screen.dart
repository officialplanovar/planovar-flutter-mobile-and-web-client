import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

class EventBookingDetailScreen extends StatefulWidget {
  final String vendorName;
  final String bookingStatus; // 'awaiting' | 'quote_sent' | 'completed'

  const EventBookingDetailScreen({
    super.key,
    required this.vendorName,
    required this.bookingStatus,
  });

  @override
  State<EventBookingDetailScreen> createState() =>
      _EventBookingDetailScreenState();
}

class _EventBookingDetailScreenState extends State<EventBookingDetailScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.primaryLight,
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
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.vendorName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Segmented control ──────────────────────────────────────
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _tabIndex == 0
                  ? _buildDetailsTab()
                  : _buildTimelineTab(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Details Tab ────────────────────────────────────────────────────────────

  Widget _buildDetailsTab() {
    return Column(
      children: [
        // ── Service card ──────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
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
              // Vendor info row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, st) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.store,
                            color: AppColors.primary, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wedding Cake',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.vendorName,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 14, color: AppColors.starColor),
                            const SizedBox(width: 4),
                            Text(
                              '4.9 (89 reviews)',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Detail rows
              _detailRow(Icons.work_outline_rounded, 'Service Type',
                  'Wedding Decoration'),
              _detailRow(Icons.add_circle_outline_rounded, 'Ad ons', '—'),
              _detailRow(Icons.location_on_outlined, 'Location',
                  'Festac, Lokogoma Abuja'),
              _detailRow(Icons.group_outlined, 'Guest Size', '140'),
              _detailRow(Icons.calendar_today_rounded, 'Date and Time',
                  'Monday, 21st May, 2026'),
              _detailRow(Icons.timer_outlined, 'Duration', '2 Hours'),
              _detailRow(
                Icons.more_horiz_rounded,
                'Additional Information',
                'Please use butter for the frosting instead of artificial cream',
              ),
              const SizedBox(height: 16),
              // Status banner
              _buildStatusBanner(),
              const SizedBox(height: 16),
              // Bottom button
              _buildBottomButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    switch (widget.bookingStatus) {
      case 'quote_sent':
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF10B981)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: Color(0xFF065F46)),
              const SizedBox(width: 8),
              Text(
                'Quote Sent by Vendor',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF065F46),
                ),
              ),
            ],
          ),
        );
      case 'completed':
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF10B981)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded,
                  size: 16, color: Color(0xFF065F46)),
              const SizedBox(width: 8),
              Text(
                'Booking Completed',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF065F46),
                ),
              ),
            ],
          ),
        );
      default: // awaiting
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF59E0B)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: Color(0xFFD97706)),
              const SizedBox(width: 8),
              Text(
                'Awaiting Quote from vendor',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD97706),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildBottomButton() {
    switch (widget.bookingStatus) {
      case 'quote_sent':
        return GlossyButton(
          label: 'View Quote',
          height: 50,
          onPressed: () => context.push(AppRoutes.conversationDetail,
              extra: {'conversationId': 'conv-01'}),
        );
      case 'completed':
        return GlossyButton(
          label: 'View Conversation History',
          height: 50,
          onPressed: () => context.push(AppRoutes.conversationDetail,
              extra: {'conversationId': 'conv-01'}),
        );
      default: // awaiting
        return Opacity(
          opacity: 0.4,
          child: GlossyButton(
            label: 'View Quote',
            height: 50,
            onPressed: null,
          ),
        );
    }
  }

  // ── Timeline Tab ───────────────────────────────────────────────────────────

  Widget _buildTimelineTab() {
    final steps = [
      _TimelineStep(number: 1, title: 'Quote accepted', date: '14 Feb 2026', status: 'Complete'),
      _TimelineStep(number: 2, title: 'Payment confirmed', date: '14 Feb 2026', status: 'Complete'),
      _TimelineStep(number: 3, title: 'Event day', date: '14 Feb 2026', status: 'Pending'),
      _TimelineStep(number: 4, title: 'Review', date: '14 Feb 2026', status: 'Pending'),
    ];

    final completedSteps = steps.where((s) => s.status == 'Complete').length;

    return Column(
      children: [
        // Timeline card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),
              ...steps.asMap().entries.map((entry) {
                final i = entry.key;
                final step = entry.value;
                final isLast = i == steps.length - 1;
                return _buildTimelineStep(step, isLast);
              }),
            ],
          ),
        ),
        // Quick actions card
        if (widget.bookingStatus != 'awaiting') ...[
          const SizedBox(height: 16),
          _buildQuickActions(completedSteps),
        ],
      ],
    );
  }

  Widget _buildTimelineStep(_TimelineStep step, bool isLast) {
    final isComplete = step.status == 'Complete';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isComplete ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: isComplete
                    ? null
                    : Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  '${step.number}',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isComplete ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 44,
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: CustomPaint(
                  painter: _DashedLinePainter(color: AppColors.primary),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 36, top: 4),
            child: Row(
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
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.date,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    step.status,
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isComplete
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

  Widget _buildQuickActions(int completedSteps) {
    // All done (step 4 complete)
    if (completedSteps >= 4) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          // Event done → show review
          if (completedSteps >= 3) ...[
            GlossyButton(
              label: '⭐ Leave a Review',
              height: 50,
              onPressed: () => context.push(AppRoutes.leaveReview,
                  extra: {'vendorName': widget.vendorName}),
            ),
          ] else ...[
            // Steps 1+2 done (confirmed)
            GlossyButton(
              label: '💬 Message Vendor',
              height: 50,
              onPressed: () => context.push(AppRoutes.conversationDetail,
                  extra: {'conversationId': 'conv-01'}),
            ),
            const SizedBox(height: 10),
            _outlineButton(
              label: '📞 Call Vendor',
              color: AppColors.primary,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _outlineButton(
              label: '📋 Download Booking Receipt',
              color: AppColors.primary,
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _outlineButton(
              label: '⚠ Raise a Dispute',
              color: AppColors.error,
              onTap: () => context.push(AppRoutes.raiseDispute),
            ),
          ],
        ],
      ),
    );
  }

  Widget _outlineButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
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

// ─── Helper classes ────────────────────────────────────────────────────────────

class _TimelineStep {
  final int number;
  final String title;
  final String date;
  final String status;

  const _TimelineStep({
    required this.number,
    required this.title,
    required this.date,
    required this.status,
  });
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Seg Tab ──────────────────────────────────────────────────────────────────

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.primary : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}
