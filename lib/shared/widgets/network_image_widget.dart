import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Shimmer.fromColors(
      baseColor: context.c.border,
      highlightColor: context.c.divider,
      child: Container(color: Colors.white, width: width, height: height),
    );

    if (url == null || url!.isEmpty) {
      return errorWidget ??
          Container(
            width: width,
            height: height,
            color: context.c.divider,
            child: Icon(Icons.image_outlined, color: context.c.textHint),
          );
    }

    final image = CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => placeholder,
      errorWidget: (_, __, ___) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: context.c.divider,
            child: Icon(Icons.broken_image_outlined, color: context.c.textHint),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}
