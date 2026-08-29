import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/locale/locale_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Language preference. English + French are translated and switch the app live
/// via LocaleCubit; the Nigerian languages are listed for when their
/// translations ship.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    ('en', 'English'),
    ('fr', 'Français'),
    ('pcm', 'Nigerian Pidgin'),
    ('ha', 'Hausa'),
    ('yo', 'Yoruba'),
    ('ig', 'Igbo'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final current = context.watch<LocaleCubit>().state.languageCode;
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.c.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(t.language,
            style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(t.languageIntro,
              style: GoogleFonts.urbanist(
                  fontSize: 13, color: context.c.textSecondary, height: 1.5)),
          const SizedBox(height: 16),
          for (final (code, label) in _languages)
            _row(context, t, code, label, current),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, AppLocalizations t, String code,
      String label, String current) {
    final available = LocaleCubit.supported.contains(code);
    final selected = current == code;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (available) {
          context.read<LocaleCubit>().setLocale(code);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label — ${t.comingSoon}')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? AppColors.primary : context.c.border,
              width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: available
                          ? context.c.textPrimary
                          : context.c.textHint)),
            ),
            if (!available)
              Text(t.comingSoon,
                  style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.c.textHint))
            else if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}
