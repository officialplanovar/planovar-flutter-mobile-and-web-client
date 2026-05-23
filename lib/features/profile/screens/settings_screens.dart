import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';

// ─── Shared header builder ────────────────────────────────────────────────────

Widget _buildLavenderHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
  bool centerTitle = false,
}) {
  return Container(
    color: const Color(0xFFECDEFA),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: centerTitle
            ? Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: _backButton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: const Color(0xFF9CA3AF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: _backButton(),
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

Widget _backButton() {
  return Container(
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
    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF1A1A2E)),
  );
}

// ─── Theme Settings ───────────────────────────────────────────────────────────
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, current) {
        final cubit = context.read<ThemeCubit>();
        return Scaffold(
          backgroundColor: const Color(0xFFF8F5FF),
          body: Column(
            children: [
              _buildLavenderHeader(
                context,
                title: 'Theme',
                subtitle: 'Select your preferred theme appearance',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Two phone preview boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ThemePreviewBox(
                            label: 'Light',
                            isDark: false,
                            selected: current == ThemeMode.light,
                            onTap: cubit.setLight,
                          ),
                          const SizedBox(width: 20),
                          _ThemePreviewBox(
                            label: 'Dark',
                            isDark: true,
                            selected: current == ThemeMode.dark,
                            onTap: cubit.setDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // System toggle
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'System',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Use your default system preference',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: current == ThemeMode.system,
                              onChanged: (v) {
                                if (v) cubit.setSystem();
                              },
                              activeThumbColor: AppColors.primary,
                              activeTrackColor: AppColors.primaryLight,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemePreviewBox extends StatelessWidget {
  final String label;
  final bool isDark;
  final bool selected;
  final VoidCallback onTap;

  const _ThemePreviewBox({
    required this.label,
    required this.isDark,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 150,
            height: 260,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.primary : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
                width: selected ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2D2D3E) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 8,
                    width: 100,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 8,
                    width: 120,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppColors.primary : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                    : null,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
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
  String _channel = 'none';
  bool _allMessages = false;
  bool _orderDelivery = false;
  bool _eventTimeline = false;
  bool _paymentAlerts = false;
  bool _quoteInvoice = false;
  bool _vendorMatch = false;

  final _channels = ['None', 'In app', 'Email', 'Both'];
  final _channelKeys = ['none', 'inapp', 'email', 'both'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Notifications',
            subtitle: 'Manage when you\'ll receive notifications',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All notifications',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose where you want to receive notifications',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 4-segment pill selector
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: List.generate(_channels.length, (i) {
                        final isActive = _channel == _channelKeys[i];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _channel = _channelKeys[i]),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isActive ? AppColors.primaryLight : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  _channels[i],
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                    color: isActive ? AppColors.primary : const Color(0xFF9CA3AF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Toggle rows
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _NotifToggle(
                          title: 'All messages',
                          subtitle: 'someone replies your message',
                          value: _allMessages,
                          onChanged: (v) => setState(() => _allMessages = v),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        _NotifToggle(
                          title: 'Order/Delivery Timeline',
                          subtitle: 'get notified when there\'s a new delivery status',
                          value: _orderDelivery,
                          onChanged: (v) => setState(() => _orderDelivery = v),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        _NotifToggle(
                          title: 'Event Timeline',
                          subtitle: 'get notified when there\'s a new event timeline',
                          value: _eventTimeline,
                          onChanged: (v) => setState(() => _eventTimeline = v),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        _NotifToggle(
                          title: 'Payment alerts',
                          subtitle: 'get notified when a payment is successful',
                          value: _paymentAlerts,
                          onChanged: (v) => setState(() => _paymentAlerts = v),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        _NotifToggle(
                          title: 'Quote / Invoice alerts',
                          subtitle: 'get notified when you get a quote',
                          value: _quoteInvoice,
                          onChanged: (v) => setState(() => _quoteInvoice = v),
                        ),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                        _NotifToggle(
                          title: 'Vendor Match',
                          subtitle: 'get alerts for recommended vendors',
                          value: _vendorMatch,
                          onChanged: (v) => setState(() => _vendorMatch = v),
                        ),
                      ],
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
}

class _NotifToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
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
      ),
    );
  }
}

// ─── Privacy Screen ────────────────────────────────────────────────────────────
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Privacy and Security',
            subtitle: 'manage your password and 2 factor authentications',
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PrivacyRow(
                      title: 'Change your password',
                      subtitle: 'Update your login credentials',
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                    _PrivacyRow(
                      title: '2 factor authentication',
                      subtitle: 'add extra layer of security',
                      onTap: () => context.push(AppRoutes.twoFactor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PrivacyRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
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
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF), size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Help Screen ───────────────────────────────────────────────────────────────
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _helpItems = [
    {
      'icon': Icons.email_rounded,
      'title': 'Email Support',
      'subtitle': 'contactplanovar@gmail.com',
      'route': '',
    },
    {
      'icon': Icons.chat_rounded,
      'title': 'Live Chat',
      'subtitle': 'chat with our support team available Mon - Fri 8am - 5pm',
      'route': AppRoutes.supportChat,
    },
    {
      'icon': Icons.phone_rounded,
      'title': 'Phone Support',
      'subtitle': '+2348488383\nMon - Fri 8am - 5pm',
      'route': '',
    },
    {
      'icon': Icons.help_outline_rounded,
      'title': 'FAQ',
      'subtitle': 'Get answers to your burning questions',
      'route': AppRoutes.faq,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Help & Support',
            subtitle: 'Get real time help for all your inquires',
            centerTitle: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.urbanist(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search for help',
                              hintStyle: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: const Color(0xFF9CA3AF),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...(_helpItems as List<Map<String, dynamic>>).map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final route = item['route'] as String;
                          if (route.isNotEmpty) context.push(route);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['subtitle'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.north_east_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAQ Screen ────────────────────────────────────────────────────────────────
class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int? _expandedIndex;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = MockData.faqs;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'Frequently Asked Questions',
            subtitle: 'Answers to your burning questions',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            style: GoogleFonts.urbanist(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search FAQs',
                              hintStyle: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: const Color(0xFF9CA3AF),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(faqs.length, (i) {
                    final isExpanded = _expandedIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _expandedIndex = isExpanded ? null : i;
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      faqs[i]['question']!,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A1A2E),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 10),
                                Text(
                                  faqs[i]['answer']!,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: const Color(0xFF6B7280),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
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
  String? _selectedReason;
  final _otherCtrl = TextEditingController();

  static const _reasons = [
    'No longer using the platform/service',
    'Found a better alternative',
    'Privacy Concerns',
    'Too many emails/notifications',
    'Difficulty navigating the platform',
    'Personal Reasons',
    'Other not listed above',
  ];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: 'We\'re sad to see you go',
            subtitle: 'Let us know what went wrong',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text('😢', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  // Reasons card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      children: List.generate(_reasons.length, (i) {
                        final reason = _reasons[i];
                        final isSelected = _selectedReason == reason;
                        final isOther = reason == 'Other not listed above';
                        return Column(
                          children: [
                            if (i > 0)
                              const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
                            GestureDetector(
                              onTap: () => setState(() => _selectedReason = reason),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? AppColors.primary : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : const Color(0xFFD1D5DB),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? const Icon(Icons.check_rounded,
                                                  color: Colors.white, size: 14)
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            reason,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF1A1A2E),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isOther && isSelected) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: TextField(
                                          controller: _otherCtrl,
                                          maxLines: 3,
                                          style: GoogleFonts.urbanist(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: 'Tell us more...',
                                            hintStyle: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              color: const Color(0xFF9CA3AF),
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.all(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => _showDeleteConfirmDialog(context),
                    child: Container(
                      height: 52,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Delete Account',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
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
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF6B7280)),
                  ),
                ),
              ),
              const Text('⚠️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Are you sure?',
                style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'by deleting your account you will lose the following',
                style: GoogleFonts.urbanist(fontSize: 14, color: const Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  border: Border.all(color: const Color(0xFFFBBF24)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '• Access to your active events',
                    '• Access to your account records and credentials',
                    '• Login details',
                    '• All Vendor contacts via message and call',
                  ].map((line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      line,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 20),
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
                      onTap: () => Navigator.pop(dialogCtx),
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

// ─── Events Placeholder (kept for backward compat) ────────────────────────────
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Events'), automaticallyImplyLeading: false),
      body: const Center(child: Text('Events')),
    );
  }
}
