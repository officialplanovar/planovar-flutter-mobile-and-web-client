import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

enum TextVariant {
  display,
  h1,
  h2,
  h3,
  h4,
  body,
  bodySmall,
  caption,
  label,
  overline,
}

class AppText extends StatelessWidget {
  final String text;
  final TextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool italic;

  const AppText(
    this.text, {
    super.key,
    this.variant = TextVariant.body,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  });

  const AppText.display(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.display;

  const AppText.h1(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.h1;

  const AppText.h2(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.h2;

  const AppText.h3(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.h3;

  const AppText.h4(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.h4;

  const AppText.body(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.body;

  const AppText.bodySmall(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.bodySmall;

  const AppText.caption(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.caption;

  const AppText.label(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.label;

  const AppText.overline(
    this.text, {
    super.key,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.italic = false,
  }) : variant = TextVariant.overline;

  static const _defaultColor = AppColors.textPrimary;

  static _Spec _specFor(TextVariant v) {
    switch (v) {
      case TextVariant.display:
        return const _Spec(32, FontWeight.w700);
      case TextVariant.h1:
        return const _Spec(26, FontWeight.w700);
      case TextVariant.h2:
        return const _Spec(22, FontWeight.w700);
      case TextVariant.h3:
        return const _Spec(18, FontWeight.w600);
      case TextVariant.h4:
        return const _Spec(16, FontWeight.w600);
      case TextVariant.body:
        return const _Spec(15, FontWeight.w400);
      case TextVariant.bodySmall:
        return const _Spec(13, FontWeight.w400);
      case TextVariant.caption:
        return const _Spec(12, FontWeight.w400);
      case TextVariant.label:
        return const _Spec(11, FontWeight.w600);
      case TextVariant.overline:
        return const _Spec(10, FontWeight.w500);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = _specFor(variant);
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.urbanist(
        fontSize: fontSize ?? spec.size,
        fontWeight: fontWeight ?? spec.weight,
        color: color ?? _defaultColor,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        height: 1.3,
      ),
    );
  }
}

class _Spec {
  final double size;
  final FontWeight weight;
  const _Spec(this.size, this.weight);
}
