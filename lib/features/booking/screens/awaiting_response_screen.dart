import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/glossy_button.dart';

class AwaitingResponseScreen extends StatelessWidget {
  const AwaitingResponseScreen({
    super.key,
    required this.vendorName,
    this.bookingRef = '#PN-49204',
    this.date = 'TBD',
  });

  final String vendorName;
  final String bookingRef;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E),
              size: 18,
            ),
          ),
        ),
        title: Text(
          'Awaiting Response',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            Image.asset(
              'assets/images/clock_3d.png',
              width: 200,
            ),
            const SizedBox(height: 32),
            Text(
              'Awaiting Response',
              style: GoogleFonts.urbanist(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                  height: 1.6,
                ),
                children: [
                  const TextSpan(
                      text: 'You have successfully requested a quote from\n'),
                  TextSpan(
                    text: vendorName,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                      height: 1.6,
                    ),
                  ),
                  const TextSpan(
                      text:
                          ', we would let you know when they respond'),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            GlossyButton(
              label: 'Proceed',
              onPressed: () => context.pushReplacement(
                AppRoutes.bookingConfirmed,
                extra: {
                  'vendorName': vendorName,
                  'bookingRef': bookingRef,
                  'date': date,
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
