import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  static const _mockReviews = [
    {
      'name': 'Ngozi A.',
      'rating': 4,
      'date': 'Mar 2026',
      'service': 'Dining Arrangement',
      'vendor': 'Lumière Photography',
      'price': '₦20,000',
      'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200',
    },
    {
      'name': 'Kathryn Murphy',
      'rating': 4,
      'date': 'Mar 2026',
      'service': 'Dining Arrangement',
      'vendor': 'Lumière Photography',
      'price': '₦20,000',
      'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200',
    },
    {
      'name': 'Esther Howard',
      'rating': 4,
      'date': 'Mar 2026',
      'service': 'Dining Arrangement',
      'vendor': 'Lumière Photography',
      'price': '₦20,000',
      'img': 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=200',
    },
    {
      'name': 'Chisom O.',
      'rating': 5,
      'date': 'Feb 2026',
      'service': 'Wedding Photography',
      'vendor': 'Lumière Photography',
      'price': '₦650,000',
      'img': 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=200',
    },
    {
      'name': 'Bola T.',
      'rating': 3,
      'date': 'Jan 2026',
      'service': 'Wedding Cake',
      'vendor': 'Sugared Dreams',
      'price': '₦120,000',
      'img': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  _buildRatingSummary(),
                  const SizedBox(height: 20),
                  ..._mockReviews.map((r) => _ReviewCard(review: r)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFECDEFA),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.07),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1A1A2E)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews',
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    'View all your reviews from past events',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            '3.9',
            style: GoogleFonts.urbanist(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < 4 ? Icons.star_rounded : Icons.star_border_rounded,
                    color: i < 4 ? AppColors.starColor : const Color(0xFFD1D5DB),
                    size: 22,
                  );
                }),
              ),
              const SizedBox(height: 6),
              Text(
                '128 verified reviews',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final int rating = review['rating'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'] as String,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review['date'] as String,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: i < rating ? AppColors.starColor : const Color(0xFFD1D5DB),
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    review['img'] as String,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 54,
                      height: 54,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['service'] as String,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${review['vendor']} · ${review['price']}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
