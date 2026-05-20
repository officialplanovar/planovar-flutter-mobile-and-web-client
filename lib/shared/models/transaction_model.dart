import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final String bookingId;
  final String type; // 'payment', 'refund'
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.bookingId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'NGN',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'type': type,
        'amount': amount,
        'currency': currency,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, bookingId, type, amount, status, createdAt];
}
