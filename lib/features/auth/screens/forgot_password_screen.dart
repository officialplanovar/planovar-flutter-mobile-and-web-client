import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context
          .read<AuthBloc>()
          .add(AuthForgotPasswordRequested(email: _emailCtrl.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          context.push(AppRoutes.verifyOtp, extra: {
            'email': _emailCtrl.text.trim(),
            'purpose': 'reset',
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const AuthStepBar(step: 2, total: 4),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 28),
                        Center(
                          child: AuthIllustration(
                            svgPath: 'assets/icons/auth_forgot_password.svg',
                            fallbackIcon: Icons.lock_reset_rounded,
                            bgColor: const Color(0xFFBBDEFB),
                            iconColor: const Color(0xFF1565C0),
                            roundedSquare: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'Forgot Password?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Enter the email used in registration, we will\nsend a 6 digit OTP code for verification',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: const Color(0xFF9CA3AF),
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        _FieldLabel('Email Address'),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Email address',
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Email is required';
                            if (!v.contains('@'))
                              return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 36),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GlossyButton(
                              label: 'Proceed',
                              onPressed:
                                  state is AuthLoading ? null : _submit,
                              isLoading: state is AuthLoading,
                            );
                          },
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
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
