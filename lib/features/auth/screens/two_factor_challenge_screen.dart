import 'package:flutter/material.dart';
import '../../../core/api/api_error.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Shown after a correct password when the account has 2FA enabled. Collects a
/// TOTP code and completes the sign-in via AuthBloc.
class TwoFactorChallengeScreen extends StatefulWidget {
  const TwoFactorChallengeScreen({super.key});

  @override
  State<TwoFactorChallengeScreen> createState() =>
      _TwoFactorChallengeScreenState();
}

class _TwoFactorChallengeScreenState extends State<TwoFactorChallengeScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _codeCtrl.text.trim();
    if (code.length < 6) return;
    context.read<AuthBloc>().add(AuthTwoFactorSubmitted(code: code));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.homeFeed);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(humanizeError(state.message)),
            backgroundColor: AppColors.error,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: context.c.surface,
        appBar: AppBar(
          backgroundColor: context.c.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: context.c.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                t.tfaChallengeTitle,
                style: GoogleFonts.urbanist(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.tfaChallengeSubtitle,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 8,
                  color: context.c.textPrimary,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '••••••',
                  filled: true,
                  fillColor: context.c.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.c.border),
                  ),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 28),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return GlossyButton(
                    label: t.tfaVerify,
                    onPressed: loading ? null : _submit,
                    isLoading: loading,
                    height: 52,
                    radius: 14,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
