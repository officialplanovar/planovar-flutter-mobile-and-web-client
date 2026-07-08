import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles whose color must adapt to light/dark are exposed as
/// `context`-methods (e.g. `AppTextStyles.heading4(context)`) so the color is
/// resolved from the theme-aware [AppPalette] at build time. [button] keeps a
/// fixed white since it sits on the brand-colored primary button.
class AppTextStyles {
  static TextStyle heading1(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: context.c.textPrimary,
      );

  static TextStyle heading2(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: context.c.textPrimary,
      );

  static TextStyle heading3(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: context.c.textPrimary,
      );

  static TextStyle heading4(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: context.c.textPrimary,
      );

  static TextStyle body1(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: context.c.textPrimary,
      );

  static TextStyle body2(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: context.c.textPrimary,
      );

  static TextStyle caption(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: context.c.textSecondary,
      );

  static TextStyle label(BuildContext context) => GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.c.textPrimary,
      );

  static TextStyle button = GoogleFonts.urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
