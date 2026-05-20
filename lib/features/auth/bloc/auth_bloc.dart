import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/mock/mock_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final MockAuthService _authService;

  AuthBloc({MockAuthService? authService})
      : _authService = authService ?? MockAuthService(),
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthOtpVerifyRequested>(_onVerifyOtp);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthResetPasswordRequested>(_onResetPassword);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      try {
        final user = await _authService.getMe();
        emit(AuthAuthenticated(user: user));
      } catch (_) {
        emit(const AuthUnauthenticated());
      }
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _authService.signIn(email: event.email, password: event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authService.signUp(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
      );
      emit(AuthOtpSent(email: event.email, purpose: 'register'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(AuthOtpVerifyRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final ok = await _authService.verifyOtp(email: event.email, otp: event.otp);
      if (ok) {
        emit(AuthOtpVerified(email: event.email));
      } else {
        emit(const AuthError(message: 'Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onForgotPassword(AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authService.forgotPassword(email: event.email);
      emit(const AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResetPassword(AuthResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authService.resetPassword(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      );
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(const AuthUnauthenticated());
  }
}
