import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? iconUrl;
  final String? imageUrl;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconUrl,
    this.imageUrl,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'description': description,
        'iconUrl': iconUrl,
        'imageUrl': imageUrl,
        'sortOrder': sortOrder,
      };

  @override
  List<Object?> get props => [id, name, slug, sortOrder];
}
