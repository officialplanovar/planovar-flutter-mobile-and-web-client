import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';
import 'create_event_step1_screen.dart' show EventStepHeader;

class CreateEventStep3Screen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const CreateEventStep3Screen({super.key, required this.eventData});

  @override
  State<CreateEventStep3Screen> createState() => _CreateEventStep3ScreenState();
}

class _CreateEventStep3ScreenState extends State<CreateEventStep3Screen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final categories = MockData.categories
        .where((c) => c.slug != 'products')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          EventStepHeader(
            currentStep: 3,
            onBack: () => context.pop(),
            titlePrefix: 'Event ',
            titleHighlight: 'Categories',
            subtitle: 'Step Three, Select your Preferences',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What services do you need for your event?',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((cat) {
                      final selected = _selected.contains(cat.id);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _selected.remove(cat.id);
                          } else {
                            _selected.add(cat.id);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFE5E7EB),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cat.name,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.primary
                                      : const Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                selected ? Icons.close : Icons.add,
                                size: 14,
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: GlossyButton(
              label: 'Next',
              onPressed: _selected.isNotEmpty
                  ? () {
                      final selectedCategories = MockData.categories
                          .where((c) => _selected.contains(c.id))
                          .map((c) => c.name)
                          .toList();
                      context.push(AppRoutes.createEventStep4, extra: {
                        ...widget.eventData,
                        'categories': selectedCategories,
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
