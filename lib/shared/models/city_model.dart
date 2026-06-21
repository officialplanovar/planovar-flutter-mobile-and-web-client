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
    // API serializes Prisma Decimal coordinates as strings.
    double toD(dynamic v) =>
        v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    return CityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      state: json['state'] as String,
      latitude: toD(json['latitude']),
      longitude: toD(json['longitude']),
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
