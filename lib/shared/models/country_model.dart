import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final String id;
  final String name;
  final String code;
  final String dialCode;
  final String flagEmoji;

  const CountryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flagEmoji,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      dialCode: json['dialCode'] as String,
      flagEmoji: json['flagEmoji'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'dialCode': dialCode,
        'flagEmoji': flagEmoji,
      };

  @override
  List<Object?> get props => [id, name, code, dialCode, flagEmoji];
}
