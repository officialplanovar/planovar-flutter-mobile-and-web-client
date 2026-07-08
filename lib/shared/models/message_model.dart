import 'package:equatable/equatable.dart';
import 'num_parse.dart';
import 'quote_model.dart';
import 'invoice_model.dart';
import 'todo_model.dart';

/// Lightweight booking reference carried by order-request / timeline cards.
class OrderBookingRef extends Equatable {
  final String id;
  final String status; // pending | confirmed | cancelled | ...
  final String? fulfilmentType; // purchase | rental | service
  final double? total;
  final String? listingTitle;

  const OrderBookingRef({
    required this.id,
    required this.status,
    this.fulfilmentType,
    this.total,
    this.listingTitle,
  });

  factory OrderBookingRef.fromJson(Map<String, dynamic> j) => OrderBookingRef(
        id: j['id'] as String,
        status: (j['status'] as String? ?? 'pending').toLowerCase(),
        fulfilmentType: (j['fulfilmentType'] as String?)?.toLowerCase(),
        total: numToDoubleOrNull(j['finalAmount']),
        listingTitle: (j['listing'] as Map?)?['title'] as String?,
      );

  @override
  List<Object?> get props => [id, status];
}

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;

  /// Normalized (lower-case) message type. Content: text/image/file/voice.
  /// Cards: quote, quote_revised, quote_accepted, quote_declined, quote_expired,
  /// invoice, invoice_accepted, invoice_declined, milestone_paid, order_request,
  /// order_accepted, order_declined, timeline_update, deposit_refunded, todo,
  /// booking_confirmed, payment_confirmed, ...
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  // Structured-card payloads (only the one matching `type` is set)
  final QuoteModel? quote;
  final InvoiceModel? invoice;
  final TodoModel? todo;
  final OrderBookingRef? booking;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.metadata = const {},
    this.quote,
    this.invoice,
    this.todo,
    this.booking,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      type: (json['type'] as String? ?? 'text').toLowerCase(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : const {},
      quote: json['quote'] != null
          ? QuoteModel.fromJson(Map<String, dynamic>.from(json['quote'] as Map))
          : null,
      invoice: json['invoice'] != null
          ? InvoiceModel.fromJson(
              Map<String, dynamic>.from(json['invoice'] as Map))
          : null,
      todo: json['todo'] != null
          ? TodoModel.fromJson(Map<String, dynamic>.from(json['todo'] as Map))
          : null,
      booking: json['booking'] != null
          ? OrderBookingRef.fromJson(
              Map<String, dynamic>.from(json['booking'] as Map))
          : null,
    );
  }

  @override
  List<Object?> get props => [id, conversationId, senderId, type, isRead, createdAt];
}
