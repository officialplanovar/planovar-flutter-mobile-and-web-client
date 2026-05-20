import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/models/vendor_model.dart';
import 'network_image_widget.dart';
import 'star_rating.dart';
import 'status_chip.dart';

/// Grid / horizontal scroll card — 180×220
class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback? onTap;

  const VendorCard({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image
              Stack(
                children: [
                  AppNetworkImage(
                    url: vendor.coverUrl,
                    width: 180,
                    height: 132,
                    fit: BoxFit.cover,
                  ),
                  if (vendor.isFeatured)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Featured',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vendor.businessName,
                        style: AppTextStyles.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vendor.categories.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            vendor.categories.first,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          StarRating(rating: vendor.ratingAvg, reviewCount: vendor.reviewCount),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 11, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              vendor.location ?? '',
                              style: AppTextStyles.caption.copyWith(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// List variant — full width horizontal card
class VendorListCard extends StatelessWidget {
  final VendorModel vendor;
  final VoidCallback? onTap;

  const VendorListCard({super.key, required this.vendor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            AppNetworkImage(
              url: vendor.coverUrl,
              width: 100,
              height: 100,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vendor.businessName,
                          style: AppTextStyles.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (vendor.isVerified)
                        const Icon(Icons.verified_rounded,
                            size: 16, color: AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (vendor.categories.isNotEmpty)
                    Text(
                      vendor.categories.join(', '),
                      style: AppTextStyles.caption,
                    ),
                  const SizedBox(height: 4),
                  StarRating(rating: vendor.ratingAvg, reviewCount: vendor.reviewCount),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Text(vendor.location ?? '', style: AppTextStyles.caption),
                      const Spacer(),
                      StatusChip(status: vendor.subscriptionTier, fontSize: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
