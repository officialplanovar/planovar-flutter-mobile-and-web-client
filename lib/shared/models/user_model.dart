import 'package:equatable/equatable.dart';
import 'client_profile_model.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String role;
  final String? image;
  final ClientProfileModel? clientProfile;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.image,
    this.clientProfile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      image: json['image'] as String?,
      clientProfile: json['clientProfile'] != null
          ? ClientProfileModel.fromJson(json['clientProfile'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'image': image,
        'clientProfile': clientProfile?.toJson(),
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
    String? role,
    String? image,
    ClientProfileModel? clientProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      image: image ?? this.image,
      clientProfile: clientProfile ?? this.clientProfile,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, firstName, lastName, role, image, clientProfile];
}
