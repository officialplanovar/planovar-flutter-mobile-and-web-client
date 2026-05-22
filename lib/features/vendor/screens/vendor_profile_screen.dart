import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../shared/widgets/glass_circle_button.dart';

class VendorProfileScreen extends StatefulWidget {
  final String vendorId;

  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late VendorModel _vendor;
  late List<ListingModel> _listings;
  late List<ListingModel> _products;
  late List<ListingModel> _services;
  late List<String> _images;
  int _currentPage = 0;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _vendor = MockData.vendors.firstWhere(
      (v) => v.id == widget.vendorId,
      orElse: () => MockData.vendors.first,
    );
    _listings =
        MockData.listings.where((l) => l.vendorId == _vendor.id).toList();
    _products = _listings.where((l) => l.pricingType == 'fixed').toList();
    _services = _listings.where((l) => l.pricingType == 'quote').toList();
    _images = _vendor.coverUrl != null
        ? [_vendor.coverUrl!, _vendor.coverUrl!, _vendor.coverUrl!]
        : [];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _fmt(num n) {
    final s = n.toInt().toString();
    final buf = StringBuffer('₦ ');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // ── Cover image sliver ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: screenHeight * 0.42,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: GlassCircleButton(
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                child: GestureDetector(
                  onTap: () {},
                  child: const GlassCircleButton(
                    child: Icon(Icons.share_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorited = !_isFavorited),
                  child: GlassCircleButton(
                    child: Icon(
                      _isFavorited
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _isFavorited ? Colors.redAccent : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (_images.isEmpty)
                    Container(
                      color: AppColors.primaryLight,
                      child: const Center(
                        child: Icon(Icons.store_rounded,
                            color: AppColors.primary, size: 60),
                      ),
                    )
                  else
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _images.length,
                      onPageChanged: (i) =>
                          setState(() => _currentPage = i),
                      itemBuilder: (_, i) => Image.network(
                        _images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primaryLight,
                          child: const Center(
                            child: Icon(Icons.store_rounded,
                                color: AppColors.primary, size: 60),
                          ),
                        ),
                      ),
                    ),
                  // Dot indicators
                  if (_images.length > 1)
                    Positioned(
                      bottom: 36,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_images.length, (i) {
                          final active = i == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primary
                                  : Colors.white
                                      .withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── White info panel ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vendor name
                          Text(
                            _vendor.businessName,
                            style: const TextStyle(

                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: Color(0xFF1A1A2E),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Rating · Verified · Location — single row
                          Row(
                            children: [
                              // Star + rating
                              const Icon(Icons.star_rounded,
                                  color: AppColors.starColor, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                _vendor.ratingAvg.toStringAsFixed(1),
                                style: const TextStyle(

                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '(${_vendor.reviewCount})',
                                style: const TextStyle(

                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              if (_vendor.isVerified) ...[
                                const SizedBox(width: 10),
                                const Icon(Icons.verified_rounded,
                                    color: AppColors.primary, size: 15),
                                const SizedBox(width: 3),
                                const Text(
                                  'Verified',
                                  style: TextStyle(

                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                              const SizedBox(width: 10),
                              const Icon(Icons.location_on_rounded,
                                  color: Color(0xFF6B7280), size: 14),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  _vendor.location ?? 'Lagos, Nigeria',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(

                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tab bar
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'About'),
                        Tab(text: 'Products'),
                        Tab(text: 'Services'),
                        Tab(text: 'Reviews'),
                      ],
                      indicator: const UnderlineTabIndicator(
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          topRight: Radius.circular(3),
                        ),
                        insets: EdgeInsets.zero,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Color(0xFF9CA3AF),
                      labelStyle: const TextStyle(

                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(

                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      isScrollable: false,
                      dividerColor: Colors.transparent,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  ],
                ),
              ),
            ),
          ),
        ],

        // ── Tab content ──────────────────────────────────────────────────────
        body: TabBarView(
          controller: _tabController,
          children: [
            _AboutTab(vendor: _vendor),
            _ProductsTab(products: _products, fmt: _fmt),
            _ServicesTab(services: _services, fmt: _fmt),
            _ReviewsTab(vendor: _vendor),
          ],
        ),
      ),
    );
  }
}

// ─── About Tab ───────────────────────────────────────────────────────────────

class _AboutTab extends StatefulWidget {
  final VendorModel vendor;

  const _AboutTab({required this.vendor});

  @override
  State<_AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<_AboutTab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final description =
        widget.vendor.description ?? 'No description available.';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description with read more/less
          Text(
            description,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Read less' : 'Read more',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 22),
          // Info rows
          _InfoRow(Icons.location_on_outlined,
              '${widget.vendor.location ?? 'Lagos Island'} · 20km service radius'),
          _InfoRow(Icons.access_time_outlined, 'Mon–Sat · 9am–6pm'),
          _InfoRow(Icons.flash_on_outlined, 'Responds within ~30 mins'),
          const SizedBox(height: 22),
          // Also offers
          const Text(
            'Also offers',
            style: TextStyle(

              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ['Products to buy', 'Services to book', 'Equipment rentals']
                    .map(
                      (label) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(

                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 26),
          // Directions
          const Text(
            'Directions',
            style: TextStyle(

              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Realistic static map tile
                  Image.network(
                    'https://tile.openstreetmap.org/13/4921/3972.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE8EAD8),
                      child: const Center(
                        child: Icon(Icons.map_rounded,
                            size: 48, color: Color(0xFFBBBBBB)),
                      ),
                    ),
                  ),
                  // Pin overlay
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(

                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Products Tab ─────────────────────────────────────────────────────────────

class _ProductsTab extends StatelessWidget {
  final List<ListingModel> products;
  final String Function(num) fmt;

  const _ProductsTab({required this.products, required this.fmt});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available',
          style: TextStyle(

            fontSize: 14,
            color: Color(0xFF9CA3AF),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(listing: products[index], fmt: fmt);
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final ListingModel listing;
  final String Function(num) fmt;

  const _ProductCard({required this.listing, required this.fmt});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isFaved = false;

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final imageUrl = listing.media.isNotEmpty ? listing.media.first : null;
    final isRentable = listing.pricingType == 'fixed' &&
        listing.basePrice != null &&
        listing.basePrice! < 50000;
    final buttonLabel = isRentable ? 'Rent for your Event' : 'Add to Event +';
    final priceLabel = listing.basePrice != null
        ? widget.fmt(listing.basePrice!)
        : 'Get Quote';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.listingDetailPath(listing.id)),
      child: _ListingCard(
        imageUrl: imageUrl,
        isFaved: _isFaved,
        onFavTap: () => setState(() => _isFaved = !_isFaved),
        title: listing.title,
        rating: '4.8',
        price: priceLabel,
        buttonLabel: buttonLabel,
        onButtonTap: () => showAddToEventSheet(
          context,
          listing: listing,
          onConfirm: (eventIds) => context.push(
            AppRoutes.serviceDetails,
            extra: {'listingId': listing.id, 'eventId': eventIds.first},
          ),
        ),
      ),
    );
  }
}

// ─── Services Tab ─────────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  final List<ListingModel> services;
  final String Function(num) fmt;

  const _ServicesTab({required this.services, required this.fmt});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Text(
          'No services available',
          style: TextStyle(

            fontSize: 14,
            color: Color(0xFF9CA3AF),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _ServiceCard(listing: services[index], fmt: fmt);
      },
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ListingModel listing;
  final String Function(num) fmt;

  const _ServiceCard({required this.listing, required this.fmt});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isFaved = false;

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final imageUrl = listing.media.isNotEmpty ? listing.media.first : null;

    String priceDisplay;
    if (listing.packages.isNotEmpty) {
      final prices =
          listing.packages.map((p) => p.price).toList()..sort();
      priceDisplay = prices.length == 1
          ? widget.fmt(prices.first)
          : '${widget.fmt(prices.first)} – ${widget.fmt(prices.last)}';
    } else {
      priceDisplay = 'Get Quote';
    }

    return GestureDetector(
      onTap: () => context.push(AppRoutes.listingDetailPath(listing.id)),
      child: _ListingCard(
        imageUrl: imageUrl,
        isFaved: _isFaved,
        onFavTap: () => setState(() => _isFaved = !_isFaved),
        title: listing.title,
        rating: '4.8',
        price: priceDisplay,
        showButton: false,
        priceColor: AppColors.primary,
      ),
    );
  }
}

// ─── Shared listing card ─────────────────────────────────────────────────────

class _ListingCard extends StatelessWidget {
  final String? imageUrl;
  final bool isFaved;
  final VoidCallback onFavTap;
  final String title;
  final String rating;
  final String price;
  final bool showButton;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  final Color priceColor;

  const _ListingCard({
    required this.imageUrl,
    required this.isFaved,
    required this.onFavTap,
    required this.title,
    required this.rating,
    required this.price,
    this.showButton = true,
    this.buttonLabel,
    this.onButtonTap,
    this.priceColor = const Color(0xFF1A1A2E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + heart ──────────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(),
                      )
                    : _imgPlaceholder(),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isFaved
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFaved ? Colors.white : AppColors.primary,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── Card body ──────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating on same row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: priceColor,
                    ),
                  ),
                  if (showButton) ...[
                    const Spacer(),
                    // CTA button
                    GestureDetector(
                      onTap: onButtonTap,
                      child: Container(
                        height: 34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            buttonLabel ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        height: 130,
        color: AppColors.primaryLight,
        child: const Center(
          child: Icon(Icons.image_rounded, color: AppColors.primary, size: 32),
        ),
      );
}

// ─── Reviews Tab ──────────────────────────────────────────────────────────────

class _ReviewsTab extends StatelessWidget {
  final VendorModel vendor;

  const _ReviewsTab({required this.vendor});

  static const _mockReviews = [
    (
      name: 'Ngozi A.',
      rating: 4,
      body:
          'Absolutely stunning and tasted incredible. Delivered on time and exactly as designed.',
      date: 'Mar 2026',
    ),
    (
      name: 'Chidi O.',
      rating: 5,
      body:
          'Professional and creative team. They made our event look absolutely magical from start to finish.',
      date: 'Feb 2026',
    ),
    (
      name: 'Amaka E.',
      rating: 4,
      body:
          'Very responsive and accommodating. Great value for the quality delivered. Would definitely hire again.',
      date: 'Jan 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rating = vendor.ratingAvg;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary, width: 1.2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: GoogleFonts.spirax(
                    fontSize: 56,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < rating.floor();
                    final halfFilled =
                        !filled && i < rating && (rating - i) >= 0.5;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        halfFilled
                            ? Icons.star_half_rounded
                            : Icons.star_rounded,
                        color: (filled || halfFilled)
                            ? AppColors.starColor
                            : const Color(0xFFD1D5DB),
                        size: 22,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '${vendor.reviewCount} verified reviews',
                  style: const TextStyle(

                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Review cards
          ..._mockReviews.map(
            (review) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        review.name,
                        style: const TextStyle(

                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star_rounded,
                            color: i < review.rating
                                ? AppColors.starColor
                                : const Color(0xFFD1D5DB),
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.body,
                    style: const TextStyle(

                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.date,
                    style: const TextStyle(

                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
