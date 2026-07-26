import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/event_service.dart';
import '../../../core/services/vendor_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/user_model.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? _events;
  int? _orders;
  int? _saved;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final results = await Future.wait([
        EventService().getEvents(),
        BookingService().getBookings(),
        VendorService().getFavourites(),
      ]);
      if (!mounted) return;
      setState(() {
        _events = (results[0] as List).length;
        _orders = (results[1] as List).length;
        _saved = (results[2] as List).length;
      });
    } catch (_) {
      // Leave counts null → shown as '—'.
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: context.c.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              _buildHeader(context, user),
              const SizedBox(height: 16),

              // ── Stats card ──────────────────────────────────────────────────
              _buildStatsCard(context),
              const SizedBox(height: 24),

              // ── My Account section ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  'My account',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildAccountCard(context),
              const SizedBox(height: 20),

              // ── Settings section ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Text(
                  'Settings',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildSettingsCard(context),
              const SizedBox(height: 24),

              // ── Sign out button ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _showSignOutDialog(context),
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.error, width: 1.5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Sign out',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Clear the shell's bottom navigation bar so the sign-out button
              // isn't overlapped.
              SizedBox(height: 110 + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.c.primaryLight, context.c.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    user?.image ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: context.c.primaryLight,
                      child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user?.name ?? 'Your profile',
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: context.c.textHint,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () async {
                  await context.push(AppRoutes.editProfile);
                  if (context.mounted) {
                    context.read<AuthBloc>().add(const AuthCheckRequested());
                  }
                },
                icon: const Icon(Icons.edit_rounded, size: 15),
                label: const Text('Edit Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  textStyle: GoogleFonts.urbanist(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatCol(value: _events?.toString() ?? '—', label: 'Events'),
            VerticalDivider(width: 1, thickness: 1, color: context.c.border),
            _StatCol(value: _orders?.toString() ?? '—', label: 'Orders'),
            VerticalDivider(width: 1, thickness: 1, color: context.c.border),
            _StatCol(value: _saved?.toString() ?? '—', label: 'Saved'),
            VerticalDivider(width: 1, thickness: 1, color: context.c.border),
            const _StatCol(value: '—', label: 'Reviews'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.favorite_rounded,
            label: 'Saved Vendors',
            subtitle: 'Your Wishlist',
            onTap: () => context.push(AppRoutes.favourites),
          ),
          Divider(height: 1, thickness: 1, color: context.c.divider),
          _ProfileRow(
            icon: Icons.star_rounded,
            label: 'My Reviews',
            subtitle: 'View your overall ratings from vendors',
            onTap: () => context.push(AppRoutes.reviews),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileRow(
            icon: Icons.palette_rounded,
            label: 'Theme',
            subtitle: 'Select your preferred display',
            onTap: () => context.push(AppRoutes.themeSettings),
          ),
          Divider(height: 1, thickness: 1, color: context.c.divider),
          _ProfileRow(
            icon: Icons.notifications_rounded,
            label: 'Notifications',
            subtitle: 'Manage alerts & preferences',
            onTap: () => context.push(AppRoutes.notificationSettings),
          ),
          Divider(height: 1, thickness: 1, color: context.c.divider),
          _ProfileRow(
            icon: Icons.lock_rounded,
            label: 'Privacy and Security',
            subtitle: 'Account security settings',
            onTap: () => context.push(AppRoutes.privacy),
          ),
          Divider(height: 1, thickness: 1, color: context.c.divider),
          _ProfileRow(
            icon: Icons.help_outline_rounded,
            label: 'Help and Support',
            subtitle: 'Visit our help centre for inquiries',
            onTap: () => context.push(AppRoutes.help),
          ),
          Divider(height: 1, thickness: 1, color: context.c.divider),
          _ProfileRow(
            icon: Icons.delete_outline_rounded,
            label: 'Delete your account',
            subtitle: 'Permanently delete your account',
            onTap: () => context.push(AppRoutes.deleteAccount),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogCtx),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.c.divider,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.close_rounded, size: 18, color: context.c.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Sign out',
                style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to sign out',
                style: GoogleFonts.urbanist(fontSize: 14, color: context.c.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(dialogCtx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(dialogCtx);
                        context.read<AuthBloc>().add(const AuthSignOutRequested());
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.error, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Proceed',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCol extends StatelessWidget {
  final String value;
  final String label;
  const _StatCol({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: context.c.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.c.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: context.c.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.c.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}
