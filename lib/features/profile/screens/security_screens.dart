import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';

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
  final _currentPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _saving = false;
  String _password = '';

  @override
  void dispose() {
    _currentPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final current = _currentPassCtrl.text;
    final next = _newPassCtrl.text;
    final confirm = _confirmPassCtrl.text;

    if (current.isEmpty || next.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(t.passwordRequired)));
      return;
    }
    if (next != confirm) {
      messenger.showSnackBar(SnackBar(content: Text(t.passwordsDoNotMatch)));
      return;
    }

    setState(() => _saving = true);
    try {
      await AuthRepository()
          .changePassword(currentPassword: current, newPassword: next);
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(t.passwordChanged)));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.changePassword,
            subtitle: t.changePasswordSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.currentPassword,
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
                            controller: _currentPassCtrl,
                            obscureText: !_showCurrent,
                            style: GoogleFonts.urbanist(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: t.enterCurrentPassword,
                              hintStyle: GoogleFonts.urbanist(
                                color: context.c.textHint,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showCurrent = !_showCurrent),
                          child: Icon(
                            _showCurrent ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: context.c.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.newPassword,
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
                              hintText: t.enterNewPassword,
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
                    t.confirmPassword,
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
                              hintText: t.confirmNewPassword,
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
                    label: t.hasCapital,
                  ),
                  const SizedBox(height: 8),
                  _RequirementRow(
                    met: _hasNumber(),
                    label: t.hasNumber,
                  ),
                  const SizedBox(height: 8),
                  _RequirementRow(
                    met: _hasSpecial(),
                    label: t.hasSpecial,
                  ),
                  const SizedBox(height: 32),
                  GlossyButton(
                    label: t.savePassword,
                    onPressed: _saving ? null : _save,
                    isLoading: _saving,
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

// ─── Two Factor Screen (TOTP authenticator) ─────────────────────────────────
// Real 2FA via Better Auth's twoFactor plugin. Enabling returns a TOTP URI +
// backup codes; 2FA only becomes active once a code from the authenticator app
// is confirmed via verify-totp. Disabling requires the account password.
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  final _codeCtrl = TextEditingController();

  bool _loading = true; // initial status load
  bool _busy = false; // enable/disable/verify in flight
  bool _enabled = false;

  // Setup (post-enable, pre-confirm) state.
  bool _setupMode = false;
  String _totpUri = '';
  List<String> _backupCodes = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  String get _manualSecret {
    try {
      return Uri.parse(_totpUri).queryParameters['secret'] ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _load() async {
    try {
      final e = await AuthRepository().isTwoFactorEnabled();
      if (mounted) setState(() => _enabled = e);
    } catch (_) {
      // Leave as disabled if status can't be read.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<String?> _promptPassword() async {
    final ctrl = TextEditingController();
    final t = AppLocalizations.of(context);
    final pw = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.twofaConfirmPasswordTitle),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(hintText: t.enterCurrentPassword),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text(t.twofaContinue),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return pw;
  }

  Future<void> _onPrimary() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context);
    final pw = await _promptPassword();
    if (pw == null || pw.isEmpty || !mounted) return;
    setState(() => _busy = true);
    try {
      if (_enabled) {
        await AuthRepository().disableTwoFactor(pw);
        if (!mounted) return;
        setState(() => _enabled = false);
        messenger.showSnackBar(SnackBar(content: Text(t.twofaDisabledMsg)));
      } else {
        final data = await AuthRepository().enableTwoFactor(pw);
        if (!mounted) return;
        setState(() {
          _totpUri = data['totpURI'] as String? ?? '';
          _backupCodes = (data['backupCodes'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [];
          _setupMode = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    if (_busy) return;
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context);
    final code = _codeCtrl.text.trim();
    if (code.length < 6) {
      messenger.showSnackBar(SnackBar(content: Text(t.twofaEnterCode)));
      return;
    }
    setState(() => _busy = true);
    try {
      await AuthRepository().verifyTotp(code);
      if (!mounted) return;
      _codeCtrl.clear();
      setState(() {
        _enabled = true;
        _setupMode = false;
        _totpUri = '';
        _backupCodes = const [];
      });
      messenger.showSnackBar(SnackBar(content: Text(t.twofaEnabledMsg)));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.twoFactorAuth,
            subtitle: t.twoFactorSubtitle,
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_setupMode ? _buildSetup(context, t) : _buildOverview(context, t)),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(BuildContext context, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _enabled ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
                color: _enabled ? const Color(0xFF22C55E) : context.c.textHint,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _enabled ? t.twofaStatusOn : t.twofaStatusOff,
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _enabled ? t.twofaOnDesc : t.twofaOffDesc,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
              height: 1.5,
            ),
          ),
          const Spacer(),
          GlossyButton(
            label: _enabled ? t.twofaDisable : t.twofaEnable,
            onPressed: _busy ? null : _onPrimary,
            isLoading: _busy,
            height: 52,
            radius: 14,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSetup(BuildContext context, AppLocalizations t) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          t.twofaSetupTitle,
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: context.c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.twofaSetupHint,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: context.c.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        if (_totpUri.isNotEmpty)
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: QrImageView(
                data: _totpUri,
                version: QrVersions.auto,
                size: 180,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          t.twofaCantScan,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: context.c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: context.c.divider,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  _manualSecret,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _manualSecret));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.twofaSecretCopied)),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.c.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.copy_rounded,
                    color: AppColors.primary, size: 20),
              ),
            ),
          ],
        ),
        if (_backupCodes.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            t.twofaBackupCodesTitle,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.twofaBackupCodesHint,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.c.divider,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              _backupCodes.join('\n'),
              style: GoogleFonts.robotoMono(
                fontSize: 14,
                height: 1.6,
                color: context.c.textPrimary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        Text(
          t.twofaEnterCode,
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: context.c.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _codeCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: GoogleFonts.urbanist(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 8,
            color: context.c.textPrimary,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '••••••',
            filled: true,
            fillColor: context.c.divider,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: context.c.border),
            ),
          ),
          onSubmitted: (_) => _verify(),
        ),
        const SizedBox(height: 24),
        GlossyButton(
          label: t.twofaVerifyEnable,
          onPressed: _busy ? null : _verify,
          isLoading: _busy,
          height: 52,
          radius: 14,
        ),
        const SizedBox(height: 8),
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
    final t = AppLocalizations.of(context);
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
        title: Text(t.support,
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
              Text(configured ? t.chatWithTeam : t.supportBeingSetup,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary)),
              const SizedBox(height: 8),
              Text(
                  configured
                      ? t.openLiveChatDesc
                      : t.supportEmailDesc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textSecondary,
                      height: 1.5)),
              const SizedBox(height: 28),
              GlossyButton(
                label: configured ? t.openLiveChat : t.emailSupport,
                onPressed: _open,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
