import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

class CreateEventStep1Screen extends StatefulWidget {
  const CreateEventStep1Screen({super.key});

  @override
  State<CreateEventStep1Screen> createState() => _CreateEventStep1ScreenState();
}

class _CreateEventStep1ScreenState extends State<CreateEventStep1Screen> {
  String? _selectedType;
  final _otherCtrl = TextEditingController();

  static const _types = [
    (label: 'Wedding', emoji: '💍'),
    (label: 'Birthday', emoji: '🎂'),
    (label: 'Corporate', emoji: '💼'),
    (label: 'Graduation', emoji: '🎓'),
  ];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  void _proceed() {
    final type = _selectedType == 'Other' && _otherCtrl.text.isNotEmpty
        ? _otherCtrl.text.trim()
        : (_selectedType ?? '');
    context.push(AppRoutes.createEventStep2, extra: {'eventType': type});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          EventStepHeader(
            currentStep: 1,
            onBack: () => context.pop(),
            titlePrefix: 'Create an ',
            titleHighlight: 'Event',
            subtitle: 'Step one, Choose the Event Type',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Type',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // 2×2 grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: _types.map((t) {
                      final selected = _selectedType == t.label;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = t.label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primaryLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFE5E7EB),
                              width: selected ? 1.8 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(t.emoji,
                                  style: const TextStyle(fontSize: 42)),
                              const SizedBox(height: 10),
                              Text(
                                t.label,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.primary
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Other
                  Text(
                    'Other',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => _selectedType = 'Other'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedType == 'Other'
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _otherCtrl,
                        onChanged: (_) => setState(() {}),
                        onTap: () =>
                            setState(() => _selectedType = 'Other'),
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: const Color(0xFF1A1A2E),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Please Specify',
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: const Color(0xFFB0B7C3),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: GlossyButton(
              label: 'Proceed',
              onPressed: _proceed,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared step header ───────────────────────────────────────────────────────

class EventStepHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;
  final String titlePrefix;
  final String titleHighlight;
  final String subtitle;

  const EventStepHeader({
    super.key,
    required this.currentStep,
    required this.onBack,
    required this.titlePrefix,
    required this.titleHighlight,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.primaryLight,
      padding: EdgeInsets.only(
          top: top + 12, bottom: 22, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Step progress bars ─────────────────────────────────────────
          Row(
            children: List.generate(4, (i) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: i < currentStep
                        ? AppColors.primary
                        : const Color(0xFFDDD6FE),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // ── Back + title ───────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, right: 12),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                        ),
                        children: [
                          TextSpan(text: titlePrefix),
                          TextSpan(
                            text: titleHighlight,
                            style: GoogleFonts.urbanist(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
