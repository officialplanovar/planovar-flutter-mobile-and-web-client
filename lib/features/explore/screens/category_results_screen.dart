import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/favourites_service.dart';
import '../../../core/services/listing_service.dart';
import '../../../core/services/vendor_service.dart';
import '../../../core/state/overlay_state.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../l10n/app_localizations.dart';

class CategoryResultsScreen extends StatefulWidget {
  const CategoryResultsScreen({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  final String categorySlug;
  final String categoryName;

  @override
  State<CategoryResultsScreen> createState() => _CategoryResultsScreenState();
}

class _CategoryResultsScreenState extends State<CategoryResultsScreen> {
  final _searchCtrl = TextEditingController();
  String _activeFilter = 'all';

  /// Selected API EventType enum filter for vendor browsing (null = all).
  String? _eventTypeFilter;

  /// Vendor-mode event-type filter chips (label ↔ API EventType enum value).
  static const _eventTypeOptions = [
    (label: 'Wedding', value: 'WEDDING'),
    (label: 'Funeral', value: 'FUNERAL'),
    (label: 'Birthday', value: 'BIRTHDAY'),
    (label: 'Corporate', value: 'CORPORATE'),
    (label: 'Social party', value: 'SOCIAL_PARTY'),
  ];

  final _vendorService = VendorService();
  final _listingService = ListingService();

  bool _loading = true;
  bool _failed = false;
  List<VendorModel> _allVendors = const [];
  List<ListingModel> _allListings = const [];
  Set<String> _favIds = const {};

  bool get _isProductsCategory => widget.categorySlug == 'products';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      if (_isProductsCategory) {
        // "Products" is a cross-category view of every fixed-price listing.
        // DB-backed browse (not search) — reliable regardless of Typesense.
        _allListings =
            await _listingService.browseListings(pricingType: 'FIXED');
        // Which of these the user has already saved (best-effort).
        try {
          _favIds = await FavouritesService().favouriteIds();
        } catch (_) {
          _favIds = const {};
        }
      } else {
        _allVendors = await _vendorService.getVendors(
          category: widget.categorySlug == 'all' ? null : widget.categorySlug,
          eventType: _eventTypeFilter,
        );
        // Which of these vendors the user has already saved (best-effort).
        try {
          _favIds = await _vendorService.favouriteIds();
        } catch (_) {
          _favIds = const {};
        }
      }
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  // ── Vendor mode (query filtered client-side over the loaded set) ───────────
  List<VendorModel> get _vendors {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _allVendors;
    return _allVendors
        .where((v) => v.businessName.toLowerCase().contains(q))
        .toList();
  }

  // ── Product mode ──────────────────────────────────────────────────────────
  List<ListingModel> get _listings {
    final q = _searchCtrl.text.trim().toLowerCase();
    final searched = q.isEmpty
        ? _allListings
        : _allListings.where((l) => l.title.toLowerCase().contains(q));
    return searched.where((l) {
      if (_activeFilter == 'sale') return !l.isRentable;
      if (_activeFilter == 'rent') return l.isRentable;
      return true;
    }).toList();
  }

  String _eventTypeLabel(AppLocalizations t, String label) {
    switch (label) {
      case 'Wedding':
        return t.eventTypeWedding;
      case 'Funeral':
        return t.eventTypeFuneral;
      case 'Birthday':
        return t.eventTypeBirthday;
      case 'Corporate':
        return t.eventTypeCorporate;
      case 'Social party':
        return t.eventTypeSocialParty;
      default:
        return label;
    }
  }

  /// Applies (or clears) the event-type filter and reloads vendors.
  void _selectEventType(String? value) {
    if (_eventTypeFilter == value) return;
    setState(() => _eventTypeFilter = value);
    _load();
  }

  void _openFilters() {
    bottomSheetCount.value++;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SimpleFilterSheet(),
    ).whenComplete(() => bottomSheetCount.value--);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final listings = _listings;
    final vendors = _vendors;

    return Scaffold(
      backgroundColor: context.c.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.c.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.c.textPrimary,
              size: 18,
            ),
          ),
        ),
        title: Text(
          widget.categoryName,
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search row
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: _isProductsCategory
                            ? t.searchProductsHint
                            : t.searchCategoryHint(widget.categoryName),
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textHint,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _openFilters,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter tabs — only for products category
          if (_isProductsCategory)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                children: [
                  _FilterChip(
                    label: t.filterAll,
                    selected: _activeFilter == 'all',
                    onTap: () => setState(() => _activeFilter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: t.availableForSale,
                    selected: _activeFilter == 'sale',
                    onTap: () => setState(() => _activeFilter = 'sale'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: t.availableForRent,
                    selected: _activeFilter == 'rent',
                    onTap: () => setState(() => _activeFilter = 'rent'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),

          // Event-type filter chips — vendor categories only.
          if (!_isProductsCategory)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                children: [
                  _FilterChip(
                    label: t.eventTypeAll,
                    selected: _eventTypeFilter == null,
                    onTap: () => _selectEventType(null),
                  ),
                  const SizedBox(width: 8),
                  for (final opt in _eventTypeOptions) ...[
                    _FilterChip(
                      label: _eventTypeLabel(t, opt.label),
                      selected: _eventTypeFilter == opt.value,
                      onTap: () => _selectEventType(opt.value),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const SizedBox(width: 8),
                ],
              ),
            ),

          // Grid — products or vendors depending on category
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _failed
                ? _ResultsMessage(
                    message: t.somethingWentWrongRetry,
                    onTap: _load,
                  )
                : _isProductsCategory
                ? (listings.isEmpty
                    ? Center(
                        child: Text(
                          t.noProductsFound,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: context.c.textHint,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          // ~2 columns on a phone, more as the screen widens.
                          maxCrossAxisExtent: 260,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: listings.length,
                        itemBuilder: (ctx, i) =>
                            _ProductGridCard(
                              listing: listings[i],
                              initiallyFav: _favIds.contains(listings[i].id),
                            ),
                      ))
                : (vendors.isEmpty
                    ? Center(
                        child: Text(
                          t.noVendorsFound,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: context.c.textHint,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.988,
                        ),
                        itemCount: vendors.length,
                        itemBuilder: (ctx, i) => _VendorGridCard(
                          vendor: vendors[i],
                          initiallyFav: _favIds.contains(vendors[i].id),
                          onTap: () => ctx.push(
                              AppRoutes.vendorProfilePath(vendors[i].id)),
                        ),
                      )),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chip
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                )
              : null,
          color: selected ? null : context.c.surface,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? null
              : Border.all(color: context.c.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.c.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tappable empty/error message
// ---------------------------------------------------------------------------

class _ResultsMessage extends StatelessWidget {
  const _ResultsMessage({required this.message, this.onTap});

  final String message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              color: context.c.textHint,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product grid card
// ---------------------------------------------------------------------------

class _ProductGridCard extends StatefulWidget {
  const _ProductGridCard({required this.listing, this.initiallyFav = false});

  final ListingModel listing;
  final bool initiallyFav;

  @override
  State<_ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<_ProductGridCard> {
  late bool _isFav = widget.initiallyFav;
  bool _favBusy = false;

  ListingModel get listing => widget.listing;

  Future<void> _toggleFav() async {
    if (_favBusy) return;
    final prev = _isFav;
    setState(() {
      _isFav = !prev;
      _favBusy = true;
    });
    try {
      await FavouritesService().toggle(listing.id, prev);
    } catch (_) {
      if (mounted) setState(() => _isFav = prev); // revert on failure
    } finally {
      if (mounted) setState(() => _favBusy = false);
    }
  }

  void _handleCta() {
    showAddToEventSheet(context, listing: listing);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.listingDetailPath(listing.id)),
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surface,
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
            // Image with heart overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: listing.media.isNotEmpty
                        ? Image.network(
                            listing.media.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: context.c.primaryLight,
                              child: const Icon(
                                Icons.image_outlined,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                          )
                        : Container(
                            color: context.c.primaryLight,
                            child: const Icon(
                              Icons.image_outlined,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFav,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            listing.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.c.textPrimary,
                            ),
                          ),
                        ),
                        if (listing.reviewCount > 0) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.starColor,
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            listing.ratingAvg.toStringAsFixed(1),
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: context.c.textPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price
                    Text(
                      listing.basePrice != null
                          ? Formatters.currency(listing.basePrice!)
                          : t.contactForPrice,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: context.c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // CTA button
                    GestureDetector(
                      onTap: _handleCta,
                      child: Container(
                        height: 34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            listing.isRentable
                                ? t.rentForEvent
                                : t.addToEventPlus,
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
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Simple filter bottom sheet
// ---------------------------------------------------------------------------

class _SimpleFilterSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: context.c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.c.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Text(
                t.filters,
                style: GoogleFonts.urbanist(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.moreFiltersComingSoon,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textHint,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      t.close,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Vendor grid card ────────────────────────────────────────────────────────

class _VendorGridCard extends StatefulWidget {
  const _VendorGridCard({
    required this.vendor,
    required this.onTap,
    this.initiallyFav = false,
  });

  final VendorModel vendor;
  final VoidCallback onTap;
  final bool initiallyFav;

  @override
  State<_VendorGridCard> createState() => _VendorGridCardState();
}

class _VendorGridCardState extends State<_VendorGridCard> {
  late bool _isFav = widget.initiallyFav;
  bool _favBusy = false;

  VendorModel get vendor => widget.vendor;
  VoidCallback get onTap => widget.onTap;

  Future<void> _toggleFav() async {
    if (_favBusy) return;
    final prev = _isFav;
    setState(() {
      _isFav = !prev;
      _favBusy = true;
    });
    try {
      await VendorService().toggleFavourite(vendor.id, prev);
    } catch (_) {
      if (mounted) setState(() => _isFav = prev); // revert on failure
    } finally {
      if (mounted) setState(() => _favBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final categoryLabel =
        vendor.categories.isNotEmpty ? vendor.categories.first : t.vendorLabel;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                    height: 100,
                    width: double.infinity,
                    child: vendor.coverUrl != null
                        ? Image.network(
                            vendor.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: context.c.primaryLight,
                              child: const Icon(Icons.storefront_outlined,
                                  color: AppColors.primary, size: 40),
                            ),
                          )
                        : Container(
                            color: context.c.primaryLight,
                            child: const Icon(Icons.storefront_outlined,
                                color: AppColors.primary, size: 40),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleFav,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          _isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            categoryLabel,
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star_rounded,
                            color: AppColors.starColor, size: 13),
                        const SizedBox(width: 2),
                        Text(
                          vendor.ratingAvg.toStringAsFixed(1),
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.c.textPrimary,
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
