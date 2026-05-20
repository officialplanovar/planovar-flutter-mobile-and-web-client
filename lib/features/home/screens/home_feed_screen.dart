import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_vendor_service.dart';
import '../../../core/mock/mock_category_service.dart';
import '../../../core/mock/mock_notification_service.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/widgets/vendor_card.dart';
import '../../../shared/widgets/category_card.dart';
import '../../../shared/widgets/shimmer_list.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _vendorService = MockVendorService();
  final _categoryService = MockCategoryService();
  final _notifService = MockNotificationService();

  List<VendorModel> _vendors = [];
  List<CategoryModel> _categories = [];
  bool _loading = true;

  final _user = MockData.currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final vendors = await _vendorService.getVendors();
    final cats = await _categoryService.getCategories();
    setState(() {
      _vendors = vendors;
      _categories = cats;
      _loading = false;
    });
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_greeting, ${_user.firstName} 👋',
                        style: AppTextStyles.heading4,
                      ),
                      Text('Find your perfect vendor', style: AppTextStyles.caption),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () => context.push(AppRoutes.notifications),
                      ),
                      if (_notifService.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.explore),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: AppColors.textHint),
                            const SizedBox(width: 10),
                            Text('Search vendors, categories...', style: AppTextStyles.body2.copyWith(color: AppColors.textHint)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category chips
                  SizedBox(
                    height: 40,
                    child: _loading
                        ? null
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _categories.length,
                            itemBuilder: (context, i) {
                              final cat = _categories[i];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(cat.name),
                                  selected: false,
                                  onSelected: (_) => context.go(AppRoutes.explore),
                                  backgroundColor: AppColors.divider,
                                  labelStyle: AppTextStyles.caption,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 24),
                  // Recommended vendors
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recommended for you', style: AppTextStyles.heading4),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.explore),
                          child: Text('See all', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ShimmerCard(height: 220),
                    )
                  else
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _vendors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          return VendorCard(
                            vendor: _vendors[i],
                            onTap: () => context.push(AppRoutes.vendorProfilePath(_vendors[i].id)),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Browse by category
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Browse by category', style: AppTextStyles.heading4),
                  ),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ShimmerGrid(itemCount: 6),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, i) {
                          return CategoryCard(
                            category: _categories[i],
                            onTap: () => context.go(AppRoutes.explore),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
