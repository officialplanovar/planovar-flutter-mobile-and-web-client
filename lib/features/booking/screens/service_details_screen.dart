import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String listingId;
  final String eventId;

  const ServiceDetailsScreen({
    super.key,
    required this.listingId,
    required this.eventId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  final _dateCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _startTimeCtrl = TextEditingController();
  final _endTimeCtrl = TextEditingController();
  bool _sameDate = true;
  bool _sameTime = true;

  late final ListingModel listing;
  late final EventModel event;

  @override
  void initState() {
    super.initState();
    listing = MockData.listings.firstWhere(
      (l) => l.id == widget.listingId,
      orElse: () => MockData.listings.first,
    );
    event = MockData.events.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => MockData.events.first,
    );
    // Pre-fill with event values since toggles start as "on"
    _dateCtrl.text = _formatEventDate(event.date);
    _startTimeCtrl.text = _formatTime(TimeOfDay.fromDateTime(event.date));
    if (event.durationHours != null) {
      final endDt = event.date.add(Duration(hours: event.durationHours!));
      _endTimeCtrl.text = _formatTime(TimeOfDay.fromDateTime(endDt));
    }
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    _notesCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    super.dispose();
  }

  static String _fmt(double n) {
    final s = n.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  String get _priceDisplay {
    if (listing.pricingType == 'fixed' && listing.basePrice != null) {
      return '₦ ${_fmt(listing.basePrice!)}';
    } else if (listing.packages.isNotEmpty) {
      final prices = listing.packages.map((p) => p.price);
      final minP = prices.reduce(min);
      final maxP = prices.reduce(max);
      return '₦ ${_fmt(minP)} - ₦ ${_fmt(maxP)}';
    }
    return 'Price on request';
  }

  String _formatEventDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickDate() async {
    if (_sameDate) return;
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (d != null) setState(() => _dateCtrl.text = _formatEventDate(d));
  }

  Future<void> _pickTime({required bool isStart}) async {
    if (_sameTime) return;
    final initial = isStart
        ? TimeOfDay.fromDateTime(event.date)
        : TimeOfDay.now();
    final t = await showTimePicker(context: context, initialTime: initial);
    if (t != null) {
      setState(() {
        if (isStart) {
          _startTimeCtrl.text = _formatTime(t);
        } else {
          _endTimeCtrl.text = _formatTime(t);
        }
      });
    }
  }

  void _onSameDateChanged(bool v) {
    setState(() {
      _sameDate = v;
      _dateCtrl.text = v ? _formatEventDate(event.date) : '';
    });
  }

  void _onSameTimeChanged(bool v) {
    setState(() {
      _sameTime = v;
      if (v) {
        _startTimeCtrl.text = _formatTime(TimeOfDay.fromDateTime(event.date));
        if (event.durationHours != null) {
          final endDt = event.date.add(Duration(hours: event.durationHours!));
          _endTimeCtrl.text = _formatTime(TimeOfDay.fromDateTime(endDt));
        } else {
          _endTimeCtrl.text = '';
        }
      } else {
        _startTimeCtrl.text = '';
        _endTimeCtrl.text = '';
      }
    });
  }

  void _proceed() {
    context.push(AppRoutes.confirmQuote, extra: {
      'listingId': widget.listingId,
      'eventId': widget.eventId,
      'preferredDate': _dateCtrl.text,
      'notes': _notesCtrl.text,
    });
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _inputContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Service Details',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _sectionLabel('Event Details'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoChip(
                            icon: Icons.calendar_today_rounded,
                            label: _formatEventDate(event.date),
                          ),
                          if (event.durationHours != null)
                            _InfoChip(
                              icon: Icons.location_on_outlined,
                              label: '${event.durationHours} hours',
                            ),
                          _InfoChip(
                            icon: Icons.calendar_today_rounded,
                            label: _formatEventDate(event.date),
                          ),
                          if (event.guestCount != null)
                            _InfoChip(
                              icon: Icons.group_outlined,
                              label: '${event.guestCount} guests',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sectionLabel('Service Details'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: listing.media.isNotEmpty
                            ? Image.network(
                                listing.media.first,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.primaryLight,
                                  child: const Icon(Icons.image_not_supported_outlined,
                                      color: AppColors.primary, size: 24),
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: AppColors.primaryLight,
                                child: const Icon(Icons.storefront_outlined,
                                    color: AppColors.primary, size: 24),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    listing.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.starColor, size: 13),
                                const SizedBox(width: 2),
                                Text(
                                  listing.vendor?.ratingAvg.toStringAsFixed(1) ?? '4.7',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _priceDisplay,
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Preferred Date',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _inputContainer(
                  child: TextField(
                    controller: _dateCtrl,
                    readOnly: true,
                    enabled: !_sameDate,
                    onTap: _pickDate,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: const Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Select date',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: Icon(
                        Icons.calendar_month_outlined,
                        color: _sameDate
                            ? const Color(0xFFD1D5DB)
                            : AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Switch(
                        value: _sameDate,
                        onChanged: _onSameDateChanged,
                        activeTrackColor: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Use same event date',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Preferred Time',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _TimeField(
                        controller: _startTimeCtrl,
                        hint: 'Start time',
                        enabled: !_sameTime,
                        onTap: () => _pickTime(isStart: true),
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '—',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      Expanded(child: _TimeField(
                        controller: _endTimeCtrl,
                        hint: 'End time',
                        enabled: !_sameTime,
                        onTap: () => _pickTime(isStart: false),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Switch(
                        value: _sameTime,
                        onChanged: _onSameTimeChanged,
                        activeTrackColor: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Use same event time',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Additional Information',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _inputContainer(
                  child: TextField(
                    controller: _notesCtrl,
                    maxLines: 4,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: const Color(0xFF1A1A2E),
                    ),
                    decoration: InputDecoration(
                      hintText: 'let the vendor know any other specifics',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
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
                    label: 'Proceed',
                    onPressed: _proceed,
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

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final VoidCallback onTap;

  const _TimeField({
    required this.controller,
    required this.hint,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: TextField(
          controller: controller,
          readOnly: true,
          enabled: false,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 13,
              color: const Color(0xFF9CA3AF),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            suffixIcon: Icon(
              Icons.access_time_outlined,
              color: enabled ? AppColors.primary : const Color(0xFFD1D5DB),
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
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
}
