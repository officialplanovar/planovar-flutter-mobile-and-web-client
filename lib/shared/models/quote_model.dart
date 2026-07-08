import 'package:equatable/equatable.dart';
import 'num_parse.dart';
import 'vendor_model.dart';

class QuoteLineItem extends Equatable {
  final String label;
  final double amount;

  const QuoteLineItem({required this.label, required this.amount});

  factory QuoteLineItem.fromJson(Map<String, dynamic> json) {
    return QuoteLineItem(
      label: json['label'] as String? ?? '',
      amount: numToDouble(json['amount']),
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
  final String? quoteNumber;
  final String? bookingId; // null until the quote is accepted (invoice/booking created)
  final String vendorId;
  final VendorModel? vendor;
  final double amount;
  final String? description;
  final String? notes; // vendor's "Note to client"
  final List<QuoteLineItem> lineItems;
  final List<QuotePaymentTerm> paymentTerms;
  final DateTime validUntil;
  final String status; // pending | accepted | rejected | expired | superseded
  final int version;
  final bool isActive;

  const QuoteModel({
    required this.id,
    this.quoteNumber,
    this.bookingId,
    required this.vendorId,
    this.vendor,
    required this.amount,
    this.description,
    this.notes,
    required this.lineItems,
    this.paymentTerms = const [],
    required this.validUntil,
    required this.status,
    this.version = 1,
    this.isActive = true,
  });

  bool get isExpired => validUntil.isBefore(DateTime.now());
  bool get canRespond => isActive && status == 'pending' && !isExpired;

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      quoteNumber: json['quoteNumber'] as String?,
      bookingId: json['bookingId'] as String?,
      vendorId: json['vendorId'] as String? ?? '',
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      amount: numToDouble(json['amount']),
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      lineItems: (json['lineItems'] as List? ?? [])
          .map((e) => QuoteLineItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      paymentTerms: (json['paymentTerms'] as List? ?? [])
          .map((e) => QuotePaymentTerm.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      validUntil: DateTime.parse(json['validUntil'] as String),
      status: (json['status'] as String? ?? 'pending').toLowerCase(),
      version: (json['version'] as num?)?.toInt() ?? 1,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [id, bookingId, vendorId, amount, status, version];
}

class QuotePaymentTerm extends Equatable {
  final String label;
  final double percentage;
  final String? dueLabel;

  const QuotePaymentTerm({
    required this.label,
    required this.percentage,
    this.dueLabel,
  });

  factory QuotePaymentTerm.fromJson(Map<String, dynamic> j) => QuotePaymentTerm(
        label: j['label'] as String? ?? '',
        percentage: numToDouble(j['percentage']),
        dueLabel: j['dueLabel'] as String?,
      );

  @override
  List<Object?> get props => [label, percentage];
}
