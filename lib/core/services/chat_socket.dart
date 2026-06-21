import 'package:socket_io_client/socket_io_client.dart' as io;
import '../api/token_store.dart';
import '../constants/app_constants.dart';

/// Live chat transport over the API's Socket.io `/chat` namespace.
///
/// Auth: sends the Better Auth bearer token via the socket.io `auth` option
/// (works on web + mobile; the gateway accepts `handshake.auth.token`).
class ChatSocket {
  io.Socket? _socket;
  final TokenStore _tokenStore;

  ChatSocket({TokenStore? tokenStore}) : _tokenStore = tokenStore ?? TokenStore();

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect() async {
    if (_socket != null) return;
    final token = await _tokenStore.read();
    _socket = io.io(
      '${AppConstants.apiBaseUrl}/chat',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token ?? ''})
          .setExtraHeaders({'Authorization': 'Bearer ${token ?? ''}'})
          .build(),
    );
    _socket!.connect();
  }

  void join(String conversationId) =>
      _socket?.emit('join', {'conversationId': conversationId});

  void leave(String conversationId) =>
      _socket?.emit('leave', {'conversationId': conversationId});

  void sendMessage({
    required String conversationId,
    required String content,
    String type = 'TEXT',
  }) =>
      _socket?.emit('message', {
        'conversationId': conversationId,
        'content': content,
        'type': type,
      });

  void setTyping(String conversationId, bool isTyping) =>
      _socket?.emit('typing', {'conversationId': conversationId, 'isTyping': isTyping});

  void markRead(String conversationId) =>
      _socket?.emit('read', {'conversationId': conversationId});

  // ── Voice-call signaling (relay; media via LiveKit) ──────────────────────
  void inviteCall(String conversationId) =>
      _socket?.emit('call:invite', {'conversationId': conversationId});

  void onCallIncoming(void Function(Map<String, dynamic>) cb) =>
      _socket?.on('call:incoming', (d) => cb(Map<String, dynamic>.from(d as Map)));

  void onMessage(void Function(Map<String, dynamic>) cb) =>
      _socket?.on('message', (d) => cb(Map<String, dynamic>.from(d as Map)));

  void onTyping(void Function(Map<String, dynamic>) cb) =>
      _socket?.on('typing', (d) => cb(Map<String, dynamic>.from(d as Map)));

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
