import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/quote_service.dart';
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
import '../../../l10n/app_localizations.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  final _bookingService = BookingService();
  final _quoteService = QuoteService();
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
    final t = AppLocalizations.of(context);
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_booking == null) {
      return Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.calendar_today_outlined, title: t.bookingNotFound));
    }

    final booking = _booking!;
    final steps = ['Pending', 'Confirmed', 'Active', 'Completed'];
    final stepLabels = [t.statusPending, t.confirmedBanner, t.statusActive, t.completedLabel];
    final currentStep = steps.indexWhere((s) => s.toLowerCase() == booking.status.toLowerCase());

    return Scaffold(
      appBar: AppBar(
        title: Text(t.bookingDetails),
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
                color: context.c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.progress, style: AppTextStyles.label(context)),
                  const SizedBox(height: 16),
                  Row(
                    children: steps.asMap().entries.map((entry) {
                      final i = entry.key;
                      final step = stepLabels[i];
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
                                      color: isCompleted ? AppColors.primary : context.c.divider,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                                      size: 14,
                                      color: isCompleted ? Colors.white : context.c.textHint,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    step,
                                    style: AppTextStyles.caption(context).copyWith(
                                      color: isCompleted ? AppColors.primary : context.c.textHint,
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
                                  color: i < currentStep ? AppColors.primary : context.c.border,
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
                color: context.c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.eventDetailsHeading, style: AppTextStyles.label(context)),
                  const SizedBox(height: 12),
                  _DetailRow(icon: Icons.calendar_today_outlined, label: t.dateLabel, value: Formatters.date(booking.eventDate)),
                  if (booking.eventLocation != null)
                    _DetailRow(icon: Icons.location_on_outlined, label: t.locationTitle, value: booking.eventLocation!),
                  if (booking.requirements != null)
                    _DetailRow(icon: Icons.notes_rounded, label: t.requirements, value: booking.requirements!),
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
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.c.border),
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
                          Text(booking.vendor?.businessName ?? t.vendorLabel, style: AppTextStyles.label(context)),
                          if (booking.vendor?.location != null)
                            Text(booking.vendor!.location!, style: AppTextStyles.caption(context)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: context.c.textSecondary),
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
                  color: context.c.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.c.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(t.quoteLabel, style: AppTextStyles.label(context)),
                        const Spacer(),
                        StatusChip(status: _quote!.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.currency(_quote!.amount),
                      style: AppTextStyles.heading4(context).copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    GlossyButton(
                      label: t.viewQuote,
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
                      title: Text(t.cancelBookingTitle),
                      content: Text(t.cancelBookingBody),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.noLabel)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(t.yesCancel),
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
                child: Text(t.cancelBooking),
              ),
            if (booking.status == 'confirmed') ...[
              // Subscription-only model: payment is arranged off-platform.
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t.paymentArrangedNotice,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF92400E), height: 1.5),
                ),
              ),
            ],
            if (booking.status == 'completed')
              GlossyButton(
                label: t.leaveReviewBtn,
                onPressed: () => context.push(
                  AppRoutes.leaveReview,
                  extra: {
                    'bookingId': booking.id,
                    'vendorName': booking.vendor?.businessName ?? t.vendorLabel,
                  },
                ),
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
          Icon(icon, size: 16, color: context.c.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption(context)),
                Text(value, style: AppTextStyles.body2(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
