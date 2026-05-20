import 'package:equatable/equatable.dart';
import 'vendor_model.dart';

class ReviewModel extends Equatable {
  final String id;
  final String bookingId;
  final String reviewerId;
  final String vendorId;
  final VendorModel? vendor;
  final double rating;
  final String? title;
  final String? body;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.reviewerId,
    required this.vendorId,
    this.vendor,
    required this.rating,
    this.title,
    this.body,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      reviewerId: json['reviewerId'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      rating: (json['rating'] as num).toDouble(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'reviewerId': reviewerId,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'rating': rating,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, bookingId, reviewerId, vendorId, rating, createdAt];
}
