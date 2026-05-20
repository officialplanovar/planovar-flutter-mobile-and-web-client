import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  bool get _hasCapital => _passwordCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _passwordCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _passwordCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  bool get _hasLength => _passwordCtrl.text.length >= 8;
  bool get _passwordsMatch =>
      _passwordCtrl.text == _confirmCtrl.text && _confirmCtrl.text.isNotEmpty;
  bool get _allCriteriaMet =>
      _hasCapital && _hasNumber && _hasSpecial && _hasLength && _passwordsMatch;

  int get _strengthLevel {
    int l = 0;
    if (_hasLength) l++;
    if (_hasCapital) l++;
    if (_hasNumber) l++;
    if (_hasSpecial) l++;
    return l;
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AuthStepBar(step: 5),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Center(
                      child: AuthIllustration(
                        svgPath: 'assets/icons/auth_password.svg',
                        fallbackIcon: Icons.lock_rounded,
                        bgColor: const Color(0xFFF3F0FF),
                        iconColor: const Color(0xFF7C4DFF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Create a Strong Password',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _FieldLabel('New Password'),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure1,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure1
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscure1 = !_obscure1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('Confirm Password'),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscure2,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure2
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () =>
                              setState(() => _obscure2 = !_obscure2),
                        ),
                        errorText: _confirmCtrl.text.isNotEmpty &&
                                !_passwordsMatch
                            ? 'Passwords do not match'
                            : null,
                      ),
                    ),
                    if (_passwordCtrl.text.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _StrengthBar(level: _strengthLevel),
                      const SizedBox(height: 20),
                      _CriteriaRow(
                        met: _hasCapital,
                        label: 'Should have a Capital Letter',
                      ),
                      const SizedBox(height: 10),
                      _CriteriaRow(
                        met: _hasNumber,
                        label: 'Should have a Number e.g 1,2,4,etc',
                      ),
                      const SizedBox(height: 10),
                      _CriteriaRow(
                        met: _hasSpecial,
                        label: 'Should have a Special Character e.g @,\$,%,etc',
                      ),
                    ],
                    const SizedBox(height: 36),
                    GlossyButton(
                      label: 'Proceed',
                      onPressed: _allCriteriaMet
                          ? () => context.go(AppRoutes.categoryPref)
                          : null,
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
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final int level;
  const _StrengthBar({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final filled = i < level;
        Color color;
        if (!filled) {
          color = const Color(0xFFE0E0E0);
        } else if (level <= 2) {
          color = const Color(0xFFFFCA28);
        } else if (level == 3) {
          color = const Color(0xFF66BB6A);
        } else {
          color = const Color(0xFF43A047);
        }
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}

class _CriteriaRow extends StatelessWidget {
  final bool met;
  final String label;
  const _CriteriaRow({required this.met, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: met ? AppColors.primary : const Color(0xFFD1D1D1),
              width: 2,
            ),
            color: met ? AppColors.primary : Colors.transparent,
          ),
          child: met
              ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: met ? const Color(0xFF1A1A1A) : const Color(0xFF6B7280),
              fontWeight: met ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
