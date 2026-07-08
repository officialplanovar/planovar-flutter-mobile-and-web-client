import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final String vendorName;
  final String bookingRef;
  final String date;

  const BookingConfirmedScreen({
    super.key,
    required this.vendorName,
    this.bookingRef = '#PN-49204',
    this.date = 'Oct 24, 2026',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              // 3D-style green checkmark circle
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Color(0xFF66BB6A), Color(0xFF388E3C)],
                    center: Alignment(-0.3, -0.3),
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 72),
              ),
              const SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.urbanist(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: context.c.textPrimary,
                  ),
                  children: [
                    const TextSpan(text: "It's Officially a "),
                    TextSpan(
                      text: 'celebration',
                      style: GoogleFonts.urbanist(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Your booking is locked in. We've notified the vendor and your deposits have been securely processed.",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textSecondary,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                decoration: BoxDecoration(
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.c.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _Row(label: 'Event ID', value: bookingRef),
                    Divider(height: 1, color: context.c.divider),
                    _Row(label: 'Vendor(s)', value: vendorName),
                    Divider(height: 1, color: context.c.divider),
                    _Row(label: 'Date', value: date),
                  ],
                ),
              ),
              const Spacer(),
              GlossyButton(
                label: 'Go to My Events',
                onPressed: () => context.go(AppRoutes.events),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Download Invoice',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
