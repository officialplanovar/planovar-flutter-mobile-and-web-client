import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livekit_client/livekit_client.dart';
import '../../core/services/call_service.dart';
import '../../core/theme/app_colors.dart';

/// 1:1 voice call (LiveKit). Connects to the conversation's room; shows
/// ringing → connected, with mute and end controls.
class CallScreen extends StatefulWidget {
  final String conversationId;
  final String peerName;

  const CallScreen({
    super.key,
    required this.conversationId,
    required this.peerName,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _service = CallService();
  Room? _room;
  EventsListener<RoomEvent>? _listener;
  bool _connecting = true;
  bool _remoteJoined = false;
  bool _muted = false;
  String? _error;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final room = await _service.connect(widget.conversationId);
      if (!mounted) {
        await room.disconnect();
        return;
      }
      _room = room;
      _remoteJoined = room.remoteParticipants.isNotEmpty;
      if (_remoteJoined) _startTimer();

      _listener = room.createListener()
        ..on<ParticipantConnectedEvent>((_) {
          if (!mounted) return;
          setState(() => _remoteJoined = true);
          _startTimer();
        })
        ..on<ParticipantDisconnectedEvent>((_) => _end())
        ..on<RoomDisconnectedEvent>((_) => _end());

      setState(() => _connecting = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _connecting = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _toggleMute() async {
    final lp = _room?.localParticipant;
    if (lp == null) return;
    await lp.setMicrophoneEnabled(_muted);
    setState(() => _muted = !_muted);
  }

  Future<void> _end() async {
    _timer?.cancel();
    await _listener?.dispose();
    await _room?.disconnect();
    _room = null;
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _listener?.dispose();
    _room?.disconnect();
    super.dispose();
  }

  String get _status {
    if (_error != null) return _error!;
    if (_connecting) return 'Connecting…';
    if (!_remoteJoined) return 'Ringing…';
    final m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1430),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                widget.peerName.isNotEmpty ? widget.peerName[0].toUpperCase() : '?',
                style: GoogleFonts.urbanist(
                    fontSize: 44, color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.peerName,
              style: GoogleFonts.urbanist(
                  fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              _status,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: _error != null ? Colors.redAccent : Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_error == null)
                  _CallButton(
                    icon: _muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: Colors.white24,
                    onTap: _toggleMute,
                  ),
                const SizedBox(width: 28),
                _CallButton(
                  icon: Icons.call_end_rounded,
                  color: const Color(0xFFE53935),
                  onTap: _end,
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _CallButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
