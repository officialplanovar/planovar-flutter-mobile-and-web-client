import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../core/api/api_client.dart';
import '../data/auth_remote_data_source.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final String purpose;

  const VerifyOtpScreen(
      {super.key, required this.email, required this.purpose});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String _otp = '';
  int _secondsRemaining = 59;
  Timer? _timer;

  bool get _isRegister => widget.purpose == 'register';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 59);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  /// Actually re-send the OTP (email-verification for register, else the
  /// password-reset code), then restart the cooldown.
  Future<void> _resend() async {
    _startTimer();
    try {
      await AuthRemoteDataSource(ApiClient()).sendOtp(
        email: widget.email,
        type: _isRegister ? 'email-verification' : 'forget-password',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new code has been sent')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not resend code: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _verify() {
    if (_otp.length != 6) return;
    if (_isRegister) {
      context.read<AuthBloc>().add(
            AuthOtpVerifyRequested(email: widget.email, otp: _otp),
          );
    } else {
      // Password reset: the OTP is a `forget-password` code, not an
      // email-verification one — it's validated by the reset-password call
      // itself. Carry it forward rather than consuming it via verify-email.
      context.push(AppRoutes.resetPassword,
          extra: {'email': widget.email, 'otp': _otp});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerified) {
          // Only the register flow verifies here; reset navigates in _verify().
          if (_isRegister) context.go(AppRoutes.phone);
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
              // Step 2/6 for register flow, step 3/4 for reset flow
              _isRegister
                  ? const AuthStepBar(step: 2, total: 6)
                  : const AuthStepBar(step: 3, total: 4),
              Expanded(
                child: SingleChildScrollView(
                  padding: pagePadding(context),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      AuthIllustration(
                        pngPath: 'assets/icons/auth_email_otp.png',
                        fallbackIcon: Icons.mark_email_unread_rounded,
                        bgColor: const Color(0xFFE9D5FF),
                        iconColor: AppColors.primary,
                        roundedSquare: true,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isRegister ? 'Verify your Email' : 'Confirm OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: context.c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _isRegister
                          ? Text(
                              "We've sent a 6 digit OTP to your email",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: context.c.textHint,
                                height: 1.55,
                              ),
                            )
                          : Text.rich(
                              TextSpan(
                                text: 'Enter the OTP Sent to ',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: context.c.textHint,
                                  height: 1.55,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.email,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                      const SizedBox(height: 36),
                      // Theme override: PinCodeTextField renders a hidden TextField
                      // under the boxes which inherits the app-wide filled/grey
                      // InputDecorationTheme — that painted a grey bar behind the
                      // row. Strip the fill locally (matches the vendor app).
                      Center(
                        child: SizedBox(
                          width: 320,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: false,
                                border: InputBorder.none,
                              ),
                            ),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              onChanged: (v) => setState(() => _otp = v),
                              onCompleted: (_) => _verify(),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(12),
                                fieldHeight: 56,
                                fieldWidth: 48,
                                borderWidth: 1.5,
                                activeFillColor: context.c.surface,
                                selectedFillColor: context.c.surface,
                                inactiveFillColor: context.c.surface,
                                inactiveColor: context.c.border,
                                selectedColor: AppColors.primary,
                                activeColor: AppColors.primary,
                              ),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              textStyle: GoogleFonts.urbanist(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: context.c.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _secondsRemaining > 0
                          ? Text(
                              'Resend in ${_secondsRemaining}s',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: context.c.textHint,
                              ),
                            )
                          : GestureDetector(
                              onTap: _resend,
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                      const SizedBox(height: 36),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return GlossyButton(
                            label: 'Proceed',
                            onPressed:
                                (_otp.length == 6 && state is! AuthLoading)
                                    ? _verify
                                    : null,
                            isLoading: state is AuthLoading,
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
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
