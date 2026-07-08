import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';
import '../../shared/models/vendor_model.dart';

/// REST side of messaging (history, conversation list, starting a chat).
/// Live send/receive is handled by [ChatSocket]. Drop-in for the old
/// MockMessagingService (same getConversations / getMessages / sendMessage).
class MessagingService {
  final ApiClient _api;
  MessagingService({ApiClient? api}) : _api = api ?? ApiClient();

  /// The current user's real id (from /users/me, bearer-auth). Reliable source
  /// for "is this my message" — the AuthBloc user can be empty under bearer auth.
  Future<String?> myId() async {
    try {
      final res = await _api.dio.get('/users/me');
      return (res.data as Map?)?['id'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<List<ConversationModel>> getConversations() async {
    final res = await _api.dio.get('/conversations');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => _mapConversation(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// History, oldest-first (API returns newest-first).
  Future<List<MessageModel>> getMessages(String conversationId) async {
    final res = await _api.dio.get('/conversations/$conversationId/messages');
    ensureOk(res);
    final list = (res.data as List? ?? const [])
        .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return list.reversed.toList();
  }

  /// REST fallback send (live path is ChatSocket.sendMessage).
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String type = 'TEXT',
  }) async {
    final res = await _api.dio.post(
      '/conversations/$conversationId/messages',
      data: {'content': content, 'type': type.toUpperCase()},
    );
    ensureOk(res);
    return MessageModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  /// Starts (or returns the existing) direct conversation with a vendor.
  Future<ConversationModel> startWithVendor(String vendorId) async {
    final res = await _api.dio.post('/conversations', data: {
      'type': 'DIRECT',
      'vendorId': vendorId,
    });
    ensureOk(res);
    return _mapConversation(Map<String, dynamic>.from(res.data));
  }

  /// Gets (or creates) the event's GROUP chat — auto-adds all event vendors.
  Future<ConversationModel> getOrCreateEventGroup(String eventId) async {
    final res = await _api.dio.post('/conversations/events/$eventId/group');
    ensureOk(res);
    return _mapConversation(Map<String, dynamic>.from(res.data));
  }

  // ── mapping (participant-based API conv → vendor-centric UI model) ─────────

  ConversationModel _mapConversation(Map<String, dynamic> c) {
    final clientId = c['clientId'] as String?;
    final participants = (c['participants'] as List? ?? const []);
    // The "other" party (vendor) is the participant that isn't the client.
    Map<String, dynamic>? otherUser;
    for (final p in participants) {
      final u = (p as Map)['user'] as Map?;
      if (u != null && u['id'] != clientId) {
        otherUser = Map<String, dynamic>.from(u);
        break;
      }
    }

    final lastMsg = c['lastMessage'];
    final lastMsgText = lastMsg is Map ? lastMsg['content'] as String? : null;

    final vendorProfile = c['vendor'] as Map?;
    VendorModel? vendor;
    if (c['vendorId'] != null) {
      vendor = VendorModel(
        id: c['vendorId'] as String,
        businessName: (vendorProfile?['businessName'] as String?) ??
            (otherUser?['name'] as String?) ??
            'Vendor',
        slug: '',
        // Prefer the vendor's logo/cover; fall back to the user image.
        coverUrl: (vendorProfile?['logoUrl'] as String?) ??
            (vendorProfile?['coverUrl'] as String?) ??
            (otherUser?['image'] as String?),
        ratingAvg: 0,
        reviewCount: 0,
        subscriptionTier: 'BASIC',
        isVerified: false,
        categories: const [],
      );
    }

    final members = participants
        .map((p) => (p as Map)['user'])
        .whereType<Map>()
        .map((u) => ChatParticipant(
              userId: u['id'] as String? ?? '',
              name: u['name'] as String? ?? 'Member',
              avatarUrl: u['image'] as String?,
            ))
        .where((m) => m.userId.isNotEmpty)
        .toList();

    return ConversationModel(
      id: c['id'] as String,
      vendorId: (c['vendorId'] as String?) ?? '',
      vendor: vendor,
      lastMessage: lastMsgText,
      lastMessageAt: c['lastMessageAt'] != null
          ? DateTime.tryParse(c['lastMessageAt'].toString())
          : null,
      unreadCount: (c['unreadCount'] as num?)?.toInt() ?? 0,
      status: (c['status'] as String?) ?? 'active',
      isGroup: c['type'] == 'GROUP',
      groupName: c['groupName'] as String?,
      groupVendors: const [],
      participants: members,
      eventId: c['eventId'] as String?,
    );
  }
}
