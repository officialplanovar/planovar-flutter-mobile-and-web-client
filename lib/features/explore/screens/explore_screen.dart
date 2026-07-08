import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/reference_data_service.dart';
import '../../../core/state/overlay_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../../shared/models/category_model.dart';

String _fmtPrice(num n) {
  final s = n.toStringAsFixed(0);
  final buf = StringBuffer();
  final offset = s.length % 3;
  for (int i = 0; i < s.length; i++) {
    if (i != 0 && (i - offset) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '₦${buf.toString()}';
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchCtrl = TextEditingController();

  RangeValues _priceRange = const RangeValues(0, 500000);
  int? _selectedRating;
  String _locationFilter = '';
  int get _activeFilterCount =>
      (_priceRange.start > 0 || _priceRange.end < 500000 ? 1 : 0) +
      (_selectedRating != null ? 1 : 0) +
      (_locationFilter.isNotEmpty ? 1 : 0);

  /// Live categories from the API (mock fallback while loading / on error).
  List<CategoryModel> _liveCategories = [];

  @override
  void initState() {
    super.initState();
    CategoryService().getCategories().then((cats) {
      if (mounted) setState(() => _liveCategories = cats);
    }).catchError((_) {});
  }

  List<CategoryModel> get _allCategories =>
      _liveCategories.isNotEmpty ? _liveCategories : MockData.categories;

  List<CategoryModel> get _filteredCategories {
    final q = _searchCtrl.text.trim().toLowerCase();
    // 'products' is promoted to the Services/Products toggle, not a grid tile.
    final base = _allCategories.where((c) => c.slug != 'products');
    if (q.isEmpty) return base.toList();
    return base.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  /// Explicit browse mode. Services = category grid (vendors); Products opens
  /// the dedicated cross-category product browser.
  void _openProducts() {
    context.push(
      AppRoutes.categoryResultsPath('products'),
      extra: {'categoryName': 'Products'},
    );
  }

  Widget _buildModeToggle(BuildContext context) {
    Widget tab(String label, IconData icon,
        {required bool selected, required VoidCallback onTap}) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    size: 16,
                    color: selected ? Colors.white : context.c.textSecondary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : context.c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.c.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          tab('Services', Icons.handshake_outlined,
              selected: true, onTap: () {}),
          tab('Products', Icons.shopping_bag_outlined,
              selected: false, onTap: _openProducts),
        ],
      ),
    );
  }

  void _openFilters() {
    bottomSheetCount.value++;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        initialPriceRange: _priceRange,
        initialRating: _selectedRating,
        initialLocation: _locationFilter,
        onApply: (range, rating, location) {
          setState(() {
            _priceRange = range;
            _selectedRating = rating;
            _locationFilter = location;
          });
        },
      ),
    ).whenComplete(() => bottomSheetCount.value--);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cats = _filteredCategories;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final profile = user?.clientProfile;
    final locationLabel = [profile?.preferredCity, profile?.preferredCountry]
        .where((e) => e != null && e.trim().isNotEmpty)
        .join(', ');
    return Scaffold(
      backgroundColor: context.c.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [context.c.primaryLight, context.c.background],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location row (real profile location; hidden if unset)
                      if (locationLabel.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              locationLabel,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primary, size: 16),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      Text(
                        'Find your vibe',
                        style: GoogleFonts.urbanist(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: context.c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Search + filter row
                      Row(
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
                                  hintText: 'Search categories...',
                                  hintStyle: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: context.c.textHint,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: context.c.textHint,
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
                          // Filter button
                          GestureDetector(
                            onTap: _openFilters,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFAB52F5),
                                        Color(0xFF7420D0)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.35),
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
                                if (_activeFilterCount > 0)
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: Container(
                                      width: 18,
                                      height: 18,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$_activeFilterCount',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Services / Products toggle ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(child: _buildModeToggle(context)),
          ),

          // ── Section title ───────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Browse Services by Category',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
            ),
          ),

          // ── Category grid ───────────────────────────────────────────────────
          cats.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        'No categories found',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: context.c.textHint,
                        ),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _CategoryImageCard(
                        category: cats[i],
                        onTap: () => context.push(
                          AppRoutes.categoryResultsPath(cats[i].slug),
                          extra: {'categoryName': cats[i].name},
                        ),
                      ),
                      childCount: cats.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Category image card ──────────────────────────────────────────────────────

class _CategoryImageCard extends StatelessWidget {
  const _CategoryImageCard({required this.category, required this.onTap});
  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            category.imageUrl != null
                ? Image.network(
                    category.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: context.c.primaryLight,
                      child: const Icon(Icons.image_outlined,
                          color: AppColors.primary, size: 40),
                    ),
                  )
                : Container(
                    color: context.c.primaryLight,
                    child: const Icon(Icons.image_outlined,
                        color: AppColors.primary, size: 40),
                  ),
            // Dark gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            // Category name bottom-left
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                category.name,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter bottom sheet ──────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.initialPriceRange,
    required this.initialRating,
    required this.initialLocation,
    required this.onApply,
  });

  final RangeValues initialPriceRange;
  final int? initialRating;
  final String initialLocation;
  final void Function(RangeValues, int?, String) onApply;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _price;
  int? _rating;
  late TextEditingController _locationCtrl;

  @override
  void initState() {
    super.initState();
    _price = widget.initialPriceRange;
    _rating = widget.initialRating;
    _locationCtrl = TextEditingController(text: widget.initialLocation);
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    super.dispose();
  }

  int get _count =>
      (_price.start > 0 || _price.end < 500000 ? 1 : 0) +
      (_rating != null ? 1 : 0) +
      (_locationCtrl.text.isNotEmpty ? 1 : 0);

  void _reset() {
    setState(() {
      _price = const RangeValues(0, 500000);
      _rating = null;
      _locationCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: context.c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _reset,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Filters',
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 24),

                // Price Range
                Text(
                  'Price Range',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                RangeSlider(
                  values: _price,
                  min: 0,
                  max: 500000,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  inactiveColor: context.c.primaryLight,
                  onChanged: (v) => setState(() => _price = v),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: context.c.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _fmtPrice(_price.start),
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '—',
                        style: GoogleFonts.urbanist(
                            color: context.c.textHint),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: context.c.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _fmtPrice(_price.end),
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Rating
                Text(
                  'Rating',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (i) {
                    final star = i + 1;
                    final active = _rating == star;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _rating = active ? null : star),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary
                                : context.c.surface,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : context.c.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: active
                                    ? Colors.white
                                    : AppColors.starColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$star',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: active
                                      ? Colors.white
                                      : context.c.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Location
                Text(
                  'Location',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: context.c.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.c.border),
                  ),
                  child: TextField(
                    controller: _locationCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter city or area',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: context.c.textHint,
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Apply button
                GestureDetector(
                  onTap: () {
                    widget.onApply(_price, _rating, _locationCtrl.text.trim());
                    Navigator.of(context).pop();
                  },
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
                        _count > 0
                            ? 'Apply Filters ($_count)'
                            : 'Apply Filters',
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
      ),
    );
  }
}
