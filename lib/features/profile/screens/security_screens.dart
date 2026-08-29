import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';

Widget _buildLavenderHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
}) {
  return Container(
    color: context.c.primaryLight,
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
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: context.c.textPrimary),
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
                      color: context.c.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textHint,
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

  Color _segmentColor(BuildContext context, int index) {
    final strength = _strengthLevel();
    if (index >= strength) return context.c.border;
    if (strength == 1) return const Color(0xFFEF4444);
    if (strength == 2) return const Color(0xFFFBBF24);
    if (strength == 3) return const Color(0xFFF97316);
    return const Color(0xFF22C55E);
  }

  bool _hasCapital() => RegExp(r'[A-Z]').hasMatch(_password);
  bool _hasNumber() => RegExp(r'[0-9]').hasMatch(_password);
  bool _hasSpecial() => RegExp(r'[^A-Za-z0-9]').hasMatch(_password);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
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
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.c.divider,
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
                                color: context.c.textHint,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showNew = !_showNew),
                          child: Icon(
                            _showNew ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: context.c.textHint,
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
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.c.divider,
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
                                color: context.c.textHint,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showConfirm = !_showConfirm),
                          child: Icon(
                            _showConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: context.c.textHint,
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
                            color: _segmentColor(context, i),
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
            color: met ? context.c.textPrimary : context.c.textHint,
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
      backgroundColor: context.c.background,
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
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: context.c.textHint,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: context.c.primaryLight,
        ),
      ],
    );
  }
}
// ─── Support Chat (Crisp) ───────────────────────────────────────────────────
// Live support via Crisp, opened in the browser / a new tab (the client has no
// in-app WebView dependency). Website ID is a build-time dart-define:
//   --dart-define=CRISP_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
// Until it's set, this falls back to emailing support.

const String _kCrispWebsiteId =
    String.fromEnvironment('CRISP_WEBSITE_ID', defaultValue: '');
const String _kSupportEmail = 'support@planovar.ng';

class SupportChatScreen extends StatelessWidget {
  const SupportChatScreen({super.key});

  String get _chatUrl =>
      'https://go.crisp.chat/chat/embed/?website_id=$_kCrispWebsiteId';

  Future<void> _open() async {
    final url = _kCrispWebsiteId.isEmpty
        ? Uri.parse('mailto:$_kSupportEmail')
        : Uri.parse(_chatUrl);
    await launchUrl(url,
        mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final configured = _kCrispWebsiteId.isNotEmpty;
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.c.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Support',
            style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  configured
                      ? Icons.chat_bubble_outline_rounded
                      : Icons.support_agent_rounded,
                  size: 56,
                  color: AppColors.primary),
              const SizedBox(height: 16),
              Text(configured ? 'Chat with our team' : 'Support is being set up',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary)),
              const SizedBox(height: 8),
              Text(
                  configured
                      ? 'Open our live chat to talk to a support agent.'
                      : "Our live chat isn't connected yet — email us and we'll "
                          "get right back to you.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textSecondary,
                      height: 1.5)),
              const SizedBox(height: 28),
              GlossyButton(
                label: configured ? 'Open live chat' : 'Email support',
                onPressed: _open,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
