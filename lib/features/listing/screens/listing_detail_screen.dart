import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/favourites_service.dart';
import '../../../core/services/listing_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../shared/widgets/glass_circle_button.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/widgets/request_order_sheet.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;

  /// When reached from *within* an event, "Add to Event" saves straight to this
  /// event (with confirmation) instead of opening the event picker.
  final String? eventId;
  final String? eventName;
  const ListingDetailScreen({
    super.key,
    required this.listingId,
    this.eventId,
    this.eventName,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  bool _descExpanded = false;
  bool _isFavourite = false;
  bool _favBusy = false;
  bool _loadFailed = false;
  bool _policyOverlayVisible = false;
  int _heroIndex = 0;
  final _heroPageController = PageController();
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

  @override
  void dispose() {
    _heroPageController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    // Live listing from the API; falls back to mock data for demo ids.
    ListingModel? loaded;
    try {
      loaded = await ListingService().getListing(widget.listingId);
      // Record a real view (fire-and-forget) so the vendor's count reflects it.
      if (loaded != null) {
        ListingService().recordView(widget.listingId);
      }
    } catch (_) {}
    if (!mounted) return;
    if (loaded == null) {
      setState(() => _loadFailed = true);
      return;
    }
    setState(() {
      _listing = loaded;
      if (loaded!.sizes.isNotEmpty) _selectedSize = loaded.sizes.first;
      if (loaded.colors.isNotEmpty) _selectedColor = loaded.colors.first;
    });
    // Reflect whether this listing is already saved (best-effort).
    try {
      final ids = await FavouritesService().favouriteIds();
      if (mounted) setState(() => _isFavourite = ids.contains(widget.listingId));
    } catch (_) {}
  }

  Future<void> _toggleFavourite() async {
    if (_favBusy) return;
    final prev = _isFavourite;
    setState(() {
      _isFavourite = !prev;
      _favBusy = true;
    });
    try {
      await FavouritesService().toggle(widget.listingId, prev);
    } catch (_) {
      if (mounted) setState(() => _isFavourite = prev); // revert on failure
    } finally {
      if (mounted) setState(() => _favBusy = false);
    }
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

  List<String> _policyTerms(String policy) {
    switch (policy) {
      case 'Flexible':
        return [
          'Full refund if cancelled up to 24 hours before the event.',
          'A small processing fee may apply.',
        ];
      case 'Strict':
        return ['No refund once the booking is confirmed.'];
      case 'Moderate':
      default:
        return [
          '100% refund if cancelled 7+ days before the event.',
          '50% refund if cancelled 3–6 days before the event.',
          'No refund within 48 hours of the event.',
        ];
    }
  }

  String get _servicePriceRange {
    if (listing.packages.isNotEmpty) {
      final prices = listing.packages.map((p) => p.price).toList()..sort();
      String f(double n) => '₦ ${_fmt(n)}';
      return prices.length == 1
          ? f(prices.first)
          : '${f(prices.first)} - ${f(prices.last)}';
    }
    if (listing.basePrice != null && listing.basePrice! > 0) {
      return 'From ₦ ${_fmt(listing.basePrice!)}';
    }
    return 'Quote on request';
  }

  void _showAddToEventSheet() {
    if (widget.eventId != null) {
      confirmAddListingToEvent(context,
          listing: listing,
          eventId: widget.eventId!,
          eventName: widget.eventName);
    } else {
      showAddToEventSheet(context, listing: listing);
    }
  }

  Color _hexColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_loadFailed) {
      return Scaffold(
        backgroundColor: context.c.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.c.textPrimary),
        ),
        body: Center(
          child: Text(
            'Listing not found',
            style: GoogleFonts.urbanist(color: context.c.textSecondary),
          ),
        ),
      );
    }
    if (_listing == null) {
      return Scaffold(
        backgroundColor: context.c.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: context.c.surface,
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
                    onTap: _toggleFavourite,
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
                  background: listing.media.isEmpty
                      ? Container(color: context.c.primaryLight)
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            PageView.builder(
                              controller: _heroPageController,
                              itemCount: listing.media.length,
                              onPageChanged: (i) =>
                                  setState(() => _heroIndex = i),
                              itemBuilder: (_, i) => Image.network(
                                listing.media[i],
                                fit: BoxFit.cover,
                                errorBuilder: (context, __, ___) => Container(
                                  color: context.c.primaryLight,
                                  child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.primary,
                                      size: 48),
                                ),
                              ),
                            ),
                            if (listing.media.length > 1)
                              Positioned(
                                bottom: 12,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    listing.media.length,
                                    (i) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      width: _heroIndex == i ? 18 : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _heroIndex == i
                                            ? Colors.white
                                            : Colors.white
                                                .withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Thumbnail strip (any listing with >1 image) ─────────
                    if (listing.media.length > 1)
                      Container(
                        color: context.c.surface,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: List.generate(
                            min(listing.media.length, 4),
                            (i) => GestureDetector(
                              onTap: () {
                                setState(() => _heroIndex = i);
                                _heroPageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                );
                              },
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
                                    errorBuilder: (context, __, ___) => Container(
                                        color: context.c.primaryLight),
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
                            color: context.c.border,
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
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                ),
                                if (listing.reviewCount > 0) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.star_rounded,
                                      color: AppColors.starColor, size: 18),
                                  const SizedBox(width: 3),
                                  Text(
                                    listing.ratingAvg.toStringAsFixed(1),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                ],
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
                            if (listing.category?.name != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: context.c.primaryLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  listing.category!.name,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              'Description',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: context.c.textHint,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              listing.description ?? '',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: context.c.textSecondary,
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
                                    final avg = listing.ratingAvg;
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
                                      color: context.c.textSecondary,
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
                                color: context.c.textPrimary,
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
                                      color: context.c.textSecondary,
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
                                color: context.c.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.c.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: context.c.border),
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
                            color: context.c.textPrimary,
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
                                      : context.c.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : context.c.border,
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
                            color: context.c.textPrimary,
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

                    // ── Cancellation policy + duration (service listings) ────
                    if (!_isProduct &&
                        (listing.cancellationPolicy != null ||
                            listing.durationValue != null)) ...[
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(height: 12),
                            if (listing.cancellationPolicy != null) ...[
                              Row(
                                children: [
                                  Text(
                                    'Cancellation Policy:',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: context.c.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    listing.cancellationPolicy!,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: context.c.textPrimary,
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
                                    color: context.c.primaryLight,
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
                                        '${listing.cancellationPolicy!} Cancellation Policy',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: context.c.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ..._policyTerms(
                                              listing.cancellationPolicy!)
                                          .map((t) => _PolicyLine(t)),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                            if (listing.durationValue != null)
                              Row(
                                children: [
                                  Text(
                                    'Service Duration:',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: context.c.textSecondary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${listing.durationValue}'
                                    '${(listing.durationUnit ?? '').isNotEmpty ? ' ${listing.durationUnit}' : ''}',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],

                    // ── Vendor Details (products & services) ────────────────
                    if (listing.vendor != null) ...[
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Vendor Details',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
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
                              color: context.c.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: context.c.border),
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
                                                      _vendorPlaceholder(context),
                                            )
                                          : _vendorPlaceholder(context),
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
                                                  context.c.textPrimary,
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
                                                  color: context.c.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                ' (${listing.vendor!.reviewCount})',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: context.c.textSecondary,
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
                                                Icon(
                                                    Icons.location_on_rounded,
                                                    color: context.c.textSecondary,
                                                    size: 13),
                                                const SizedBox(width: 2),
                                                Expanded(
                                                  child: Text(
                                                    listing.vendor!.location!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: context.c.textSecondary,
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
                                      color: context.c.surface,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      border: Border.all(
                                          color: context.c.border),
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
              color: context.c.surface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlossyButton(
                        label: listing.isRentable
                            ? 'Rent for your Event'
                            : _isProduct
                                ? '+ Add to Event'
                                : 'Add to Event',
                        onPressed: _showAddToEventSheet,
                      ),
                      if (_isProduct || listing.isRentable) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => showRequestOrderSheet(
                              context,
                              listing: listing,
                              eventId: widget.eventId,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              listing.isRentable ? 'Rent now' : 'Order now',
                              style: GoogleFonts.urbanist(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
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

  Widget _vendorPlaceholder(BuildContext context) => Container(
        width: 48,
        height: 48,
        color: context.c.primaryLight,
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
