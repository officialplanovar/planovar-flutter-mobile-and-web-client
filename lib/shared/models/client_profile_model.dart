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
    return ClientProfileModel(
      id: json['id'] as String,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      preferredCountry: json['preferredCountry'] as String?,
      preferredCity: json['preferredCity'] as String?,
      categoryPrefs: List<String>.from(json['categoryPrefs'] as List? ?? []),
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
