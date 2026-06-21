import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authService;

  AuthBloc({AuthRepository? authRepository})
      : _authService = authRepository ?? AuthRepository(),
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
    // Source of truth is the persisted bearer token / session — not just the
    // flag (which earlier was only set on the login screen, never on register).
    final prefs = await SharedPreferences.getInstance();
    try {
      final user = await _authService.getMe();
      await prefs.setBool('isLoggedIn', true);
      emit(AuthAuthenticated(user: user));
    } catch (_) {
      await prefs.setBool('isLoggedIn', false);
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
        // Verified = authenticated (token is stored); persist so the session
        // survives restarts even for the register→verify path.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
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
    try {
      await _authService.signOut();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    emit(const AuthUnauthenticated());
  }
}
