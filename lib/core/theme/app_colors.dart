import 'package:flutter/material.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF9139E6);
  static const primaryLight = Color(0xFFEDE0FA);
  static const primaryDark = Color(0xFF6A1DB5);
  static const accent = Color(0xFFFFB800);
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const starColor = Color(0xFFFBBF24);

  // Light mode
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);
  static const backgroundLight = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFF3F4F6);

  // Dark mode
  static const darkBackground = Color(0xFF0F0F14);
  static const darkSurface = Color(0xFF1A1A24);
  static const darkSurfaceElevated = Color(0xFF242433);
  static const darkBorder = Color(0xFF2E2E3E);
  static const darkDivider = Color(0xFF1E1E2E);
  static const darkTextPrimary = Color(0xFFF1F1F5);
  static const darkTextSecondary = Color(0xFF9CA3AF);
  static const darkTextHint = Color(0xFF6B7280);
  static const darkPrimaryLight = Color(0xFF2A1A40); // primary tint for dark surfaces
}

/// Theme-aware palette. Resolve *structural* colors from `context.c` so they
/// adapt to light/dark, e.g. `color: context.c.surface`. Brand colors
/// (primary, success, error, starColor, …) stay constant via [AppColors] and
/// should NOT go through this palette.
class AppPalette {
  final bool dark;
  const AppPalette(this.dark);

  /// Scaffold / page background.
  Color get background =>
      dark ? AppColors.darkBackground : AppColors.backgroundLight;

  /// Cards, sheets, app bars — anything that was previously plain white.
  Color get surface => dark ? AppColors.darkSurface : AppColors.surface;

  /// Slightly raised fill (input fields, muted chips).
  Color get surfaceElevated =>
      dark ? AppColors.darkSurfaceElevated : const Color(0xFFF2F2F2);

  Color get textPrimary =>
      dark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get textSecondary =>
      dark ? AppColors.darkTextSecondary : AppColors.textSecondary;
  Color get textHint => dark ? AppColors.darkTextHint : AppColors.textHint;

  Color get border => dark ? AppColors.darkBorder : AppColors.border;
  Color get divider => dark ? AppColors.darkDivider : AppColors.divider;

  /// Tinted brand-light surface (selected chips, icon squares).
  Color get primaryLight =>
      dark ? AppColors.darkPrimaryLight : AppColors.primaryLight;
}

extension AppColorsContext on BuildContext {
  /// Theme-aware palette: `context.c.surface`, `context.c.textPrimary`, …
  AppPalette get c =>
      AppPalette(Theme.of(this).brightness == Brightness.dark);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
