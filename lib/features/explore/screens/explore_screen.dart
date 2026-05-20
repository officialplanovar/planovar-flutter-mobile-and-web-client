import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_vendor_service.dart';
import '../../../core/mock/mock_category_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/widgets/vendor_card.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _vendorService = MockVendorService();
  final _categoryService = MockCategoryService();
  final _searchCtrl = TextEditingController();

  List<VendorModel> _vendors = [];
  List<CategoryModel> _categories = [];
  String _selectedCategory = '';
  String _selectedCity = '';
  double? _minRating;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _search();
  }

  Future<void> _loadCategories() async {
    final cats = await _categoryService.getCategories();
    setState(() => _categories = cats);
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await _vendorService.getVendors(
        categorySlug: _selectedCategory.isEmpty ? null : _selectedCategory,
        city: _selectedCity.isEmpty ? null : _selectedCity,
        minRating: _minRating,
        query: _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim(),
      );
      setState(() {
        _vendors = results;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Explore'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          _search();
                        },
                      )
                    : null,
              ),
              onChanged: (_) => _search(),
            ),
          ),
          // Filter row
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // Category filter
                if (_categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: DropdownButton<String>(
                      value: _selectedCategory.isEmpty ? null : _selectedCategory,
                      hint: const Text('Category'),
                      underline: const SizedBox(),
                      style: AppTextStyles.body2,
                      items: [
                        const DropdownMenuItem(value: '', child: Text('All Categories')),
                        ..._categories.map((c) => DropdownMenuItem(value: c.slug, child: Text(c.name))),
                      ],
                      onChanged: (v) {
                        setState(() => _selectedCategory = v ?? '');
                        _search();
                      },
                    ),
                  ),
                // City filter
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton<String>(
                    value: _selectedCity.isEmpty ? null : _selectedCity,
                    hint: const Text('City'),
                    underline: const SizedBox(),
                    style: AppTextStyles.body2,
                    items: const [
                      DropdownMenuItem(value: '', child: Text('All Cities')),
                      DropdownMenuItem(value: 'Lagos', child: Text('Lagos')),
                      DropdownMenuItem(value: 'Abuja', child: Text('Abuja')),
                      DropdownMenuItem(value: 'Port Harcourt', child: Text('Port Harcourt')),
                    ],
                    onChanged: (v) {
                      setState(() => _selectedCity = v ?? '');
                      _search();
                    },
                  ),
                ),
                // Rating filter
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DropdownButton<double?>(
                    value: _minRating,
                    hint: const Text('Rating'),
                    underline: const SizedBox(),
                    style: AppTextStyles.body2,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Any Rating')),
                      DropdownMenuItem(value: 4.5, child: Text('4.5+ ⭐')),
                      DropdownMenuItem(value: 4.0, child: Text('4.0+ ⭐')),
                      DropdownMenuItem(value: 3.5, child: Text('3.5+ ⭐')),
                    ],
                    onChanged: (v) {
                      setState(() => _minRating = v);
                      _search();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Results
          Expanded(
            child: _loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: ShimmerList(itemCount: 5, itemHeight: 120),
                  )
                : _error != null
                    ? ErrorState(
                        message: _error!,
                        onRetry: _search,
                      )
                    : _vendors.isEmpty
                        ? EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No vendors found',
                            subtitle: 'Try adjusting your filters or search term.',
                            buttonLabel: 'Clear Filters',
                            onButtonTap: () {
                              setState(() {
                                _selectedCategory = '';
                                _selectedCity = '';
                                _minRating = null;
                                _searchCtrl.clear();
                              });
                              _search();
                            },
                          )
                        : ListView.builder(
                            itemCount: _vendors.length,
                            itemBuilder: (context, i) {
                              return VendorListCard(
                                vendor: _vendors[i],
                                onTap: () => context.push(AppRoutes.vendorProfilePath(_vendors[i].id)),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
