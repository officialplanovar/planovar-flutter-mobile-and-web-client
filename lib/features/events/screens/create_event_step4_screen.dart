import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/glossy_button.dart';
import 'create_event_step1_screen.dart' show EventStepHeader;

class CreateEventStep4Screen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const CreateEventStep4Screen({super.key, required this.eventData});

  @override
  State<CreateEventStep4Screen> createState() => _CreateEventStep4ScreenState();
}

class _CreateEventStep4ScreenState extends State<CreateEventStep4Screen> {
  int _activeCategory = 0;
  final Set<String> _sourcedVendorIds = {};
  bool _showReview = false;

  List<String> get _categories =>
      (widget.eventData['categories'] as List<dynamic>?)
          ?.cast<String>()
          .toList() ??
      ['Catering', 'Photography', 'Decor'];

  @override
  Widget build(BuildContext context) {
    return _showReview ? _buildReviewScreen() : _buildBrowsingScreen();
  }

  // ─── Vendor Browsing Screen ───────────────────────────────────────────────

  Widget _buildBrowsingScreen() {
    final categories = _categories;
    final vendors = MockData.vendors.take(6).toList();
    final sourced = _sourcedVendorIds.length;
    final total = categories.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          EventStepHeader(
            currentStep: 4,
            onBack: () => context.pop(),
            titlePrefix: 'Event ',
            titleHighlight: 'Categories',
            subtitle: 'Step Four, Select your Vendors',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended vendors for your event',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$sourced of $total Vendors',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categories.length, (i) {
                        final active = _activeCategory == i;
                        return GestureDetector(
                          onTap: () => setState(() => _activeCategory = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              categories[i],
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search bar + filter
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded,
                                  color: Color(0xFF9CA3AF), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Search for items',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: const Color(0xFFD1D5DB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Vendor grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: vendors.length,
                    itemBuilder: (context, i) {
                      final vendor = vendors[i];
                      final isSrc =
                          _sourcedVendorIds.contains(vendor.id);
                      return GestureDetector(
                        onTap: () => _openVendorSheet(vendor),
                        child: _VendorGridCard(
                          vendor: vendor,
                          isSourced: isSrc,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _BrowsingBottomBar(
        hasSourced: _sourcedVendorIds.isNotEmpty,
        onReview: () => setState(() => _showReview = true),
        onSkip: () => context.go(AppRoutes.events),
      ),
    );
  }

  // ─── Sourced Vendors Review Screen ───────────────────────────────────────

  Widget _buildReviewScreen() {
    final categories = _categories;
    final vendors = MockData.vendors.take(categories.length).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          EventStepHeader(
            currentStep: 4,
            onBack: () => setState(() => _showReview = false),
            titlePrefix: 'Event ',
            titleHighlight: 'Categories',
            subtitle: 'Step Four, Select your Vendors',
          ),
          // Category chips — all checked
          Container(
            color: const Color(0xFFF8F5FF),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (cat) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.check,
                                size: 12, color: AppColors.primary),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All ${categories.length} Vendors sourced for all categories',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    vendors.length,
                    (i) => _SourcedVendorCard(
                      vendor: vendors[i],
                      category: categories[i % categories.length],
                      onRemove: () {},
                      onSwap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: GlossyButton(
              label: 'Create Event',
              onPressed: () => context.go(AppRoutes.events),
            ),
          ),
        ],
      ),
    );
  }

  void _openVendorSheet(VendorModel vendor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _VendorDetailSheet(
        vendor: vendor,
        onAdd: () {
          setState(() => _sourcedVendorIds.add(vendor.id));
        },
      ),
    );
  }
}

// ─── Vendor Grid Card ─────────────────────────────────────────────────────────

class _VendorGridCard extends StatelessWidget {
  final VendorModel vendor;
  final bool isSourced;

  const _VendorGridCard({required this.vendor, required this.isSourced});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isSourced
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: vendor.coverUrl != null
                ? Image.network(
                    vendor.coverUrl!,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => _placeholder(),
                  )
                : _placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.businessName,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.starColor, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      vendor.ratingAvg.toStringAsFixed(1),
                      style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E)),
                    ),
                    Text(
                      ' (${vendor.reviewCount})',
                      style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
                if (isSourced) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Added ✓',
                      style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 110,
        color: AppColors.primaryLight,
        child: const Center(
          child: Icon(Icons.store_rounded,
              color: AppColors.primary, size: 28),
        ),
      );
}

// ─── Browsing Bottom Bar ──────────────────────────────────────────────────────

class _BrowsingBottomBar extends StatelessWidget {
  final bool hasSourced;
  final VoidCallback onReview;
  final VoidCallback onSkip;

  const _BrowsingBottomBar(
      {required this.hasSourced,
      required this.onReview,
      required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSourced) ...[
            GlossyButton(
              label: 'Review Sourced Vendors',
              onPressed: onReview,
            ),
            const SizedBox(height: 14),
          ],
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'Create Event without sourcing',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Vendor Detail Bottom Sheet ───────────────────────────────────────────────

class _VendorDetailSheet extends StatefulWidget {
  final VendorModel vendor;
  final VoidCallback onAdd;

  const _VendorDetailSheet({required this.vendor, required this.onAdd});

  @override
  State<_VendorDetailSheet> createState() => _VendorDetailSheetState();
}

class _VendorDetailSheetState extends State<_VendorDetailSheet> {
  int _tab = 0;
  static const _tabs = [
    'Products to buy',
    'Services to book',
    'Equipment rentals',
  ];

  @override
  Widget build(BuildContext context) {
    final listings = MockData.listings.take(4).toList();
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottom + 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Cancel
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.vendor.businessName,
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating + Verified + Location
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.starColor, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.vendor.ratingAvg.toStringAsFixed(1)} (${widget.vendor.reviewCount})',
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A2E)),
                          ),
                        ],
                      ),
                      if (widget.vendor.isVerified)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded,
                                color: AppColors.primary, size: 14),
                            const SizedBox(width: 3),
                            Text(
                              'Verified',
                              style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Color(0xFF6B7280), size: 13),
                          const SizedBox(width: 3),
                          Text(
                            widget.vendor.location ?? 'Abuja, Nigeria',
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: const Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    widget.vendor.description ??
                        'Award-winning custom cakes for every occasion in Lagos. We bring your vision to life with edible artistry, from classic tiers to sculpted showpieces.',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Info rows
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text:
                        '${widget.vendor.location ?? 'Lagos Island'} · 20km service radius',
                  ),
                  const SizedBox(height: 8),
                  const _InfoRow(
                    icon: Icons.access_time_outlined,
                    text: 'Mon–Sat · 9am–6pm',
                  ),
                  const SizedBox(height: 8),
                  const _InfoRow(
                    icon: Icons.bolt_outlined,
                    text: 'Responds within ~30 mins',
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 16),
                  Text(
                    'Select an option based on your Preference',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Preference tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final active = _tab == i;
                        return GestureDetector(
                          onTap: () => setState(() => _tab = i),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primaryLight
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: active
                                    ? AppColors.primary
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              _tabs[i],
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? AppColors.primary
                                    : const Color(0xFF374151),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Listing items
                  ...listings.map((listing) => GestureDetector(
                        onTap: () => _openServiceDetail(listing),
                        child: _ListingRow(listing: listing),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openServiceDetail(ListingModel listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ServiceDetailSheet(
        listing: listing,
        onAdd: () {
          Navigator.pop(context); // close service detail
          Navigator.pop(context); // close vendor sheet
          widget.onAdd();
        },
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  final ListingModel listing;

  const _ListingRow({required this.listing});

  String get _priceRange {
    if (listing.packages.isNotEmpty) {
      final prices = listing.packages.map((p) => p.price).toList()..sort();
      final min = prices.first;
      final max = prices.last;
      if (min == max) return '₦${_fmt(min)}';
      return '₦${_fmt(min)} – ₦${_fmt(max)}';
    }
    if (listing.basePrice != null) return '₦${_fmt(listing.basePrice!)}';
    return '₦ —';
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final imgUrl =
        listing.media.isNotEmpty ? listing.media[0] : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imgUrl != null
                ? Image.network(
                    imgUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => _imgPlaceholder(),
                  )
                : _imgPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _priceRange,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Color(0xFFD1D5DB)),
        ],
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        width: 60,
        height: 60,
        color: AppColors.primaryLight,
        child: const Icon(Icons.image_rounded,
            color: AppColors.primary, size: 20),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
                fontSize: 13, color: const Color(0xFF374151)),
          ),
        ),
      ],
    );
  }
}

// ─── Service Detail Bottom Sheet ──────────────────────────────────────────────

class _ServiceDetailSheet extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onAdd;

  const _ServiceDetailSheet(
      {required this.listing, required this.onAdd});

  String get _priceRange {
    if (listing.packages.isNotEmpty) {
      final prices = listing.packages.map((p) => p.price).toList()..sort();
      final min = prices.first;
      final max = prices.last;
      if (min == max) return '₦ ${_fmt(min)}';
      return '₦ ${_fmt(min)} - ₦ ${_fmt(max)}';
    }
    if (listing.basePrice != null) return '₦ ${_fmt(listing.basePrice!)}';
    return '₦ —';
  }

  String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) {
      final k = v / 1000;
      return k == k.roundToDouble()
          ? '${k.toInt()},000'
          : '${k.toStringAsFixed(0)},000';
    }
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.fromLTRB(20, 16, 20, bottom + 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: Color(0xFF1A1A2E)),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Service Details',
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Name + rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.starColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            listing.vendor?.ratingAvg
                                    .toStringAsFixed(1) ??
                                '4.7',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Price
                  Text(
                    _priceRange,
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F5FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          listing.description ??
                              'Award-winning custom cakes for every occasion in Lagos. We bring your vision to life with edible artistry, from classic tiers to sculpted showpieces.',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: const Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Details
                  _DetailRow(
                    label: 'Cancellation Policy:',
                    value: 'Moderate',
                    hasInfo: true,
                  ),
                  const Divider(color: Color(0xFFE5E7EB), height: 24),
                  const _DetailRow(
                    label: 'Minimum Service Duration:',
                    value: '4 hours',
                  ),
                  const SizedBox(height: 24),
                  // Add to Event button
                  GlossyButton(
                    label: 'Add to Event',
                    onPressed: onAdd,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool hasInfo;

  const _DetailRow(
      {required this.label,
      required this.value,
      this.hasInfo = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.urbanist(
                fontSize: 13, color: const Color(0xFF6B7280))),
        Row(
          children: [
            Text(value,
                style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E))),
            if (hasInfo) ...[
              const SizedBox(width: 6),
              const Icon(Icons.info_outline_rounded,
                  size: 14, color: AppColors.primary),
            ],
          ],
        ),
      ],
    );
  }
}

// ─── Sourced Vendor Card ──────────────────────────────────────────────────────

class _SourcedVendorCard extends StatelessWidget {
  final VendorModel vendor;
  final String category;
  final VoidCallback onRemove;
  final VoidCallback onSwap;

  const _SourcedVendorCard({
    required this.vendor,
    required this.category,
    required this.onRemove,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: vendor.coverUrl != null
                    ? Image.network(
                        vendor.coverUrl!,
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, st) => _avatar(),
                      )
                    : _avatar(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.businessName,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.starColor, size: 13),
                        const SizedBox(width: 2),
                        Text(
                          vendor.ratingAvg.toStringAsFixed(1),
                          style: GoogleFonts.urbanist(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E)),
                        ),
                        Text(
                          ' (${vendor.reviewCount})',
                          style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: const Color(0xFF6B7280)),
                        ),
                        const SizedBox(width: 6),
                        if (vendor.isVerified) ...[
                          const Icon(Icons.verified_rounded,
                              color: AppColors.primary, size: 13),
                          const SizedBox(width: 2),
                          Text(
                            'Verified',
                            style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary),
                          ),
                        ],
                        const SizedBox(width: 6),
                        const Icon(Icons.location_on_rounded,
                            color: Color(0xFF6B7280), size: 12),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            vendor.location ?? 'Abuja, Nigeria',
                            style: GoogleFonts.urbanist(
                                fontSize: 11,
                                color: const Color(0xFF6B7280)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              _StatusChip(label: 'Quote Sent', icon: Icons.check),
              _StatusChip(label: category, icon: Icons.check),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFEF4444)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete_outline_rounded,
                            color: Color(0xFFEF4444), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Remove Vendor',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: onSwap,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.swap_horiz_rounded,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Swap Vendor',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar() => Container(
        width: 46,
        height: 46,
        color: AppColors.primaryLight,
        child: const Icon(Icons.store_rounded,
            color: AppColors.primary, size: 22),
      );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 12, color: const Color(0xFF6B7280)),
        ],
      ),
    );
  }
}
