import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

const List<String> _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.eventId,
    required this.vendorName,
    required this.eventDate,
  });

  final String eventId;
  final String vendorName;
  final DateTime eventDate;

  String get _dateStr =>
      '${_monthNames[eventDate.month - 1]} ${eventDate.day}, ${eventDate.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              Center(
                child: Image.asset(
                  'assets/images/success_3d.png',
                  width: 160,
                  errorBuilder: (_, __, ___) => Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "It's Officially a ",
                      style: GoogleFonts.urbanist(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: context.c.textPrimary,
                      ),
                    ),
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Your booking is locked in. We've notified the vendor\nand your deposits have been securely processed.",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(
                      label: 'Event ID',
                      value:
                          '#PN-${eventId.substring(0, eventId.length >= 5 ? 5 : eventId.length).toUpperCase()}',
                    ),
                    Divider(height: 20, color: context.c.divider),
                    _DetailRow(label: 'Vendor(s)', value: vendorName),
                    Divider(height: 20, color: context.c.divider),
                    _DetailRow(label: 'Date', value: _dateStr),
                  ],
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              GlossyButton(
                label: 'Go to My Events',
                onPressed: () => context.go(AppRoutes.events),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Download Invoice',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.c.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
          ),
        ),
      ],
    );
  }
}
