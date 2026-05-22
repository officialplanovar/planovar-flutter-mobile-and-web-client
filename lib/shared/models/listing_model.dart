import 'package:equatable/equatable.dart';
import 'vendor_model.dart';
import 'category_model.dart';

class ListingPackageModel extends Equatable {
  final String id;
  final String listingId;
  final String name;
  final String? description;
  final double price;
  final List<String> features;

  const ListingPackageModel({
    required this.id,
    required this.listingId,
    required this.name,
    this.description,
    required this.price,
    required this.features,
  });

  factory ListingPackageModel.fromJson(Map<String, dynamic> json) {
    return ListingPackageModel(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'listingId': listingId,
        'name': name,
        'description': description,
        'price': price,
        'features': features,
      };

  @override
  List<Object?> get props => [id, listingId, name, price];
}

class ListingModel extends Equatable {
  final String id;
  final String vendorId;
  final VendorModel? vendor;
  final String categoryId;
  final CategoryModel? category;
  final String title;
  final String? description;
  final String pricingType;
  final double? basePrice;
  final String? priceUnit;
  final bool isActive;
  final bool isFeatured;
  final List<String> media;
  final List<ListingPackageModel> packages;
  // Product-specific fields
  final bool isRentable;
  final double? perDayRate;
  final double? depositAmount;
  final List<String> sizes;
  final List<String> colors;
  final int reviewCount;

  const ListingModel({
    required this.id,
    required this.vendorId,
    this.vendor,
    required this.categoryId,
    this.category,
    required this.title,
    this.description,
    required this.pricingType,
    this.basePrice,
    this.priceUnit,
    required this.isActive,
    required this.isFeatured,
    required this.media,
    required this.packages,
    this.isRentable = false,
    this.perDayRate,
    this.depositAmount,
    this.sizes = const [],
    this.colors = const [],
    this.reviewCount = 0,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      categoryId: json['categoryId'] as String,
      category: json['category'] != null ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>) : null,
      title: json['title'] as String,
      description: json['description'] as String?,
      pricingType: json['pricingType'] as String? ?? 'fixed',
      basePrice: json['basePrice'] != null ? (json['basePrice'] as num).toDouble() : null,
      priceUnit: json['priceUnit'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      media: List<String>.from(json['media'] as List? ?? []),
      packages: (json['packages'] as List? ?? [])
          .map((e) => ListingPackageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'categoryId': categoryId,
        'category': category?.toJson(),
        'title': title,
        'description': description,
        'pricingType': pricingType,
        'basePrice': basePrice,
        'priceUnit': priceUnit,
        'isActive': isActive,
        'isFeatured': isFeatured,
        'media': media,
        'packages': packages.map((p) => p.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, vendorId, categoryId, title, pricingType, isActive, isRentable];
}
