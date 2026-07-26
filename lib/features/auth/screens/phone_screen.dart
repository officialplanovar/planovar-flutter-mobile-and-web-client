import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../data/auth_repository.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneCtrl = TextEditingController();
  bool _saving = false;

  Future<void> _saveAndProceed() async {
    final raw = _phoneCtrl.text.trim();
    if (raw.isEmpty) {
      context.go(AppRoutes.locationPref);
      return;
    }
    setState(() => _saving = true);
    try {
      await AuthRepository().updateProfile(phone: '$_dialCode$raw');
      if (mounted) context.go(AppRoutes.locationPref);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  static const _dialCodes = [
    (code: '+234', flag: '🇳🇬', label: 'Nigeria'),
    (code: '+233', flag: '🇬🇭', label: 'Ghana'),
    (code: '+254', flag: '🇰🇪', label: 'Kenya'),
    (code: '+44', flag: '🇬🇧', label: 'UK'),
    (code: '+1', flag: '🇺🇸', label: 'USA'),
  ];

  String _dialCode = '+234';
  String _flagEmoji = '🇳🇬';

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AuthStepBar(step: 3),
            Expanded(
              child: SingleChildScrollView(
                padding: pagePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Center(
                      child: AuthIllustration(
                        pngPath: 'assets/icons/auth_phone.png',
                        fallbackIcon: Icons.phone_in_talk_rounded,
                        bgColor: const Color(0xFFE8F5FE),
                        iconColor: const Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Add your phone number',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: context.c.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'This helps us personalize your experience a little more',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textHint,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        // Dial code picker
                        GestureDetector(
                          onTap: _showDialCodeSheet,
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: context.c.surfaceElevated,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_dialCode,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: context.c.textPrimary,
                                    )),
                                const SizedBox(width: 6),
                                Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 18, color: context.c.textSecondary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Phone number field
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: context.c.surfaceElevated,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(Icons.phone_outlined,
                                    size: 18, color: context.c.textHint),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Phone Number',
                                      hintStyle: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        color: context.c.textHint,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      filled: false,
                                    ),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Text(
                                    _flagEmoji,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    GlossyButton(
                      label: _saving ? 'Saving…' : 'Proceed',
                      onPressed: _saving ? null : _saveAndProceed,
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.locationPref),
                        child: Text(
                          'Skip for now',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: context.c.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialCodeSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: _dialCodes.map((d) {
          return ListTile(
            leading: Text(d.flag, style: const TextStyle(fontSize: 24)),
            title: Text('${d.label} (${d.code})',
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w500)),
            onTap: () {
              setState(() {
                _dialCode = d.code;
                _flagEmoji = d.flag;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
