import 'package:flutter/material.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/review_model.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/star_rating.dart';
import '../../../core/utils/formatters.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = MockData.reviews;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Reviews')),
      body: reviews.isEmpty
          ? const EmptyState(icon: Icons.star_border_rounded, title: 'No reviews yet')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, i) => _ReviewCard(review: reviews[i]),
            ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review.vendor?.businessName ?? 'Vendor', style: AppTextStyles.label),
          const SizedBox(height: 6),
          StarRating(rating: review.rating, showCount: false),
          if (review.title != null) ...[
            const SizedBox(height: 8),
            Text(review.title!, style: AppTextStyles.label),
          ],
          if (review.body != null) ...[
            const SizedBox(height: 4),
            Text(review.body!, style: AppTextStyles.body2),
          ],
          const SizedBox(height: 6),
          Text(Formatters.date(review.createdAt), style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
