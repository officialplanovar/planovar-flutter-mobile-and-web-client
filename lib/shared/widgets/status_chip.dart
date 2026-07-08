import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusChip({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _statusProps(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(context).copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }

  (Color, Color, String) _statusProps(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (AppColors.warning, const Color(0xFFFFF8E1), 'Pending');
      case 'confirmed':
        return (AppColors.success, const Color(0xFFE8F5E9), 'Confirmed');
      case 'active':
        return (AppColors.primary, context.c.primaryLight, 'Active');
      case 'completed':
        return (const Color(0xFF1565C0), const Color(0xFFE3F2FD), 'Completed');
      case 'cancelled':
        return (AppColors.error, const Color(0xFFFFEBEE), 'Cancelled');
      case 'accepted':
        return (AppColors.success, const Color(0xFFE8F5E9), 'Accepted');
      case 'rejected':
        return (AppColors.error, const Color(0xFFFFEBEE), 'Rejected');
      case 'featured':
        return (AppColors.accent, const Color(0xFFFFF8E1), 'Featured');
      case 'premium':
        return (AppColors.primary, context.c.primaryLight, 'Premium');
      case 'basic':
        return (context.c.textSecondary, context.c.divider, 'Basic');
      default:
        return (context.c.textSecondary, context.c.divider, status);
    }
  }
}
