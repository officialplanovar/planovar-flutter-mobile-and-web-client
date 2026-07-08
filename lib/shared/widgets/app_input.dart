import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class AppInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsets? contentPadding;

  const AppInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.inputFormatters,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = GoogleFonts.urbanist(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: context.c.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.c.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          style: baseStyle,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: context.c.textHint,
            ),
            errorText: errorText,
            helperText: helperText,
            helperStyle: GoogleFonts.urbanist(
              fontSize: 12,
              color: context.c.textSecondary,
            ),
            errorStyle: GoogleFonts.urbanist(
              fontSize: 12,
              color: AppColors.error,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefixText: prefixText,
            prefixStyle: baseStyle,
            filled: true,
            fillColor: enabled ? context.c.surfaceElevated : const Color(0xFFE8E8E8),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class AppTextArea extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const AppTextArea({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.minLines = 4,
    this.maxLines = 8,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      label: label,
      hint: hint,
      errorText: errorText,
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    );
  }
}
