import 'package:equatable/equatable.dart';
import 'quote_model.dart';

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  // type: 'text' | 'quote' | 'quote_revised' | 'invoice' | 'invoice_accepted' |
  //        'invoice_declined' | 'booking_confirmed' | 'payment_confirmed' |
  //        'payment_pending' | 'booking_cancelled' | 'dispute_raised' |
  //        'review_requested' | 'review_submitted' | 'refund_requested'
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final QuoteModel? quote;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.quote,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String?,
      type: json['type'] as String? ?? 'text',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      quote: json['quote'] != null ? QuoteModel.fromJson(json['quote'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'senderId': senderId,
        'content': content,
        'type': type,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'quote': quote?.toJson(),
      };

  @override
  List<Object?> get props => [id, conversationId, senderId, type, isRead, createdAt];
}
