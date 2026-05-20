import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_category_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/widgets/network_image_widget.dart';

class CategoryPreferenceScreen extends StatefulWidget {
  const CategoryPreferenceScreen({super.key});

  @override
  State<CategoryPreferenceScreen> createState() =>
      _CategoryPreferenceScreenState();
}

class _CategoryPreferenceScreenState extends State<CategoryPreferenceScreen> {
  final _categoryService = MockCategoryService();
  List<CategoryModel> _categories = [];
  final Set<String> _selected = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await _categoryService.getCategories();
    setState(() {
      _categories = cats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthStepBar(step: 6),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let us know what events\nyou\'d want',
                            style: GoogleFonts.urbanist(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1A1A),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We'll personalize your recommendations and search results.",
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: const Color(0xFF9CA3AF),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              final isSelected = _selected.contains(cat.id);
                              return GestureDetector(
                                onTap: () => setState(() {
                                  if (isSelected) {
                                    _selected.remove(cat.id);
                                  } else {
                                    _selected.add(cat.id);
                                  }
                                }),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      AppNetworkImage(
                                          url: cat.imageUrl, fit: BoxFit.cover),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withValues(alpha: 0.1),
                                              Colors.black.withValues(alpha: 0.55),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Container(
                                          color: AppColors.primary
                                              .withValues(alpha: 0.45),
                                        ),
                                      if (isSelected)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                                Icons.check_rounded,
                                                size: 14,
                                                color: AppColors.primary),
                                          ),
                                        ),
                                      Positioned(
                                        left: 8,
                                        bottom: 8,
                                        right: 8,
                                        child: Text(
                                          cat.name,
                                          style: GoogleFonts.urbanist(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                    child: GlossyButton(
                      label: 'Proceed',
                      onPressed: _selected.isNotEmpty
                          ? () => context.go(AppRoutes.homeFeed)
                          : null,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
