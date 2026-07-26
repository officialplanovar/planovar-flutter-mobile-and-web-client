import 'package:equatable/equatable.dart';

class ClientProfileModel extends Equatable {
  final String id;
  final bool onboardingComplete;
  final String? preferredCountry;
  final String? preferredCity;
  final List<String> categoryPrefs;

  const ClientProfileModel({
    required this.id,
    required this.onboardingComplete,
    this.preferredCountry,
    this.preferredCity,
    required this.categoryPrefs,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    // The API returns preferredCountry/preferredCity as nested objects
    // ({id, name, ...}) and categoryPrefs as [{category: {name, ...}}].
    // Tolerate both those shapes and a plain string, so parsing never throws.
    String? label(dynamic v) {
      if (v is String) return v;
      if (v is Map) return v['name'] as String?;
      return null;
    }

    return ClientProfileModel(
      id: json['id'] as String,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      preferredCountry: label(json['preferredCountry']),
      preferredCity: label(json['preferredCity']),
      categoryPrefs: ((json['categoryPrefs'] as List?) ?? const [])
          .map((e) {
            if (e is String) return e;
            if (e is Map) {
              final cat = e['category'];
              if (cat is Map) {
                return (cat['name'] ?? cat['id'] ?? '').toString();
              }
              return (e['name'] ?? e['id'] ?? '').toString();
            }
            return '';
          })
          .where((s) => s.isNotEmpty)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'onboardingComplete': onboardingComplete,
        'preferredCountry': preferredCountry,
        'preferredCity': preferredCity,
        'categoryPrefs': categoryPrefs,
      };

  @override
  List<Object?> get props => [id, onboardingComplete, preferredCountry, preferredCity, categoryPrefs];
}
