import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_notification_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/reference_data_service.dart';
import '../../../core/services/vendor_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../core/responsive/responsive.dart';

String _fmtPrice(num n) {
  final s = n.toInt().toString();
  final buf = StringBuffer('₦ ');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _notifService = MockNotificationService();

  // Live feed data from the API. Empty = show empty/hidden section (no mock).
  List<CategoryModel> _liveCategories = [];
  List<VendorModel> _liveVendors = [];
  List<BookingModel> _liveBookings = [];
  List<ListingModel> _liveProducts = [];

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      final categories = CategoryService().getCategories();
      final vendorsF = VendorService().getVendors();
      final bookingsF = BookingService().getBookings();
      final vendors = await vendorsF;

      // Products strip = active listings from the top recommended vendors
      // (real Prisma shape via /vendors/:id listings — reliable, not Typesense).
      final listingLists = await Future.wait(
        vendors.take(3).map((v) => VendorService().getVendorListings(v.id)),
      );
      final products = listingLists
          .expand((l) => l)
          .where((l) => l.isActive)
          .toList();

      final results = await Future.wait([categories, bookingsF]);
      if (!mounted) return;
      setState(() {
        _liveCategories = results[0] as List<CategoryModel>;
        _liveVendors = vendors;
        _liveBookings = results[1] as List<BookingModel>;
        _liveProducts = products;
      });
    } catch (_) {
      // Keep sections empty on error — no mock data shown.
    }
  }

  List<BookingModel> get _upcomingEvents => _liveBookings
      .where((b) =>
          b.status != 'completed' &&
          b.status != 'cancelled' &&
          b.eventDate.isAfter(DateTime.now()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final nameParts = (user?.name ?? '').trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty && nameParts.first.isNotEmpty
        ? nameParts.first
        : 'there';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    // Real location from the client's profile prefs (no dummy fallback).
    final profile = user?.clientProfile;
    final locationLabel = [profile?.preferredCity, profile?.preferredCountry]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(', ');

    final categories = _liveCategories.take(8).toList();
    final vendors = _liveVendors.take(4).toList();
    final products = _liveProducts.take(4).toList();

    return Scaffold(
      backgroundColor: context.c.surface,
      body: RefreshIndicator(
        onRefresh: _loadFeed,
        color: AppColors.primary,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
            child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [context.c.primaryLight, context.c.surface],
                    stops: [0.0, 1.0],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (locationLabel.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                locationLabel,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: user?.image != null
                                  ? NetworkImage(user!.image!)
                                  : null,
                              backgroundColor: context.c.primaryLight,
                              child: user?.image == null
                                  ? const Icon(Icons.person_rounded,
                                      color: AppColors.primary)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: context.c.textHint,
                                    ),
                                  ),
                                  Text.rich(TextSpan(children: [
                                    TextSpan(
                                      text: '$firstName ',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: context.c.textPrimary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: lastName,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ])),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.push(AppRoutes.notifications),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: context.c.primaryLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.notifications_outlined,
                                        color: AppColors.primary,
                                        size: 22),
                                  ),
                                  if (_notifService.unreadCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${_notifService.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.explore),
                          child: Container(
                            height: 50,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: context.c.surface,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Search for a vendor or location',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: context.c.textHint,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.search_rounded,
                                    color: AppColors.primary, size: 22),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),

                  // Browse Categories
                  _SectionHeader(
                    title: 'Browse Categories',
                    onViewAll: () => context.go(AppRoutes.explore),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.82,
                    children: categories
                        .map((c) => _CategoryIcon(category: c))
                        .toList(),
                  ),

                  const SizedBox(height: 28),

                  // Upcoming Events
                  _SectionHeader(
                    title: 'Your Upcoming Events',
                    onViewAll: () => context.go(AppRoutes.events),
                  ),
                  const SizedBox(height: 12),
                  if (_upcomingEvents.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: context.c.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'No upcoming events',
                          style: GoogleFonts.urbanist(
                              color: context.c.textHint),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: _upcomingEvents.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, i) => SizedBox(
                          width: 280,
                          child: _EventCard(booking: _upcomingEvents[i]),
                        ),
                      ),
                    ),

                  const SizedBox(height: 28),

                  // Recommended Vendors
                  _SectionHeader(
                    title: 'Recommended Vendors for you',
                    onViewAll: () => context.go(AppRoutes.explore),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                    children: vendors
                        .map((v) => _VendorGridCard(
                              vendor: v,
                              onTap: () => context.push(
                                  AppRoutes.vendorProfilePath(v.id)),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 28),

                  // Recommended Products
                  _SectionHeader(
                    title: 'Recommended Products for you',
                    onViewAll: () => context.go(AppRoutes.explore),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.58,
                    children: products
                        .map((l) => _ProductCard(listing: l))
                        .toList(),
                  ),

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: context.c.textPrimary,
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'View All',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Category icon chip ─────────────────────────────────────────────────────────

class _CategoryIcon extends StatelessWidget {
  final CategoryModel category;
  const _CategoryIcon({required this.category});

  static const _icons = <String, IconData>{
    'photography': Icons.camera_alt_rounded,
    'videography': Icons.videocam_rounded,
    'catering': Icons.restaurant_rounded,
    'decor': Icons.auto_awesome_rounded,
    'floral': Icons.local_florist_rounded,
    'dj-music': Icons.headphones_rounded,
    'venues': Icons.account_balance_rounded,
    'bands': Icons.music_note_rounded,
    'drinks': Icons.local_bar_rounded,
    'emcees': Icons.mic_rounded,
    'beauty': Icons.face_retouching_natural,
    'confectionery': Icons.cake_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[category.slug] ?? Icons.category_rounded;
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.categoryResultsPath(category.slug),
        extra: {'categoryName': category.name},
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: context.c.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: const Color(0xFF374151)),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.urbanist(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Event card ─────────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final BookingModel booking;
  const _EventCard({required this.booking});

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  @override
  Widget build(BuildContext context) {
    final d = booking.eventDate;
    final imageUrl = booking.listing?.media.isNotEmpty == true
        ? booking.listing!.media.first
        : booking.vendor?.coverUrl ?? '';

    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: context.c.primaryLight,
                      child: const Icon(Icons.event_rounded,
                          color: AppColors.primary, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _months[d.month - 1],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${d.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_outward_rounded,
                        size: 16, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.listing?.title ??
                        '${booking.vendor?.businessName ?? ''} Event',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 13, color: context.c.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          booking.eventLocation ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: context.c.textHint),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time_rounded,
                          size: 13, color: context.c.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '10:20 am',
                        style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: context.c.textHint),
                      ),
                    ],
                  ),
                  if (booking.quoteAmount != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.sell_outlined,
                            size: 14, color: context.c.textHint),
                        const SizedBox(width: 4),
                        Text(
                          _fmtPrice(booking.quoteAmount!),
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vendor grid card ───────────────────────────────────────────────────────────

class _VendorGridCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback onTap;
  const _VendorGridCard({required this.vendor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Image.network(
                      vendor.coverUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: context.c.primaryLight,
                        child: const Icon(Icons.store_rounded,
                            color: AppColors.primary, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.favorite_border_rounded,
                          size: 16, color: context.c.textHint),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: context.c.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            vendor.categories.isNotEmpty
                                ? vendor.categories.first
                                : 'Vendor',
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star_rounded,
                            size: 13, color: AppColors.starColor),
                        const SizedBox(width: 2),
                        Text(
                          vendor.ratingAvg.toStringAsFixed(1),
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      vendor.businessName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product card ───────────────────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  final ListingModel listing;
  const _ProductCard({required this.listing});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isFaved = false;

  void _onCta(BuildContext context) {
    showAddToEventSheet(context, listing: widget.listing);
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    final price = listing.basePrice != null
        ? _fmtPrice(listing.basePrice!)
        : listing.packages.isNotEmpty
            ? _fmtPrice(listing.packages.first.price)
            : 'Get Quote';
    final btnLabel =
        listing.isRentable ? 'Rent for your event' : 'Add to Event +';
    final imageUrl = listing.media.isNotEmpty ? listing.media.first : '';

    return GestureDetector(
      onTap: () => context.push(AppRoutes.listingDetailPath(listing.id)),
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: context.c.primaryLight,
                        child: const Icon(Icons.category_rounded,
                            color: AppColors.primary, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _isFaved = !_isFaved),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _isFaved
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.92),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isFaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 15,
                          color: _isFaved ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: context.c.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded,
                            size: 12, color: AppColors.starColor),
                        const SizedBox(width: 2),
                        Text(
                          listing.vendor?.ratingAvg.toStringAsFixed(1) ?? '',
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            color: context.c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: context.c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _onCta(context),
                      child: Container(
                        width: double.infinity,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            btnLabel,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
