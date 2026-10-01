import 'package:flutter/material.dart';
import '../../../core/api/api_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).agreeTermsError)),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignUpRequested(
            fullName: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: '',
          ));
    }
  }

  Future<void> _googleSignIn() async {
    try {
      await AuthRepository().signInWithGoogle();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(humanizeError(e)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          context.push(AppRoutes.verifyOtp,
              extra: {'email': state.email, 'purpose': 'register'});
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: context.c.surface,
        body: SafeArea(
          child: Column(
            children: [
              const AuthStepBar(step: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: pagePadding(context),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 28),
                        Center(
                          child: AuthIllustration(
                            pngPath: 'assets/icons/auth_register.png',
                            fallbackIcon: Icons.person_add_rounded,
                            bgColor: context.c.primaryLight,
                            iconColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: t.registerHello,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: context.c.textPrimary,
                                  ),
                                ),
                                const TextSpan(
                                  text: '👋',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            t.registerWelcome,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: context.c.textHint,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _FieldLabel(t.fullName),
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            hintText: t.fullNameHint,
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? t.fullNameRequired : null,
                        ),
                        const SizedBox(height: 20),
                        _FieldLabel(t.emailAddress),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: t.emailHint,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return t.emailRequired;
                            if (!v.contains('@')) return t.emailInvalid;
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GlossyButton(
                              label: t.proceed,
                              onPressed: state is AuthLoading ? null : _submit,
                              isLoading: state is AuthLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Terms checkbox
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreed,
                                onChanged: (v) =>
                                    setState(() => _agreed = v ?? false),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _agreed = !_agreed),
                                child: Text.rich(
                                  TextSpan(
                                    text: t.agreeTermsPrefix,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: context.c.textSecondary,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: t.termsConditions,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(text: t.andConnector),
                                      TextSpan(
                                        text: t.privacyPolicy,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                t.orLabel,
                                style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: context.c.textHint),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _googleSignIn,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/google_logo.svg',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                t.signUpWithGoogle,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: context.c.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Text.rich(
                              TextSpan(
                                text: t.alreadyHaveAccount,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: context.c.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: t.signInLink,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: context.c.textPrimary,
        ),
      ),
    );
  }
}
