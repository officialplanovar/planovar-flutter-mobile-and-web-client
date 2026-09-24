import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../l10n/app_localizations.dart';

// ─── Shared header builder ────────────────────────────────────────────────────

Widget _buildLavenderHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
  bool centerTitle = false,
}) {
  return Container(
    color: context.c.primaryLight,
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
                        child: _backButton(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textHint,
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
                    child: _backButton(context),
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

Widget _backButton(BuildContext context) {
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
    child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: context.c.textPrimary),
  );
}

// ─── Theme Settings ───────────────────────────────────────────────────────────
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, current) {
        final t = AppLocalizations.of(context);
        final cubit = context.read<ThemeCubit>();
        return Scaffold(
          backgroundColor: context.c.background,
          body: Column(
            children: [
              _buildLavenderHeader(
                context,
                title: t.theme,
                subtitle: t.themeScreenSubtitle,
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
                            label: t.lightLabel,
                            isDark: false,
                            selected: current == ThemeMode.light,
                            onTap: cubit.setLight,
                          ),
                          const SizedBox(width: 20),
                          _ThemePreviewBox(
                            label: t.darkLabel,
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
                          color: context.c.surface,
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
                                    t.systemLabel,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.systemSubtitle,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: context.c.textHint,
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
                              activeTrackColor: context.c.primaryLight,
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
                  color: context.c.textPrimary,
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

  final _channelKeys = ['none', 'inapp', 'email', 'both'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await AuthRepository().getNotificationPrefs();
      if (!mounted) return;
      setState(() {
        _channel = p['channel'] as String? ?? _channel;
        _allMessages = p['allMessages'] as bool? ?? _allMessages;
        _orderDelivery = p['orderDelivery'] as bool? ?? _orderDelivery;
        _eventTimeline = p['eventTimeline'] as bool? ?? _eventTimeline;
        _paymentAlerts = p['paymentAlerts'] as bool? ?? _paymentAlerts;
        _quoteInvoice = p['quoteInvoice'] as bool? ?? _quoteInvoice;
        _vendorMatch = p['vendorMatch'] as bool? ?? _vendorMatch;
      });
    } catch (_) {
      // Keep defaults if prefs can't be loaded.
    }
  }

  /// Persist current prefs (fire-and-forget; UI already updated optimistically).
  void _save() {
    AuthRepository().updateNotificationPrefs({
      'channel': _channel,
      'allMessages': _allMessages,
      'orderDelivery': _orderDelivery,
      'eventTimeline': _eventTimeline,
      'paymentAlerts': _paymentAlerts,
      'quoteInvoice': _quoteInvoice,
      'vendorMatch': _vendorMatch,
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final channels = [t.channelNone, t.channelInApp, t.channelEmail, t.channelBoth];
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.notificationsTitle,
            subtitle: t.notifSettingsSubtitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.allNotifications,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.notifChannelDesc,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 4-segment pill selector
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.c.border),
                    ),
                    child: Row(
                      children: List.generate(channels.length, (i) {
                        final isActive = _channel == _channelKeys[i];
                        return Expanded(
                          child: GestureDetector(
                            onTap: () { setState(() => _channel = _channelKeys[i]); _save(); },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isActive ? context.c.primaryLight : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  channels[i],
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                    color: isActive ? AppColors.primary : context.c.textHint,
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
                      color: context.c.surface,
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
                          title: t.notifAllMessages,
                          subtitle: t.notifAllMessagesSub,
                          value: _allMessages,
                          onChanged: (v) { setState(() => _allMessages = v); _save(); },
                        ),
                        Divider(height: 1, thickness: 1, color: context.c.divider),
                        _NotifToggle(
                          title: t.notifOrderDelivery,
                          subtitle: t.notifOrderDeliverySub,
                          value: _orderDelivery,
                          onChanged: (v) { setState(() => _orderDelivery = v); _save(); },
                        ),
                        Divider(height: 1, thickness: 1, color: context.c.divider),
                        _NotifToggle(
                          title: t.notifEventTimeline,
                          subtitle: t.notifEventTimelineSub,
                          value: _eventTimeline,
                          onChanged: (v) { setState(() => _eventTimeline = v); _save(); },
                        ),
                        Divider(height: 1, thickness: 1, color: context.c.divider),
                        _NotifToggle(
                          title: t.notifPayment,
                          subtitle: t.notifPaymentSub,
                          value: _paymentAlerts,
                          onChanged: (v) { setState(() => _paymentAlerts = v); _save(); },
                        ),
                        Divider(height: 1, thickness: 1, color: context.c.divider),
                        _NotifToggle(
                          title: t.notifQuote,
                          subtitle: t.notifQuoteSub,
                          value: _quoteInvoice,
                          onChanged: (v) { setState(() => _quoteInvoice = v); _save(); },
                        ),
                        Divider(height: 1, thickness: 1, color: context.c.divider),
                        _NotifToggle(
                          title: t.notifVendorMatch,
                          subtitle: t.notifVendorMatchSub,
                          value: _vendorMatch,
                          onChanged: (v) { setState(() => _vendorMatch = v); _save(); },
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: context.c.primaryLight,
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
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.privacySecurity,
            subtitle: t.privacyScreenSubtitle,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: context.c.surface,
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
                      title: t.changeYourPassword,
                      subtitle: t.changePasswordRowSub,
                      onTap: () => context.push(AppRoutes.changePassword),
                    ),
                    Divider(height: 1, thickness: 1, color: context.c.divider),
                    _PrivacyRow(
                      title: t.twoFactorRow,
                      subtitle: t.twoFactorRowSub,
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
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
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
            Icon(Icons.chevron_right_rounded, color: context.c.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Help Screen ───────────────────────────────────────────────────────────────
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final helpItems = <Map<String, dynamic>>[
      {'icon': Icons.email_rounded, 'title': t.emailSupportTitle, 'subtitle': 'contactplanovar@gmail.com', 'route': ''},
      {'icon': Icons.chat_rounded, 'title': t.liveChat, 'subtitle': t.liveChatSub, 'route': AppRoutes.supportChat},
      {'icon': Icons.phone_rounded, 'title': t.phoneSupport, 'subtitle': '+2348488383\nMon - Fri 8am - 5pm', 'route': ''},
      {'icon': Icons.help_outline_rounded, 'title': t.faqTitle, 'subtitle': t.faqSub, 'route': AppRoutes.faq},
    ];
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.helpAndSupport,
            subtitle: t.helpScreenSubtitle,
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
                      color: context.c.surface,
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
                              hintText: t.searchForHelp,
                              hintStyle: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: context.c.textHint,
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
                  ...helpItems.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: context.c.surface,
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
                                  color: context.c.primaryLight,
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
                                        color: context.c.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['subtitle'] as String,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        color: context.c.textHint,
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
    final t = AppLocalizations.of(context);
    final faqs = [
      (t.faqQ1, t.faqA1),
      (t.faqQ2, t.faqA2),
      (t.faqQ3, t.faqA3),
      (t.faqQ4, t.faqA4),
      (t.faqQ5, t.faqA5),
      (t.faqQ6, t.faqA6),
    ];
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildLavenderHeader(
            context,
            title: t.faqScreenTitle,
            subtitle: t.faqScreenSubtitle,
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
                      color: context.c.surface,
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
                              hintText: t.searchFaqs,
                              hintStyle: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: context.c.textHint,
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
                          color: context.c.surface,
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
                                      faqs[i].$1,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: context.c.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: context.c.textHint,
                                  ),
                                ],
                              ),
                              if (isExpanded) ...[
                                const SizedBox(height: 10),
                                Text(
                                  faqs[i].$2,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: context.c.textSecondary,
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

  String _reasonLabel(AppLocalizations t, String reason) {
    switch (reason) {
      case 'No longer using the platform/service':
        return t.deleteReason1;
      case 'Found a better alternative':
        return t.deleteReason2;
      case 'Privacy Concerns':
        return t.deleteReason3;
      case 'Too many emails/notifications':
        return t.deleteReason4;
      case 'Difficulty navigating the platform':
        return t.deleteReason5;
      case 'Personal Reasons':
        return t.deleteReason6;
      default:
        return t.deleteReason7;
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
            title: t.sadToSeeYouGo,
            subtitle: t.letUsKnow,
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
                      color: context.c.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.c.border),
                    ),
                    child: Column(
                      children: List.generate(_reasons.length, (i) {
                        final reason = _reasons[i];
                        final isSelected = _selectedReason == reason;
                        final isOther = reason == 'Other not listed above';
                        return Column(
                          children: [
                            if (i > 0)
                              Divider(height: 1, thickness: 1, color: context.c.divider),
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
                                            _reasonLabel(t, reason),
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: context.c.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isOther && isSelected) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context.c.divider,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: TextField(
                                          controller: _otherCtrl,
                                          maxLines: 3,
                                          style: GoogleFonts.urbanist(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: t.tellUsMore,
                                            hintStyle: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              color: context.c.textHint,
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
                          t.deleteAccountBtn,
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

  Future<void> _performDelete() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AuthRepository().deleteAccount();
      if (!mounted) return;
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    }
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    final t = AppLocalizations.of(context);
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
              const Text('⚠️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                t.areYouSure,
                style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                t.deleteAccountWarning,
                style: GoogleFonts.urbanist(fontSize: 14, color: context.c.textSecondary),
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
                    t.deleteLoss1,
                    t.deleteLoss2,
                    t.deleteLoss3,
                    t.deleteLoss4,
                  ].map((line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      line,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textPrimary,
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
                            t.cancel,
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
                        _performDelete();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.error, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            t.proceed,
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
      appBar: AppBar(title: Text(AppLocalizations.of(context).segMyEvents), automaticallyImplyLeading: false),
      body: Center(child: Text(AppLocalizations.of(context).navEvents)),
    );
  }
}
