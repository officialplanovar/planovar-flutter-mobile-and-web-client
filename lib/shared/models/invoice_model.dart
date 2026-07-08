import 'package:equatable/equatable.dart';
import 'num_parse.dart';

class InvoiceLineItem extends Equatable {
  final String label;
  final double amount;

  const InvoiceLineItem({required this.label, required this.amount});

  factory InvoiceLineItem.fromJson(Map<String, dynamic> j) => InvoiceLineItem(
        label: j['label'] as String? ?? '',
        amount: numToDouble(j['amount']),
      );

  @override
  List<Object?> get props => [label, amount];
}

/// A payable tranche of an invoice (direct client→vendor via Paystack).
class PaymentMilestone extends Equatable {
  final String id;
  final String label;
  final String? dueLabel;
  final double percentage;
  final double amount; // vendor net for this tranche
  final double? feeAmount; // Paystack fee the client bears
  final String status; // pending | paid | overdue | waived
  final DateTime? dueAt;
  final DateTime? paidAt;

  const PaymentMilestone({
    required this.id,
    required this.label,
    this.dueLabel,
    required this.percentage,
    required this.amount,
    this.feeAmount,
    required this.status,
    this.dueAt,
    this.paidAt,
  });

  bool get isPaid => status.toLowerCase() == 'paid';

  factory PaymentMilestone.fromJson(Map<String, dynamic> j) => PaymentMilestone(
        id: j['id'] as String,
        label: j['label'] as String? ?? '',
        dueLabel: j['dueLabel'] as String?,
        percentage: numToDouble(j['percentage']),
        amount: numToDouble(j['amount']),
        feeAmount: numToDoubleOrNull(j['feeAmount']),
        status: (j['status'] as String? ?? 'pending').toLowerCase(),
        dueAt: j['dueAt'] != null ? DateTime.tryParse(j['dueAt'] as String) : null,
        paidAt: j['paidAt'] != null ? DateTime.tryParse(j['paidAt'] as String) : null,
      );

  @override
  List<Object?> get props => [id, status, amount];
}

class InvoiceModel extends Equatable {
  final String id;
  final String invoiceNumber;
  final String? bookingId;
  final double subtotal;
  final double total;
  final String status; // draft | sent | accepted | partially_paid | paid | ...
  final List<InvoiceLineItem> lineItems;
  final List<PaymentMilestone> milestones;

  const InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    this.bookingId,
    required this.subtotal,
    required this.total,
    required this.status,
    required this.lineItems,
    required this.milestones,
  });

  double get paidAmount =>
      milestones.where((m) => m.isPaid).fold(0.0, (s, m) => s + m.amount);
  double get outstanding => (total - paidAmount).clamp(0, total);
  bool get isFullyPaid => milestones.isNotEmpty && milestones.every((m) => m.isPaid);

  factory InvoiceModel.fromJson(Map<String, dynamic> j) => InvoiceModel(
        id: j['id'] as String,
        invoiceNumber: j['invoiceNumber'] as String? ?? '',
        bookingId: j['bookingId'] as String?,
        subtotal: numToDouble(j['subtotal']),
        total: numToDouble(j['total']),
        status: (j['status'] as String? ?? 'sent').toLowerCase(),
        lineItems: ((j['lineItems'] as List?) ?? const [])
            .map((e) => InvoiceLineItem.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        milestones: ((j['milestones'] as List?) ?? const [])
            .map((e) => PaymentMilestone.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  @override
  List<Object?> get props => [id, status, total];
}
