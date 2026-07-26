import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/models/user_model.dart';
import '../../auth/data/auth_repository.dart';

/// View + edit the signed-in client's profile (name, phone). The avatar is
/// shown read-only for now (image upload is a separate flow).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _repo = AuthRepository();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

  UserModel? _user;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await _repo.getMe();
      if (!mounted) return;
      setState(() {
        _user = user;
        _firstName.text = user.firstName;
        _lastName.text = user.lastName;
        _phone.text = user.phone ?? '';
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _repo.updateProfile(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      context.pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not update profile: $e'),
              backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Edit Profile',
            style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: pagePadding(context)
                    .add(const EdgeInsets.symmetric(vertical: 8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _user?.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: context.c.primaryLight,
                              child: const Icon(Icons.person_rounded,
                                  color: AppColors.primary, size: 44),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        _user?.email ?? '',
                        style: GoogleFonts.urbanist(
                            fontSize: 13, color: context.c.textHint),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _Label('First Name'),
                    _Field(controller: _firstName, hint: 'Enter first name'),
                    const SizedBox(height: 18),
                    _Label('Last Name'),
                    _Field(controller: _lastName, hint: 'Enter last name'),
                    const SizedBox(height: 18),
                    _Label('Phone Number'),
                    _Field(
                      controller: _phone,
                      hint: 'Enter phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 36),
                    GlossyButton(
                      label: 'Save Changes',
                      onPressed: _saving ? null : _save,
                      isLoading: _saving,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary)),
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  const _Field(
      {required this.controller, required this.hint, this.keyboardType});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: hint),
      );
}
