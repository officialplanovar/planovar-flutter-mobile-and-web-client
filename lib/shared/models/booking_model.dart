import 'package:equatable/equatable.dart';
import 'vendor_model.dart';
import 'listing_model.dart';

class BookingModel extends Equatable {
  final String id;
  final String clientId;
  final String vendorId;
  final VendorModel? vendor;
  final String listingId;
  final ListingModel? listing;
  final String status;
  final DateTime eventDate;
  final String? eventLocation;
  final String? requirements;
  final double? quoteAmount;
  final double? finalAmount;
  /// PURCHASE | RENTAL | SERVICE — drives the order-tracking tabs.
  final String? fulfilmentType;

  // ── Fee breakdown (booking-level) ──────────────────────────────────────────
  final double? deliveryFee;
  final double? depositAmount; // rental refundable deposit
  final double? lateFeePerDay;
  final DateTime? pickupAt;
  final DateTime? returnAt;

  // ── Invoice: itemized fee lines + payment schedule/history ─────────────────
  final String? invoiceNumber;
  final double? invoiceSubtotal;
  final double? invoiceTotal;
  final List<BookingFeeLine> feeLines;
  final List<BookingMilestone> milestones;

  const BookingModel({
    required this.id,
    required this.clientId,
    required this.vendorId,
    this.vendor,
    required this.listingId,
    this.listing,
    required this.status,
    required this.eventDate,
    this.eventLocation,
    this.requirements,
    this.quoteAmount,
    this.finalAmount,
    this.fulfilmentType,
    this.deliveryFee,
    this.depositAmount,
    this.lateFeePerDay,
    this.pickupAt,
    this.returnAt,
    this.invoiceNumber,
    this.invoiceSubtotal,
    this.invoiceTotal,
    this.feeLines = const [],
    this.milestones = const [],
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    double? d(dynamic v) => v == null ? null : (v as num).toDouble();
    DateTime? dt(dynamic v) => v == null ? null : DateTime.tryParse(v as String);
    final invoice = json['invoice'] as Map<String, dynamic>?;
    final lineItems = (invoice?['lineItems'] as List?) ?? const [];
    final milestones = (invoice?['milestones'] as List?) ?? const [];
    return BookingModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      listingId: json['listingId'] as String,
      listing: json['listing'] != null ? ListingModel.fromJson(json['listing'] as Map<String, dynamic>) : null,
      status: json['status'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventLocation: json['eventLocation'] is String ? json['eventLocation'] as String : null,
      requirements: json['requirements'] as String?,
      quoteAmount: d(json['quoteAmount']),
      finalAmount: d(json['finalAmount']),
      fulfilmentType: (json['fulfilmentType'] as String?)?.toUpperCase(),
      deliveryFee: d(json['deliveryFee']),
      depositAmount: d(json['depositAmount']),
      lateFeePerDay: d(json['lateFeePerDay']),
      pickupAt: dt(json['pickupAt']),
      returnAt: dt(json['returnAt']),
      invoiceNumber: invoice?['invoiceNumber'] as String?,
      invoiceSubtotal: d(invoice?['subtotal']),
      invoiceTotal: d(invoice?['total']),
      feeLines: lineItems
          .map((e) => BookingFeeLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: milestones
          .map((e) => BookingMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'listingId': listingId,
        'listing': listing?.toJson(),
        'status': status,
        'eventDate': eventDate.toIso8601String(),
        'eventLocation': eventLocation,
        'requirements': requirements,
        'quoteAmount': quoteAmount,
        'finalAmount': finalAmount,
      };

  @override
  List<Object?> get props =>
      [id, clientId, vendorId, listingId, status, eventDate, fulfilmentType];
}

/// One line of an invoice's itemized fee breakdown.
class BookingFeeLine {
  final String label;
  final double amount;
  const BookingFeeLine({required this.label, required this.amount});

  factory BookingFeeLine.fromJson(Map<String, dynamic> json) => BookingFeeLine(
        label: json['label'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
      );
}

/// A payment tranche — its status + paidAt form the real payment history.
class BookingMilestone {
  final String label;
  final double amount;
  final double? feeAmount;
  final String status; // pending | paid | overdue | waived
  final DateTime? dueAt;
  final DateTime? paidAt;
  const BookingMilestone({
    required this.label,
    required this.amount,
    this.feeAmount,
    required this.status,
    this.dueAt,
    this.paidAt,
  });

  bool get isPaid => status.toLowerCase() == 'paid';

  factory BookingMilestone.fromJson(Map<String, dynamic> json) {
    DateTime? dt(dynamic v) => v == null ? null : DateTime.tryParse(v as String);
    return BookingMilestone(
      label: json['label'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      feeAmount: (json['feeAmount'] as num?)?.toDouble(),
      status: (json['status'] as String? ?? 'pending').toLowerCase(),
      dueAt: dt(json['dueAt']),
      paidAt: dt(json['paidAt']),
    );
  }
}
