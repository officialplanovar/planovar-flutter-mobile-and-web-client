import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

enum ButtonVariant { primary, secondary, ghost }
enum ButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool iconTrailing;
  final bool loading;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.loading = false,
    this.width,
  });

  const AppButton.primary(
    String this.label, {
    super.key,
    required this.onTap,
    this.size = ButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.loading = false,
    this.width,
  }) : variant = ButtonVariant.primary;

  const AppButton.secondary(
    String this.label, {
    super.key,
    required this.onTap,
    this.size = ButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.loading = false,
    this.width,
  }) : variant = ButtonVariant.secondary;

  const AppButton.ghost(
    String this.label, {
    super.key,
    required this.onTap,
    this.size = ButtonSize.md,
    this.icon,
    this.iconTrailing = false,
    this.loading = false,
    this.width,
  }) : variant = ButtonVariant.ghost;

  double get _height {
    switch (size) {
      case ButtonSize.sm:
        return 40;
      case ButtonSize.md:
        return 52;
      case ButtonSize.lg:
        return 58;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.sm:
        return 13;
      case ButtonSize.md:
        return 15;
      case ButtonSize.lg:
        return 17;
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null || loading;

    final Color bgColor;
    final Color fgColor;
    final Border? border;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = disabled ? AppColors.primary.withValues(alpha: 0.4) : AppColors.primary;
        fgColor = Colors.white;
        border = null;
        break;
      case ButtonVariant.secondary:
        bgColor = Colors.transparent;
        fgColor = disabled ? AppColors.primary.withValues(alpha: 0.4) : AppColors.primary;
        border = Border.all(
          color: disabled ? AppColors.primary.withValues(alpha: 0.4) : AppColors.primary,
          width: 1.5,
        );
        break;
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = disabled ? AppColors.textSecondary : AppColors.primary;
        border = null;
        break;
    }

    Widget content;
    if (loading) {
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    } else {
      final textWidget = Text(
        label ?? '',
        style: GoogleFonts.urbanist(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      );

      if (icon != null) {
        final iconColored = IconTheme(
          data: IconThemeData(color: fgColor, size: _fontSize + 4),
          child: icon!,
        );
        content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconTrailing
              ? [textWidget, const SizedBox(width: 8), iconColored]
              : [iconColored, const SizedBox(width: 8), textWidget],
        );
      } else {
        content = textWidget;
      }
    }

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width ?? double.infinity,
        height: _height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: border,
        ),
        child: Center(child: content),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool bordered;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.backgroundColor,
    this.iconColor,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.divider,
          shape: BoxShape.circle,
          border: bordered
              ? Border.all(color: AppColors.border, width: 1)
              : null,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              color: iconColor ?? AppColors.textPrimary,
              size: size * 0.45,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
