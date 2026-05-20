import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final String id;
  final String name;
  final String state;
  final double latitude;
  final double longitude;

  const CityModel({
    required this.id,
    required this.name,
    required this.state,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': state,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  List<Object?> get props => [id, name, state, latitude, longitude];
}
