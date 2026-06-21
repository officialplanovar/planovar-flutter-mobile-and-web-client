import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/review_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

class LeaveReviewScreen extends StatefulWidget {
  final String vendorName;

  /// When set, the review is submitted to the API against this booking.
  final String? bookingId;

  const LeaveReviewScreen({super.key, required this.vendorName, this.bookingId});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  int _rating = 0;
  final _reviewCtrl = TextEditingController();
  bool _sending = false;

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tap the stars to rate your experience')),
      );
      return;
    }
    final bookingId = widget.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      // Demo flow (no real booking attached).
      context.pop();
      return;
    }
    setState(() => _sending = true);
    try {
      await ReviewService().submit(
        bookingId: bookingId,
        rating: _rating,
        body: _reviewCtrl.text.trim().isEmpty
            ? 'Rated $_rating stars'
            : _reviewCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted — thank you! ⭐')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.primaryLight,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 20,
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
                      child: Column(
                        children: [
                          Text(
                            'Review',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Let us know how your booking went',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ],
            ),
          ),
          // ── Body ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Vendor image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, st) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.store,
                              color: AppColors.primary, size: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Vendor name
                  Center(
                    child: Text(
                      widget.vendorName,
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Star rating
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final filled = i < _rating;
                        return GestureDetector(
                          onTap: () => setState(() => _rating = i + 1),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              filled ? Icons.star_rounded : Icons.star_outline_rounded,
                              size: 40,
                              color: filled
                                  ? AppColors.starColor
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Feedback label
                  Text(
                    'Leave a Detailed feedback',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Feedback text field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _reviewCtrl,
                      minLines: 5,
                      maxLines: 7,
                      style: GoogleFonts.urbanist(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Let us know how your experience was',
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: const Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Send review button
                  GlossyButton(
                    label: _sending ? 'Sending…' : 'Send Review',
                    height: 52,
                    onPressed: _sending ? null : _submit,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
