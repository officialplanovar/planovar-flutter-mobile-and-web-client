import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/theme_cubit.dart';

// ─── Theme Settings ───────────────────────────────────────────────────────────
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, current) {
        final cubit = context.read<ThemeCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Theme')),
          body: Column(
            children: [
              _ThemeOption(
                label: 'Light',
                subtitle: 'Always use light appearance',
                icon: Icons.light_mode_outlined,
                selected: current == ThemeMode.light,
                onTap: cubit.setLight,
              ),
              _ThemeOption(
                label: 'Dark',
                subtitle: 'Always use dark appearance',
                icon: Icons.dark_mode_outlined,
                selected: current == ThemeMode.dark,
                onTap: cubit.setDark,
              ),
              _ThemeOption(
                label: 'System default',
                subtitle: 'Follow device setting',
                icon: Icons.brightness_auto_outlined,
                selected: current == ThemeMode.system,
                onTap: cubit.setSystem,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
      title: Text(label, style: AppTextStyles.body1),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: selected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
      onTap: onTap,
    );
  }
}

// ─── Notification Settings ────────────────────────────────────────────────────
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _bookingUpdates = true;
  bool _quoteAlerts = true;
  bool _paymentNotifs = true;
  bool _messages = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        children: [
          _SwitchTile(
            label: 'Booking updates',
            subtitle: 'Get notified about booking status changes',
            value: _bookingUpdates,
            onChanged: (v) => setState(() => _bookingUpdates = v),
          ),
          _SwitchTile(
            label: 'Quote alerts',
            subtitle: 'Be notified when vendors send or update quotes',
            value: _quoteAlerts,
            onChanged: (v) => setState(() => _quoteAlerts = v),
          ),
          _SwitchTile(
            label: 'Payment notifications',
            subtitle: 'Receive receipts and payment confirmations',
            value: _paymentNotifs,
            onChanged: (v) => setState(() => _paymentNotifs = v),
          ),
          _SwitchTile(
            label: 'Messages',
            subtitle: 'Get notified about new messages from vendors',
            value: _messages,
            onChanged: (v) => setState(() => _messages = v),
          ),
          _SwitchTile(
            label: 'Promotions & offers',
            subtitle: 'Receive deals and featured vendor promotions',
            value: _promotions,
            onChanged: (v) => setState(() => _promotions = v),
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label, style: AppTextStyles.body1),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      activeTrackColor: AppColors.primaryLight,
    );
  }
}

// ─── Privacy Screen ────────────────────────────────────────────────────────────
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy and Security')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: const Text('Two-Factor Authentication'),
            subtitle: const Text('Not enabled'),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: const Text('Profile Visibility'),
            subtitle: const Text('Public'),
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Help Screen ───────────────────────────────────────────────────────────────
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined, color: AppColors.primary),
            title: const Text('Email Support'),
            subtitle: const Text('support@planovar.com'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
            title: const Text('Phone Support'),
            subtitle: const Text('+234 800 PLANOVAR'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.chat_outlined, color: AppColors.primary),
            title: const Text('Live Chat'),
            subtitle: const Text('Available 9am–6pm WAT'),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.quiz_outlined, color: AppColors.primary),
            title: const Text('FAQ'),
            onTap: () => context.push(AppRoutes.faq),
          ),
        ],
      ),
    );
  }
}

// ─── FAQ Screen ────────────────────────────────────────────────────────────────
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = MockData.faqs;
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text(faqs[i]['question']!, style: AppTextStyles.label),
                children: [
                  Text(
                    faqs[i]['answer']!,
                    style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Delete Account Screen ─────────────────────────────────────────────────────
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _reasons = [
    'I no longer need the app',
    'I found a better alternative',
    'Privacy concerns',
    'Too many notifications',
    'Other',
  ];
  final Set<String> _selectedReasons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We\'re sorry to see you go',
              style: AppTextStyles.heading3.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              'Deleting your account is permanent and cannot be undone. All your bookings, messages, and data will be removed.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Text('Why are you leaving?', style: AppTextStyles.label),
            const SizedBox(height: 12),
            ..._reasons.map((reason) {
              final selected = _selectedReasons.contains(reason);
              return CheckboxListTile(
                title: Text(reason, style: AppTextStyles.body2),
                value: selected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedReasons.add(reason);
                    } else {
                      _selectedReasons.remove(reason);
                    }
                  });
                },
                activeColor: AppColors.error,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              );
            }),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: _selectedReasons.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Account?'),
                          content: const Text(
                              'This action cannot be undone. Are you absolutely sure?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Delete my account'),
                            ),
                          ],
                        ),
                      );
                    },
              child: const Text('Delete my account'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Events Placeholder ────────────────────────────────────────────────────────
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events'), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note_outlined, size: 80, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('Events coming soon', style: AppTextStyles.heading4),
            const SizedBox(height: 8),
            Text(
              'Event management features are in development.',
              style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
