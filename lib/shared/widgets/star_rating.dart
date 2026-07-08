import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double starSize;
  final bool showCount;

  const StarRating({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.starSize = 14,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: AppColors.starColor, size: starSize),
        const SizedBox(width: 3),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.label(context).copyWith(fontSize: starSize - 2),
        ),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: AppTextStyles.caption(context).copyWith(fontSize: starSize - 3),
          ),
        ],
      ],
    );
  }
}
