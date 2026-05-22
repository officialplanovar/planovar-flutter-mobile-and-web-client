import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class ConfirmQuoteScreen extends StatelessWidget {
  final String listingId;
  final String eventId;
  final String? preferredDate;
  final String? notes;

  const ConfirmQuoteScreen({
    super.key,
    required this.listingId,
    required this.eventId,
    this.preferredDate,
    this.notes,
  });

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _mths = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

  void _submit(BuildContext context, ListingModel listing) {
    final now = DateTime.now();
    final ref = '#PN-${now.millisecondsSinceEpoch.toString().substring(7)}';
    final event = MockData.events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => MockData.events.first,
    );
    final dateLabel = '${event.date.day} ${_mths[event.date.month - 1]}, ${event.date.year}';
    context.push(AppRoutes.awaitingResponse, extra: {
      'vendorName': listing.vendor?.businessName ?? 'the vendor',
      'bookingRef': ref,
      'date': dateLabel,
    });
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final listing = MockData.listings.firstWhere(
      (l) => l.id == listingId,
      orElse: () => MockData.listings.first,
    );
    final event = MockData.events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => MockData.events.first,
    );

    final dateLabel = preferredDate ??
        '${event.date.day} ${_months[event.date.month - 1]}, ${event.date.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E),
              size: 18,
            ),
          ),
        ),
        title: Text(
          'Confirm & Request Quote',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Event Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _chip(Icons.calendar_today_rounded, '14 Mar 2026'),
                          _chip(Icons.access_time_outlined, '3 hours'),
                          _chip(Icons.location_on_outlined, event.location ?? 'TBD'),
                          _chip(Icons.group_outlined, '${event.guestCount ?? 0} guests'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Service Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _detailRow(
                        Icons.work_outline_rounded,
                        'Service',
                        listing.title,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.calendar_today_outlined,
                        'Date and Time',
                        dateLabel,
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.access_time_outlined,
                        'Duration',
                        '${event.durationHours ?? 2} Hours',
                      ),
                      const Divider(height: 24),
                      _detailRow(
                        Icons.more_horiz_rounded,
                        'Additional Information',
                        notes?.isNotEmpty == true
                            ? notes!
                            : 'let the vendor know any other specifics',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlossyButton(
                    label: 'Request Quote',
                    onPressed: () => _submit(context, listing),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
