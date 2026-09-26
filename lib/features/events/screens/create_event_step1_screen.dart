import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../l10n/app_localizations.dart';

class CreateEventStep1Screen extends StatefulWidget {
  /// When launched from a listing's "Add to Event" sheet, these carry the
  /// listing + its vendor so the new event adopts them on creation.
  final String? fromListingId;
  final String? fromVendorId;

  const CreateEventStep1Screen({
    super.key,
    this.fromListingId,
    this.fromVendorId,
  });

  @override
  State<CreateEventStep1Screen> createState() => _CreateEventStep1ScreenState();
}

class _CreateEventStep1ScreenState extends State<CreateEventStep1Screen> {
  String? _selectedType;
  final _otherCtrl = TextEditingController();

  // UI label ↔ API EventType enum value. OTHER is intentionally not offered as
  // a normal choice — it is the fallback the API applies when no `type` is sent.
  static const _types = [
    (label: 'Wedding', emoji: '💍', value: 'WEDDING'),
    (label: 'Funeral', emoji: '🕊️', value: 'FUNERAL'),
    (label: 'Birthday', emoji: '🎂', value: 'BIRTHDAY'),
    (label: 'Corporate', emoji: '💼', value: 'CORPORATE'),
    (label: 'Social party', emoji: '🎉', value: 'SOCIAL_PARTY'),
  ];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  String _typeLabel(AppLocalizations loc, String value) {
    switch (value) {
      case 'Wedding':
        return loc.eventTypeWedding;
      case 'Funeral':
        return loc.eventTypeFuneral;
      case 'Birthday':
        return loc.eventTypeBirthday;
      case 'Corporate':
        return loc.eventTypeCorporate;
      case 'Social party':
        return loc.eventTypeSocialParty;
      default:
        return value;
    }
  }

  void _proceed() {
    final isOther = _selectedType == 'Other';
    // Free-text display label for the event (used for the title/description).
    final displayType = isOther && _otherCtrl.text.trim().isNotEmpty
        ? _otherCtrl.text.trim()
        : (_selectedType ?? '');
    // Map the picked label to its API EventType enum value. Omitted when the
    // "Other"/free-text path is used or nothing is picked (API defaults it).
    String? enumType;
    for (final ty in _types) {
      if (ty.label == _selectedType) {
        enumType = ty.value;
        break;
      }
    }
    context.push(AppRoutes.createEventStep2, extra: {
      'eventType': displayType,
      if (enumType != null) 'type': enumType,
      if (widget.fromListingId != null) 'fromListingId': widget.fromListingId,
      if (widget.fromVendorId != null) 'fromVendorId': widget.fromVendorId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          EventStepHeader(
            currentStep: 1,
            onBack: () => context.pop(),
            titlePrefix: loc.createAnPrefix,
            titleHighlight: loc.eventChip,
            subtitle: loc.step1Subtitle,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.eventType,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
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
                    children: _types.map((ty) {
                      final selected = _selectedType == ty.label;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = ty.label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: selected
                                ? context.c.primaryLight
                                : context.c.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : context.c.border,
                              width: selected ? 1.8 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(ty.emoji,
                                  style: const TextStyle(fontSize: 42)),
                              const SizedBox(height: 10),
                              Text(
                                _typeLabel(loc, ty.label),
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? AppColors.primary
                                      : context.c.textSecondary,
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
                    loc.otherLabel,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => setState(() => _selectedType = 'Other'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.c.divider,
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
                          color: context.c.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: loc.pleaseSpecify,
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
              label: loc.proceed,
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
      color: context.c.primaryLight,
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
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: context.c.textPrimary,
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
                          color: context.c.textPrimary,
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
                        color: context.c.textSecondary,
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
