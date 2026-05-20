import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';

class AuthIllustration extends StatefulWidget {
  final String svgPath;
  final IconData fallbackIcon;
  final Color bgColor;
  final Color iconColor;
  final double size;
  final bool roundedSquare;

  const AuthIllustration({
    super.key,
    required this.svgPath,
    required this.fallbackIcon,
    this.bgColor = AppColors.primaryLight,
    this.iconColor = AppColors.primary,
    this.size = 120,
    this.roundedSquare = false,
  });

  @override
  State<AuthIllustration> createState() => _AuthIllustrationState();
}

class _AuthIllustrationState extends State<AuthIllustration> {
  bool _svgReady = false;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.svgPath).then((_) {
      if (mounted) setState(() => _svgReady = true);
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    if (_svgReady) {
      return SvgPicture.asset(widget.svgPath, width: widget.size, height: widget.size);
    }
    final radius = widget.roundedSquare
        ? BorderRadius.circular(widget.size * 0.24)
        : BorderRadius.circular(widget.size / 2);
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(color: widget.bgColor, borderRadius: radius),
      child: Icon(widget.fallbackIcon, size: widget.size * 0.46, color: widget.iconColor),
    );
  }
}
