import 'package:equatable/equatable.dart';
import 'vendor_model.dart';

class QuoteLineItem extends Equatable {
  final String label;
  final double amount;

  const QuoteLineItem({required this.label, required this.amount});

  factory QuoteLineItem.fromJson(Map<String, dynamic> json) {
    return QuoteLineItem(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'amount': amount,
      };

  @override
  List<Object?> get props => [label, amount];
}

class QuoteModel extends Equatable {
  final String id;
  final String bookingId;
  final String vendorId;
  final VendorModel? vendor;
  final double amount;
  final String? description;
  final List<QuoteLineItem> lineItems;
  final DateTime validUntil;
  final String status;

  const QuoteModel({
    required this.id,
    required this.bookingId,
    required this.vendorId,
    this.vendor,
    required this.amount,
    this.description,
    required this.lineItems,
    required this.validUntil,
    required this.status,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      lineItems: (json['lineItems'] as List? ?? [])
          .map((e) => QuoteLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      validUntil: DateTime.parse(json['validUntil'] as String),
      status: json['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'amount': amount,
        'description': description,
        'lineItems': lineItems.map((e) => e.toJson()).toList(),
        'validUntil': validUntil.toIso8601String(),
        'status': status,
      };

  @override
  List<Object?> get props => [id, bookingId, vendorId, amount, status];
}
