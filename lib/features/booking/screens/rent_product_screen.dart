import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class RentProductScreen extends StatefulWidget {
  final String listingId;
  final String eventId;

  const RentProductScreen({
    super.key,
    required this.listingId,
    required this.eventId,
  });

  @override
  State<RentProductScreen> createState() => _RentProductScreenState();
}

class _RentProductScreenState extends State<RentProductScreen> {
  bool _isDelivery = true;
  bool _sameLocation = true;

  DateTime? _startDate;
  DateTime? _endDate;
  late final TextEditingController _startDateCtrl;
  late final TextEditingController _endDateCtrl;

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

    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 2));
    _startDateCtrl =
        TextEditingController(text: _fmtDate(_startDate!));
    _endDateCtrl =
        TextEditingController(text: _fmtDate(_endDate!));
  }

  @override
  void dispose() {
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static String _fmt(double n) {
    final s = n.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd-$mm-${d.year}';
  }

  int get _rentalDays {
    if (_startDate == null || _endDate == null) return 2;
    final diff = _endDate!.difference(_startDate!).inDays;
    return diff < 1 ? 1 : diff;
  }

  double get _perDayRate => listing.perDayRate ?? 8000;
  double get _depositAmount => listing.depositAmount ?? 20000;
  double get _rentalFee => _rentalDays * _perDayRate;
  double get _deliveryFee => 1300;
  double get _chargedNow =>
      _rentalFee + (_isDelivery ? _deliveryFee : 0) + _depositAmount;

  String _formatEventDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  // ── Date picker ────────────────────────────────────────────────────────────

  Future<void> _pickStartDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (d != null) {
      setState(() {
        _startDate = d;
        _startDateCtrl.text = _fmtDate(d);
        // Push end date if it's now before start
        if (_endDate != null && _endDate!.isBefore(d)) {
          _endDate = d.add(const Duration(days: 2));
          _endDateCtrl.text = _fmtDate(_endDate!);
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()).add(const Duration(days: 2)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (d != null) {
      setState(() {
        _endDate = d;
        _endDateCtrl.text = _fmtDate(d);
      });
    }
  }

  // ── Section helpers ────────────────────────────────────────────────────────

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 13,
          color: context.c.textSecondary,
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value,
      {bool isBold = false}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? context.c.textPrimary : context.c.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: isBold ? 18 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: isBold ? AppColors.primary : context.c.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: AppBar(
        backgroundColor: context.c.background,
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
          'Rent a Product',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
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

                // ── Price / Deposit cards ────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Per day rate card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.c.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.c.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.perDayRate != null
                                    ? '₦ ${_fmt(listing.perDayRate!)}'
                                    : '₦ 8,000',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: context.c.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Per day',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: context.c.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Deposit card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.c.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.c.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.depositAmount != null
                                    ? '₦ ${_fmt(listing.depositAmount!)}'
                                    : '₦ 20,000',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: context.c.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Refundable deposit',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: context.c.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Rental period ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Text(
                    'Select Rental period',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Start date
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickStartDate,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.c.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.c.border),
                            ),
                            child: TextField(
                              controller: _startDateCtrl,
                              readOnly: true,
                              enabled: false,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: context.c.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'DD-MM-YYYY',
                                hintStyle: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: context.c.textHint,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                suffixIcon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '—',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: context.c.textSecondary,
                          ),
                        ),
                      ),
                      // End date
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickEndDate,
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.c.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.c.border),
                            ),
                            child: TextField(
                              controller: _endDateCtrl,
                              readOnly: true,
                              enabled: false,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: context.c.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'DD-MM-YYYY',
                                hintStyle: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: context.c.textHint,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                suffixIcon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Event Details ────────────────────────────────────────────
                _sectionLabel(context, 'Event Details'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.c.surface,
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
                          color: context.c.textPrimary,
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
                              icon: Icons.timelapse_outlined,
                              label: '${event.durationHours} hours',
                            ),
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: event.location ?? 'Lagos',
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

                // ── Delivery / Pickup toggle ─────────────────────────────────
                _sectionLabel(context, 'Saved address'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: context.c.surfaceElevated,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _ToggleTab(
                          label: 'Delivery',
                          isSelected: _isDelivery,
                          onTap: () => setState(() => _isDelivery = true),
                        ),
                        _ToggleTab(
                          label: 'Pickup',
                          isSelected: !_isDelivery,
                          onTap: () => setState(() => _isDelivery = false),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Delivery section ─────────────────────────────────────────
                if (_isDelivery) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(14),
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
                            const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ikeja, plot383, Lagos',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.c.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Switch(
                              value: _sameLocation,
                              onChanged: (v) =>
                                  setState(() => _sameLocation = v),
                              activeThumbColor: Colors.white,
                              activeTrackColor: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Use same event location',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: context.c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFD1D5DB),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: context.c.textHint,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '+ Use another address',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: context.c.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Pickup section ───────────────────────────────────────────
                if (!_isDelivery) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://tile.openstreetmap.org/13/4921/3972.png',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: ctx.c.border,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.map_outlined,
                                  color: ctx.c.textHint,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.location_pin,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.c.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ikeja, plot383, Lagos',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // ── Order Summary ────────────────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.c.surface,
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
                        'Order Summary',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _summaryRow(
                        context,
                        'Rental duration',
                        '$_rentalDays ${_rentalDays == 1 ? "day" : "days"}',
                      ),
                      const SizedBox(height: 8),
                      _summaryRow(
                        context,
                        'Rental fee ($_rentalDays × ₦${_fmt(_perDayRate)})',
                        '₦ ${_fmt(_rentalFee)}',
                      ),
                      if (_isDelivery) ...[
                        const SizedBox(height: 8),
                        _summaryRow(
                          context,
                          'Delivery Fee',
                          '₦ ${_fmt(_deliveryFee)}',
                        ),
                      ],
                      const SizedBox(height: 8),
                      _summaryRow(
                        context,
                        'Refundable deposit',
                        '₦ ${_fmt(_depositAmount)}',
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      _summaryRow(
                        context,
                        'Charged now',
                        '₦ ${_fmt(_chargedNow)}',
                        isBold: true,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Deposit refunded within 48hrs of return in good condition',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textHint,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),

          // ── Pinned bottom buttons ────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: context.c.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlossyButton(
                        label: 'Confirm Rental & Pay',
                        onPressed: () {
                          context.push(
                            AppRoutes.processPayment,
                            extra: {
                              'vendorName':
                                  listing.vendor?.businessName ?? 'Vendor',
                              'amount': _chargedNow,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Outlined ask vendor button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: context.c.surface,
                          ),
                          child: Text(
                            'Ask Vendor a Question',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ── Toggle tab widget ──────────────────────────────────────────────────────────
class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : context.c.textHint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Info chip widget ───────────────────────────────────────────────────────────
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
            color: context.c.textSecondary,
          ),
        ),
      ],
    );
  }
}
