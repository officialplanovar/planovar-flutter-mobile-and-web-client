import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                color: AppColors.surface,
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryLight,
                      child: ClipOval(
                        child: AppNetworkImage(url: user.image, width: 80, height: 80),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: AppTextStyles.heading4),
                          const SizedBox(height: 2),
                          Text(user.email, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Menu
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Your Favourites',
                    onTap: () => context.push(AppRoutes.favourites),
                  ),
                  _MenuItem(
                    icon: Icons.star_border_rounded,
                    label: 'Reviews',
                    onTap: () => context.push(AppRoutes.reviews),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.palette_outlined,
                    label: 'Theme',
                    onTap: () => context.push(AppRoutes.themeSettings),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () => context.push(AppRoutes.notificationSettings),
                  ),
                  _MenuItem(
                    icon: Icons.lock_outline_rounded,
                    label: 'Privacy and Security',
                    onTap: () => context.push(AppRoutes.privacy),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () => context.push(AppRoutes.help),
                  ),
                  _MenuItem(
                    icon: Icons.quiz_outlined,
                    label: 'FAQ',
                    onTap: () => context.push(AppRoutes.faq),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _MenuSection(
                items: [
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Sign out',
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () {
                      context.read<AuthBloc>().add(const AuthSignOutRequested());
                    },
                  ),
                  _MenuItem(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete account',
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () => context.push(AppRoutes.deleteAccount),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;

  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(item.icon, color: item.iconColor ?? AppColors.textPrimary, size: 22),
                title: Text(
                  item.label,
                  style: AppTextStyles.body1.copyWith(color: item.textColor),
                ),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                onTap: item.onTap,
              ),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.textColor,
    this.iconColor,
    this.onTap,
  });
}
