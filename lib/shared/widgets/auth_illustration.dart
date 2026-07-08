import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthIllustration extends StatelessWidget {
  final String pngPath;
  final IconData fallbackIcon;
  /// Null → theme-aware `context.c.primaryLight` (adapts to light/dark).
  final Color? bgColor;
  final Color iconColor;
  final double size;
  final bool roundedSquare;

  const AuthIllustration({
    super.key,
    required this.pngPath,
    required this.fallbackIcon,
    this.bgColor,
    this.iconColor = AppColors.primary,
    this.size = 120,
    this.roundedSquare = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = roundedSquare
        ? BorderRadius.circular(size * 0.24)
        : BorderRadius.circular(size / 2);
    final bg = bgColor ?? context.c.primaryLight;

    return Image.asset(
      pngPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: Icon(fallbackIcon, size: size * 0.46, color: iconColor),
      ),
    );
  }
}
