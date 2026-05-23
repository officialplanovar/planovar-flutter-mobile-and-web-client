import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

Widget _buildLavenderHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
}) {
  return Container(
    color: const Color(0xFFECDEFA),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: Color(0xFF1A1A2E)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Change Password Screen ────────────────────────────────────────────────────
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _showNew = false;
  bool _showConfirm = false;
  String _password = '';

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  int _strengthLevel() {
    final len = _password.length;
    if (len == 0) return 0;
    if (len <= 3) return 1;
    if (len <= 6) return 2;
    if (len <= 9) return 3;
    return 4;
  }

  Color _segmentColor(int index) {
    final strength = _strengthLevel();
    if (index >= strength) return const Color(0xFFE5E7EB);
    if (strength == 1) return const Color(0xFFEF4444);
    if (strength == 2) return const Color(0xFFFBBF24);
    if (strength == 3) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  bool _hasCapital() => RegExp(r'[A-Z]').hasMatch(_password);
  bool _hasNumber() => RegExp(r'[0-9]').hasMatch(_password);
  bool _hasSpecial() => RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(_password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Change Password',
            subtitle: 'Create a new strong password',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Password',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newPassCtrl,
                            obscureText: !_showNew,
                            onChanged: (v) => setState(() => _password = v),
                            style: GoogleFonts.urbanist(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter new password',
                              hintStyle: GoogleFonts.urbanist(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showNew = !_showNew),
                          child: Icon(
                            _showNew ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Confirm Password',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _confirmPassCtrl,
                            obscureText: !_showConfirm,
                            style: GoogleFonts.urbanist(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm new password',
                              hintStyle: GoogleFonts.urbanist(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showConfirm = !_showConfirm),
                          child: Icon(
                            _showConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password strength bar
                  Row(
                    children: List.generate(4, (i) {
                      return Expanded(
                        child: Container(
                          height: 6,
                          margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: _segmentColor(i),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Requirements
                  _RequirementRow(
                    met: _hasCapital(),
                    label: 'Has capital letter',
                  ),
                  const SizedBox(height: 8),
                  _RequirementRow(
                    met: _hasNumber(),
                    label: 'Has number',
                  ),
                  const SizedBox(height: 8),
                  _RequirementRow(
                    met: _hasSpecial(),
                    label: 'Has special character',
                  ),
                  const SizedBox(height: 32),
                  GlossyButton(
                    label: 'Save Password',
                    onPressed: () {},
                    height: 52,
                    radius: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final bool met;
  final String label;

  const _RequirementRow({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.circle_outlined,
          color: met ? AppColors.primary : const Color(0xFFD1D5DB),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: met ? const Color(0xFF1A1A2E) : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}

// ─── Two Factor Screen ────────────────────────────────────────────────────────
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  bool _emailEnabled = false;
  bool _phoneEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Two factor authentication',
            subtitle: 'add an extra layer of security',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TwoFactorToggle(
                    title: 'Email Address',
                    subtitle:
                        'Authentication code will be sent to your email for verification',
                    value: _emailEnabled,
                    onChanged: (v) => setState(() => _emailEnabled = v),
                  ),
                  const SizedBox(height: 24),
                  _TwoFactorToggle(
                    title: 'Phone Number',
                    subtitle:
                        'Authentication code will be sent to your phone for verification',
                    value: _phoneEnabled,
                    onChanged: (v) => setState(() => _phoneEnabled = v),
                  ),
                  const Spacer(),
                  GlossyButton(
                    label: 'Save Preferences',
                    onPressed: () {},
                    height: 52,
                    radius: 14,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoFactorToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TwoFactorToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primaryLight,
        ),
      ],
    );
  }
}

// ─── Support Chat Screen ──────────────────────────────────────────────────────
class _SMsg {
  final bool isMe;
  final String text;
  _SMsg({required this.isMe, required this.text});
}

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_SMsg> _messages = [
    _SMsg(
      isMe: false,
      text: 'Hello thank you for contacting customer care, how may we help you',
    ),
    _SMsg(
      isMe: true,
      text:
          'Hello all, I can\'t find the event I created can you help me search from your end as i had a pending convo',
    ),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_SMsg(isMe: true, text: text));
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Container(
            color: AppColors.primaryLight,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.07),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 18, color: Color(0xFF1A1A2E)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Agent avatar
                    ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 44,
                          height: 44,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.person_rounded, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Johnson',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          'Customer support',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Chat area ────────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              children: [
                // Date separator
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Today',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 12),
                ..._messages.map((msg) => _buildMessageBubble(msg, user.image)),
              ],
            ),
          ),

          // ── Input bar ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Attachment icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.attach_file_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 8),
                  // Text field
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgCtrl,
                              style: GoogleFonts.urbanist(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                hintStyle: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: const Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          const Icon(Icons.mic_rounded, color: Color(0xFF9CA3AF), size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_SMsg msg, String? userImage) {
    if (msg.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.urbanist(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ClipOval(
              child: Image.network(
                userImage ?? '',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 28,
                height: 28,
                color: AppColors.primaryLight,
                child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
