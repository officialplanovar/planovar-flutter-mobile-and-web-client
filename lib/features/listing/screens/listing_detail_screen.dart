import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/listing_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../shared/widgets/glass_circle_button.dart';
import '../../../shared/widgets/glossy_button.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;
  const ListingDetailScreen({super.key, required this.listingId});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  bool _descExpanded = false;
  bool _isFavourite = false;
  bool _policyOverlayVisible = false;
  int _heroIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  ListingModel? _listing;

  /// Non-null once loaded; build() shows a loader until then.
  ListingModel get listing => _listing!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Live listing from the API; falls back to mock data for demo ids.
    ListingModel? loaded;
    try {
      loaded = await ListingService().getListing(widget.listingId);
    } catch (_) {}
    loaded ??= MockData.listings
            .where((l) => l.id == widget.listingId)
            .firstOrNull ??
        (MockData.listings.isNotEmpty ? MockData.listings.first : null);
    if (!mounted || loaded == null) return;
    setState(() {
      _listing = loaded;
      if (loaded!.sizes.isNotEmpty) _selectedSize = loaded.sizes.first;
      if (loaded.colors.isNotEmpty) _selectedColor = loaded.colors.first;
    });
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

  bool get _isProduct => listing.pricingType == 'fixed';

  String get _servicePriceRange {
    if (listing.packages.isNotEmpty) {
      final prices = listing.packages.map((p) => p.price).toList()..sort();
      String f(double n) => '₦ ${_fmt(n)}';
      return prices.length == 1 ? f(prices.first) : '${f(prices.first)} - ${f(prices.last)}';
    }
    return 'Get Quote';
  }

  void _showAddToEventSheet() {
    showAddToEventSheet(
      context,
      listing: listing,
      onConfirm: (eventIds) {
        final eventId = eventIds.first;
        if (listing.isRentable) {
          context.push(AppRoutes.rentProduct,
              extra: {'listingId': listing.id, 'eventId': eventId});
        } else if (_isProduct) {
          context.push(AppRoutes.checkout,
              extra: {'listingId': listing.id, 'eventId': eventId});
        } else {
          context.push(AppRoutes.serviceDetails,
              extra: {'listingId': listing.id, 'eventId': eventId});
        }
      },
    );
  }

  Color _hexColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_listing == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero image ──────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: screenH * 0.40,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Center(
                    child: GlassCircleButton(
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GlassCircleButton(
                        child: Icon(Icons.share_outlined,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isFavourite = !_isFavourite),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GlassCircleButton(
                        child: Icon(
                          _isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color:
                              _isFavourite ? Colors.redAccent : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: listing.media.isNotEmpty
                      ? Image.network(
                          listing.media[_heroIndex],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primaryLight,
                            child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.primary,
                                size: 48),
                          ),
                        )
                      : Container(color: AppColors.primaryLight),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Thumbnail strip (products only) ─────────────────────
                    if (_isProduct && listing.media.length > 1)
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: List.generate(
                            min(listing.media.length, 4),
                            (i) => GestureDetector(
                              onTap: () => setState(() => _heroIndex = i),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _heroIndex == i
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9),
                                  child: Image.network(
                                    listing.media[i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                        color: AppColors.primaryLight),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // ── Service header ─────────────────────────────────────
                    if (!_isProduct) ...[
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    listing.title,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.starColor, size: 18),
                                const SizedBox(width: 3),
                                Text(
                                  (listing.vendor?.ratingAvg ?? 4.7)
                                      .toStringAsFixed(1),
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _servicePriceRange,
                              style: GoogleFonts.urbanist(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Description',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              listing.description ?? '',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: const Color(0xFF6B7280),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Product header ─────────────────────────────────────
                    if (_isProduct)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (listing.reviewCount > 0) ...[
                              Row(
                                children: [
                                  ...List.generate(5, (i) {
                                    final avg =
                                        listing.vendor?.ratingAvg ?? 4.5;
                                    return Icon(
                                      i < avg.floor()
                                          ? Icons.star_rounded
                                          : (i < avg
                                              ? Icons.star_half_rounded
                                              : Icons.star_rounded),
                                      color: i < avg
                                          ? AppColors.starColor
                                          : const Color(0xFFD1D5DB),
                                      size: 18,
                                    );
                                  }),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${listing.reviewCount}) Reviews',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              listing.title,
                              style: GoogleFonts.urbanist(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => setState(
                                  () => _descExpanded = !_descExpanded),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listing.description ?? '',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: const Color(0xFF6B7280),
                                      height: 1.6,
                                    ),
                                    maxLines: _descExpanded ? null : 3,
                                    overflow: _descExpanded
                                        ? null
                                        : TextOverflow.ellipsis,
                                  ),
                                  if (listing.description != null &&
                                      listing.description!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _descExpanded
                                          ? 'Read less'
                                          : 'Read more',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── Quantity ────────────────────────────────────────────
                    if (_isProduct) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'Quantity',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: const Color(0xFFE5E7EB)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _quantity,
                                  items: List.generate(
                                    10,
                                    (i) => DropdownMenuItem(
                                      value: i + 1,
                                      child: Text(
                                        '${i + 1}',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  onChanged: (v) =>
                                      setState(() => _quantity = v!),
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Sizes ───────────────────────────────────────────────
                    if (_isProduct && listing.sizes.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Sizes',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: listing.sizes.map((s) {
                            final selected = _selectedSize == s;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedSize = s),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 9),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : const Color(0xFFE5E7EB),
                                  ),
                                ),
                                child: Text(
                                  s,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF374151),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // ── Colors ──────────────────────────────────────────────
                    if (_isProduct && listing.colors.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Color',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: listing.colors.map((hex) {
                            final selected = _selectedColor == hex;
                            final color = _hexColor(hex);
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = hex),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: selected
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2.5,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],

                    // ── Cancellation policy (quote listings) ────────────────
                    if (!_isProduct) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  'Cancellation Policy:',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'Moderate',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => setState(() =>
                                      _policyOverlayVisible =
                                          !_policyOverlayVisible),
                                  child: const Icon(
                                      Icons.info_outline_rounded,
                                      color: AppColors.primary,
                                      size: 16),
                                ),
                              ],
                            ),
                            if (_policyOverlayVisible) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Moderate Cancellation Policy',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    _PolicyLine(
                                        '100% refund if cancelled 7+ days before the event.'),
                                    _PolicyLine(
                                        '50% refund if cancelled 3–6 days before the event.'),
                                    _PolicyLine(
                                        'No refund within 48 hours of the event.'),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Minimum Service Duration:',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '4 hours',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Vendor Details ──────────────────────────────────────
                    if (_isProduct && listing.vendor != null) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Vendor Details',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () => context.push(
                              AppRoutes.vendorProfilePath(listing.vendorId)),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(24),
                                      child: listing.vendor!.coverUrl != null
                                          ? Image.network(
                                              listing.vendor!.coverUrl!,
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      _vendorPlaceholder(),
                                            )
                                          : _vendorPlaceholder(),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listing.vendor!.businessName,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  const Color(0xFF1A1A2E),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded,
                                                  color: AppColors.starColor,
                                                  size: 14),
                                              const SizedBox(width: 3),
                                              Text(
                                                listing.vendor!.ratingAvg
                                                    .toStringAsFixed(1),
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                      0xFF1A1A2E),
                                                ),
                                              ),
                                              Text(
                                                ' (${listing.vendor!.reviewCount})',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: const Color(
                                                      0xFF6B7280),
                                                ),
                                              ),
                                              if (listing
                                                  .vendor!.isVerified) ...[
                                                const SizedBox(width: 8),
                                                const Icon(
                                                    Icons.verified_rounded,
                                                    color: AppColors.primary,
                                                    size: 14),
                                                const SizedBox(width: 3),
                                                Text(
                                                  'Verified',
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ],
                                              if (listing.vendor!.location !=
                                                  null) ...[
                                                const SizedBox(width: 8),
                                                const Icon(
                                                    Icons.location_on_rounded,
                                                    color: Color(0xFF6B7280),
                                                    size: 13),
                                                const SizedBox(width: 2),
                                                Expanded(
                                                  child: Text(
                                                    listing.vendor!.location!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xFF6B7280),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 44,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xFFE5E7EB)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.chat_bubble_outline_rounded,
                                            color: AppColors.primary,
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Message Vendor',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF374151),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),

          // ── Pinned CTA ──────────────────────────────────────────────────────
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
                    label: listing.isRentable
                        ? 'Rent for your Event'
                        : _isProduct
                            ? '+ Add to Event'
                            : 'Add to Event',
                    onPressed: _showAddToEventSheet,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorPlaceholder() => Container(
        width: 48,
        height: 48,
        color: AppColors.primaryLight,
        child: const Icon(Icons.store_rounded,
            color: AppColors.primary, size: 24),
      );
}

class _PolicyLine extends StatelessWidget {
  final String text;
  const _PolicyLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: CircleAvatar(radius: 2.5, backgroundColor: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: const Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
