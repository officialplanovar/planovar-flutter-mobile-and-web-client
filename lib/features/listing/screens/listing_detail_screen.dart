import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/mock/mock_listing_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final _listingService = MockListingService();
  ListingModel? _listing;
  bool _loading = true;
  bool _descExpanded = false;
  int _currentImageIndex = 0;
  final Set<int> _expandedPackages = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final listing = await _listingService.getListing(widget.listingId);
    setState(() {
      _listing = listing;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_listing == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(icon: Icons.list_alt_rounded, title: 'Listing not found'),
      );
    }

    final listing = _listing!;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: listing.media.isNotEmpty ? 300 : 0,
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
                flexibleSpace: listing.media.isNotEmpty
                    ? FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 300,
                                viewportFraction: 1,
                                enableInfiniteScroll: listing.media.length > 1,
                                onPageChanged: (i, _) => setState(() => _currentImageIndex = i),
                              ),
                              items: listing.media
                                  .map((url) => AppNetworkImage(url: url, width: double.infinity, fit: BoxFit.cover))
                                  .toList(),
                            ),
                            if (listing.media.length > 1)
                              Positioned(
                                bottom: 12,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: AnimatedSmoothIndicator(
                                    activeIndex: _currentImageIndex,
                                    count: listing.media.length,
                                    effect: const WormEffect(
                                      dotHeight: 6,
                                      dotWidth: 6,
                                      dotColor: Colors.white54,
                                      activeDotColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : null,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listing.title, style: AppTextStyles.heading3),
                      const SizedBox(height: 8),
                      if (listing.vendor != null)
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.vendorProfilePath(listing.vendorId)),
                          child: Row(
                            children: [
                              const Icon(Icons.storefront_outlined, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                listing.vendor!.businessName,
                                style: AppTextStyles.body2.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (listing.basePrice != null)
                        Text(
                          'From ${Formatters.currency(listing.basePrice!)}${listing.priceUnit != null ? ' / ${listing.priceUnit}' : ''}',
                          style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Quote only',
                            style: AppTextStyles.label.copyWith(color: AppColors.primary),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Text('About this service', style: AppTextStyles.heading4),
                      const SizedBox(height: 8),
                      if (listing.description != null) ...[
                        GestureDetector(
                          onTap: () => setState(() => _descExpanded = !_descExpanded),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.description!,
                                style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                                maxLines: _descExpanded ? null : 4,
                                overflow: _descExpanded ? null : TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _descExpanded ? 'Read less' : 'Read more',
                                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (listing.packages.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text('Packages', style: AppTextStyles.heading4),
                        const SizedBox(height: 12),
                        ...listing.packages.asMap().entries.map((entry) {
                          final i = entry.key;
                          final pkg = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                title: Row(
                                  children: [
                                    Expanded(child: Text(pkg.name, style: AppTextStyles.label)),
                                    Text(
                                      Formatters.currency(pkg.price),
                                      style: AppTextStyles.label.copyWith(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                subtitle: pkg.description != null
                                    ? Text(pkg.description!, style: AppTextStyles.caption)
                                    : null,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    if (expanded) {
                                      _expandedPackages.add(i);
                                    } else {
                                      _expandedPackages.remove(i);
                                    }
                                  });
                                },
                                children: pkg.features.map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(f, style: AppTextStyles.body2)),
                                    ],
                                  ),
                                )).toList(),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: GlossyButton(
                label: listing.pricingType == 'quote' ? 'Request a Quote' : 'Book Now',
                onPressed: () {
                  context.push(AppRoutes.newBooking, extra: {'listingId': listing.id});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
