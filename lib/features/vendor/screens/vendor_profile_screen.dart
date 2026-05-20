import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_vendor_service.dart';
import '../../../core/mock/mock_listing_service.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/review_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class VendorProfileScreen extends StatefulWidget {
  final String vendorId;

  const VendorProfileScreen({super.key, required this.vendorId});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen>
    with SingleTickerProviderStateMixin {
  final _vendorService = MockVendorService();
  final _listingService = MockListingService();

  VendorModel? _vendor;
  List<ListingModel> _listings = [];
  List<ReviewModel> _reviews = [];
  bool _loading = true;
  bool _isFavourite = false;
  bool _bioExpanded = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final vendor = await _vendorService.getVendor(widget.vendorId);
    final listings = await _listingService.getVendorListings(widget.vendorId);
    final reviews = MockData.reviews.where((r) => r.vendorId == widget.vendorId).toList();
    final isFav = _vendorService.isFavourite(widget.vendorId);
    setState(() {
      _vendor = vendor;
      _listings = listings;
      _reviews = reviews;
      _isFavourite = isFav;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_vendor == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.storefront_outlined,
          title: 'Vendor not found',
        ),
      );
    }

    final vendor = _vendor!;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                  ),
                  child: const Icon(Icons.share_outlined, size: 18),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                  ),
                  child: Icon(
                    _isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 18,
                    color: _isFavourite ? AppColors.error : null,
                  ),
                ),
                onPressed: () async {
                  final result = await _vendorService.toggleFavourite(widget.vendorId);
                  setState(() => _isFavourite = result);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(url: vendor.coverUrl, fit: BoxFit.cover),
            ),
          ),
        ],
        body: Column(
          children: [
            // Vendor info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(vendor.businessName, style: AppTextStyles.heading3),
                      ),
                      if (vendor.isVerified)
                        const Row(
                          children: [
                            Icon(Icons.verified_rounded, color: AppColors.primary, size: 18),
                            SizedBox(width: 4),
                            Text('Verified', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StatusChip(status: vendor.subscriptionTier),
                      const SizedBox(width: 12),
                      if (vendor.location != null) ...[
                        const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Text(vendor.location!, style: AppTextStyles.caption),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRating(rating: vendor.ratingAvg, reviewCount: vendor.reviewCount, starSize: 16),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _tabController.animateTo(1),
                        child: Text(
                          'See reviews',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (vendor.description != null) ...[
                    GestureDetector(
                      onTap: () => setState(() => _bioExpanded = !_bioExpanded),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vendor.description!,
                            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                            maxLines: _bioExpanded ? null : 3,
                            overflow: _bioExpanded ? null : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _bioExpanded ? 'Read less' : 'Read more',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Listings'),
                      Tab(text: 'Reviews'),
                    ],
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Listings
                  _listings.isEmpty
                      ? const EmptyState(
                          icon: Icons.list_alt_rounded,
                          title: 'No listings yet',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _listings.length,
                          itemBuilder: (context, i) {
                            return _ListingCard(
                              listing: _listings[i],
                              onTap: () => context.push(AppRoutes.listingDetailPath(_listings[i].id)),
                            );
                          },
                        ),
                  // Reviews
                  _reviews.isEmpty
                      ? const EmptyState(
                          icon: Icons.rate_review_outlined,
                          title: 'No reviews yet',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reviews.length,
                          itemBuilder: (context, i) {
                            return _ReviewCard(review: _reviews[i]);
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback? onTap;

  const _ListingCard({required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            if (listing.media.isNotEmpty)
              AppNetworkImage(
                url: listing.media.first,
                width: 80,
                height: 80,
                borderRadius: BorderRadius.circular(10),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title, style: AppTextStyles.label),
                  const SizedBox(height: 4),
                  if (listing.basePrice != null)
                    Text(
                      'From ${Formatters.currency(listing.basePrice!)}',
                      style: AppTextStyles.body2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                    )
                  else
                    Text('Quote only', style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '${listing.packages.length} package${listing.packages.length == 1 ? '' : 's'}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StarRating(rating: review.rating, showCount: false, starSize: 14),
              const SizedBox(width: 8),
              Text(Formatters.date(review.createdAt), style: AppTextStyles.caption),
            ],
          ),
          if (review.title != null) ...[
            const SizedBox(height: 8),
            Text(review.title!, style: AppTextStyles.label),
          ],
          if (review.body != null) ...[
            const SizedBox(height: 4),
            Text(
              review.body!,
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
