import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
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
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.c.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.c.textPrimary,
              size: 18,
            ),
          ),
        ),
        title: Text(
          'Awaiting Response',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
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
                color: context.c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textSecondary,
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
                      color: context.c.textPrimary,
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
