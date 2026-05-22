import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCircleButton extends StatelessWidget {
  final Widget child;
  final double size;
  final double blur;
  final double backgroundOpacity;

  const GlassCircleButton({
    super.key,
    required this.child,
    this.size = 36,
    this.blur = 14,
    this.backgroundOpacity = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: backgroundOpacity),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 0.6,
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
