import 'package:equatable/equatable.dart';

class VendorModel extends Equatable {
  final String id;
  final String businessName;
  final String slug;
  final String? description;
  final String? coverUrl;
  final String? location;
  final double ratingAvg;
  final int reviewCount;
  final String subscriptionTier;
  final bool isVerified;
  final List<String> categories;

  const VendorModel({
    required this.id,
    required this.businessName,
    required this.slug,
    this.description,
    this.coverUrl,
    this.location,
    required this.ratingAvg,
    required this.reviewCount,
    required this.subscriptionTier,
    required this.isVerified,
    required this.categories,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      coverUrl: json['coverUrl'] as String?,
      location: json['location'] as String?,
      ratingAvg: (json['ratingAvg'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      subscriptionTier: json['subscriptionTier'] as String? ?? 'basic',
      isVerified: json['isVerified'] as bool? ?? false,
      categories: List<String>.from(json['categories'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessName': businessName,
        'slug': slug,
        'description': description,
        'coverUrl': coverUrl,
        'location': location,
        'ratingAvg': ratingAvg,
        'reviewCount': reviewCount,
        'subscriptionTier': subscriptionTier,
        'isVerified': isVerified,
        'categories': categories,
      };

  bool get isFeatured => subscriptionTier == 'featured' || subscriptionTier == 'premium';

  @override
  List<Object?> get props => [id, businessName, slug, ratingAvg, subscriptionTier, isVerified];
}
