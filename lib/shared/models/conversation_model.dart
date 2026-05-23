import 'package:equatable/equatable.dart';
import 'vendor_model.dart';

class ConversationModel extends Equatable {
  final String id;
  final String vendorId;
  final VendorModel? vendor;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final double? pendingQuoteAmount;
  // status: 'active' | 'payment_pending' | 'confirmed' | 'completed' | 'cancelled' | 'disputed'
  final String status;

  // Group chat fields
  final bool isGroup;
  final String? groupName;
  final List<VendorModel> groupVendors;
  final String? eventId;

  const ConversationModel({
    required this.id,
    required this.vendorId,
    this.vendor,
    this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    this.pendingQuoteAmount,
    this.status = 'active',
    this.isGroup = false,
    this.groupName,
    this.groupVendors = const [],
    this.eventId,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null ? DateTime.parse(json['lastMessageAt'] as String) : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      pendingQuoteAmount: (json['pendingQuoteAmount'] as num?)?.toDouble(),
      status: json['status'] as String? ?? 'active',
      isGroup: json['isGroup'] as bool? ?? false,
      groupName: json['groupName'] as String?,
      eventId: json['eventId'] as String?,
      groupVendors: (json['groupVendors'] as List? ?? [])
          .map((e) => VendorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'lastMessage': lastMessage,
        'lastMessageAt': lastMessageAt?.toIso8601String(),
        'unreadCount': unreadCount,
        'pendingQuoteAmount': pendingQuoteAmount,
        'status': status,
        'isGroup': isGroup,
        'groupName': groupName,
        'eventId': eventId,
        'groupVendors': groupVendors.map((v) => v.toJson()).toList(),
      };

  @override
  List<Object?> get props => [id, vendorId, lastMessage, unreadCount, status, isGroup, groupName, eventId];
}
