import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_booking_service.dart';
import '../../../core/mock/mock_quote_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/quote_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  final _bookingService = MockBookingService();
  final _quoteService = MockQuoteService();
  BookingModel? _booking;
  QuoteModel? _quote;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final booking = await _bookingService.getBooking(widget.bookingId);
    QuoteModel? quote;
    if (booking != null) {
      quote = await _quoteService.getQuoteForBooking(booking.id);
    }
    setState(() {
      _booking = booking;
      _quote = quote;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_booking == null) {
      return Scaffold(appBar: AppBar(), body: const EmptyState(icon: Icons.calendar_today_outlined, title: 'Booking not found'));
    }

    final booking = _booking!;
    final steps = ['Pending', 'Confirmed', 'Active', 'Completed'];
    final currentStep = steps.indexWhere((s) => s.toLowerCase() == booking.status.toLowerCase());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress', style: AppTextStyles.label),
                  const SizedBox(height: 16),
                  Row(
                    children: steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = entry.value;
                      final isCompleted = i <= currentStep;
                      final isLast = i == steps.length - 1;
                      return Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isCompleted ? AppColors.primary : AppColors.divider,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                                      size: 14,
                                      color: isCompleted ? Colors.white : AppColors.textHint,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step,
                                    style: AppTextStyles.caption.copyWith(
                                      color: isCompleted ? AppColors.primary : AppColors.textHint,
                                      fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  height: 2,
                                  color: i < currentStep ? AppColors.primary : AppColors.border,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Event details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event Details', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  _DetailRow(icon: Icons.calendar_today_outlined, label: 'Date', value: Formatters.date(booking.eventDate)),
                  if (booking.eventLocation != null)
                    _DetailRow(icon: Icons.location_on_outlined, label: 'Location', value: booking.eventLocation!),
                  if (booking.requirements != null)
                    _DetailRow(icon: Icons.notes_rounded, label: 'Requirements', value: booking.requirements!),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Vendor card
            GestureDetector(
              onTap: () {
                if (booking.vendorId.isNotEmpty) {
                  context.push(AppRoutes.vendorProfilePath(booking.vendorId));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    AppNetworkImage(
                      url: booking.vendor?.coverUrl,
                      width: 60,
                      height: 60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booking.vendor?.businessName ?? 'Vendor', style: AppTextStyles.label),
                          if (booking.vendor?.location != null)
                            Text(booking.vendor!.location!, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Quote section
            if (_quote != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Quote', style: AppTextStyles.label),
                        const Spacer(),
                        StatusChip(status: _quote!.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.currency(_quote!.amount),
                      style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    GlossyButton(
                      label: 'View Quote',
                      onPressed: () => context.push(AppRoutes.quoteDetailPath(_quote!.id)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Action buttons
            if (booking.status == 'pending')
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: const BorderSide(color: AppColors.error)),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Cancel Booking?'),
                      content: const Text('Are you sure you want to cancel this booking?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Yes, Cancel'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await _bookingService.cancelBooking(booking.id);
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    context.pop();
                  }
                },
                child: const Text('Cancel Booking'),
              ),
            if (booking.status == 'confirmed' && _quote != null)
              GlossyButton(
                label: 'Proceed to Payment',
                onPressed: () {},
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                Text(value, style: AppTextStyles.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
