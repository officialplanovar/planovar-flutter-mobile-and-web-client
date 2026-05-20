import 'package:equatable/equatable.dart';
import 'vendor_model.dart';

class ConversationModel extends Equatable {
  final String id;
  final String vendorId;
  final VendorModel? vendor;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.vendorId,
    this.vendor,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt'] as String) : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'unreadCount': unreadCount,
      };

  @override
  List<Object?> get props => [id, vendorId, lastMessage, unreadCount];
}
