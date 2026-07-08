import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class CheckoutScreen extends StatefulWidget {
  final String listingId;
  final String eventId;

  const CheckoutScreen({
    super.key,
    required this.listingId,
    required this.eventId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isDelivery = true;
  bool _sameLocation = true;
  final _instructionsCtrl = TextEditingController();

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
  }

  @override
  void dispose() {
    _instructionsCtrl.dispose();
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
    if (listing.basePrice != null) {
      return '₦ ${_fmt(listing.basePrice!)}';
    }
    if (listing.packages.isNotEmpty) {
      return '₦ ${_fmt(listing.packages.first.price)}';
    }
    return 'Price on request';
  }

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
          'Checkout',
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

                // ── Your Item ────────────────────────────────────────────────
                _sectionLabel(context, 'Your Item'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(14),
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
                                  color: ctx.c.primaryLight,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: context.c.primaryLight,
                                child: const Icon(
                                  Icons.storefront_outlined,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: context.c.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.starColor,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  listing.vendor?.ratingAvg
                                          .toStringAsFixed(1) ??
                                      '4.7',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.c.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: context.c.primaryLight,
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
                  // Your Location card
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
                        // Address row
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
                        // Same event location toggle
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
                        // Another address dashed row
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
                  const SizedBox(height: 16),

                  // Delivery instructions label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Delivery instructions ',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.c.textPrimary,
                          ),
                        ),
                        Text(
                          '(optional)',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.c.border),
                    ),
                    child: TextField(
                      controller: _instructionsCtrl,
                      maxLines: 4,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: context.c.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'e.g Call me when you get to the gate',
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textHint,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Delivery estimate banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.c.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                              children: [
                                const TextSpan(text: 'Estimated delivery: '),
                                TextSpan(
                                  text: '3–5 business days',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const TextSpan(
                                    text: ' from order confirmation'),
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
                  // Static map tile
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
                      _summaryRow(context, 'Platform Fee', '₦ 2,300'),
                      if (_isDelivery) ...[
                        const SizedBox(height: 8),
                        _summaryRow(
                          context,
                          'Delivery (Lagos Island → Lekki)',
                          '₦ 5,000',
                        ),
                      ],
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      _summaryRow(context, 'Sub-total', '₦ 307,300'),
                      const SizedBox(height: 8),
                      _summaryRow(context, 'Total', '₦ 302,300', isBold: true),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // ── Pinned bottom button ─────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: context.c.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlossyButton(
                    label: 'Proceed to Payment',
                    onPressed: () {
                      context.push(
                        AppRoutes.processPayment,
                        extra: {
                          'vendorName':
                              listing.vendor?.businessName ?? 'Vendor',
                          'amount': listing.basePrice ?? 0.0,
                        },
                      );
                    },
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
