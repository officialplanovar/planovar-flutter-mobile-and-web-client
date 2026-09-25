import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  int _selectedOption = -1;
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final options = [
      t.cancelReasonPlans,
      t.cancelReasonBetter,
      t.cancelReasonNoResponse,
      t.cancelReasonMistake,
      t.cancelReasonOther,
    ];
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: context.c.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.c.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.cancelOrder,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                    ),
                    Text(
                      'EF-2026-0341 · Sugared Dreams Cakery',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: context.c.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── Body ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notice banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.c.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.notice,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t.cancelOrderNotice,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Cancellation reason
                  Text(
                    t.reasonForCancellation,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...options.asMap().entries.map((entry) {
                    final i = entry.key;
                    final opt = entry.value;
                    final selected = _selectedOption == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedOption = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: context.c.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : context.c.border,
                            width: selected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                opt,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: selected
                                      ? AppColors.primary
                                      : context.c.textPrimary,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check_circle_rounded,
                                  size: 18, color: AppColors.primary),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Describe the issue
                  Text(
                    t.describeIssue,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.c.border),
                    ),
                    child: TextField(
                      controller: _descCtrl,
                      minLines: 5,
                      maxLines: 7,
                      style: GoogleFonts.urbanist(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: t.provideAdditionalDetails,
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textHint,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Cancel Order button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          t.cancelOrder,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Message Vendor Instead
                  GestureDetector(
                    onTap: () => context.push(
                      AppRoutes.conversationDetail,
                      extra: {'conversationId': 'conv-01'},
                    ),
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Center(
                        child: Text(
                          t.messageVendorInstead,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
