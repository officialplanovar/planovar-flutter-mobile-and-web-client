import '../../shared/models/conversation_model.dart';
import '../../shared/models/message_model.dart';
import 'mock_data.dart';

class MockMessagingService {
  static const _delay = Duration(milliseconds: 400);

  Future<List<ConversationModel>> getConversations() async {
    await Future.delayed(_delay);
    return List.from(MockData.conversations);
  }

  Future<List<MessageModel>> getMessages(String conversationId) async {
    await Future.delayed(_delay);
    return MockData.messagesForConversation(conversationId);
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
  }) async {
    await Future.delayed(_delay);
    return MessageModel(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: 'user-001',
      content: content,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
    );
  }
}
