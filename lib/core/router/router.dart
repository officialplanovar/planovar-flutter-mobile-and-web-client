import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/verify_otp_screen.dart';
import '../../features/auth/screens/phone_screen.dart';
import '../../features/auth/screens/location_preference_screen.dart';
import '../../features/auth/screens/category_preference_screen.dart';
import '../../features/auth/screens/create_password_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/home/screens/home_feed_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/profile/screens/settings_screens.dart';
import '../../features/vendor/screens/vendor_profile_screen.dart';
import '../../features/listing/screens/listing_detail_screen.dart';
import '../../features/booking/screens/bookings_screen.dart';
import '../../features/booking/screens/booking_detail_screen.dart';
import '../../features/booking/screens/new_booking_screen.dart';
import '../../features/quote/screens/quote_detail_screen.dart';
import '../../features/messaging/screens/messages_screen.dart';
import '../../features/messaging/screens/chat_screen.dart';
import '../../features/payments/screens/payments_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/favourites_screen.dart';
import '../../features/profile/screens/reviews_screen.dart';
import '../../features/profile/screens/settings_screens.dart' show
    ThemeSettingsScreen, NotificationSettingsScreen, PrivacyScreen,
    HelpScreen, FaqScreen, DeleteAccountScreen, EventsScreen;
import 'app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      // Splash handles its own navigation — no redirect needed for '/'
      if (state.matchedLocation == AppRoutes.splash) return null;
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final authPaths = [
        AppRoutes.splash, AppRoutes.onboarding, AppRoutes.login,
        AppRoutes.register, AppRoutes.verifyOtp, AppRoutes.phone,
        AppRoutes.locationPref, AppRoutes.categoryPref,
        AppRoutes.createPassword, AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
      ];
      final currentPath = state.matchedLocation;
      final isOnAuthRoute = authPaths.any((p) => currentPath.startsWith(p.replaceAll(':id', '')));
      if (!isLoggedIn && !isOnAuthRoute) return AppRoutes.onboarding;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      // Auth routes
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return VerifyOtpScreen(
            email: extra['email'] as String? ?? '',
            purpose: extra['purpose'] as String? ?? 'register',
          );
        },
      ),
      GoRoute(path: AppRoutes.phone, builder: (_, __) => const PhoneScreen()),
      GoRoute(path: AppRoutes.locationPref, builder: (_, __) => const LocationPreferenceScreen()),
      GoRoute(path: AppRoutes.categoryPref, builder: (_, __) => const CategoryPreferenceScreen()),
      GoRoute(path: AppRoutes.createPassword, builder: (_, __) => const CreatePasswordScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ResetPasswordScreen(email: extra['email'] as String? ?? '');
        },
      ),

      // Shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.homeFeed, builder: (_, __) => const HomeFeedScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.explore, builder: (_, __) => const ExploreScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.events, builder: (_, __) => const EventsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.messages, builder: (_, __) => const MessagesScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen())],
          ),
        ],
      ),

      // Vendor
      GoRoute(
        path: AppRoutes.vendorProfile,
        builder: (_, state) => VendorProfileScreen(vendorId: state.pathParameters['id']!),
      ),

      // Listing
      GoRoute(
        path: AppRoutes.listingDetail,
        builder: (_, state) => ListingDetailScreen(listingId: state.pathParameters['id']!),
      ),

      // Bookings
      GoRoute(path: AppRoutes.bookings, builder: (_, __) => const BookingsScreen()),
      GoRoute(
        path: AppRoutes.newBooking,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return NewBookingScreen(listingId: extra['listingId'] as String? ?? '');
        },
      ),
      GoRoute(
        path: AppRoutes.bookingDetail,
        builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),

      // Quotes
      GoRoute(
        path: AppRoutes.quoteDetail,
        builder: (_, state) => QuoteDetailScreen(quoteId: state.pathParameters['id']!),
      ),

      // Conversations
      GoRoute(
        path: AppRoutes.conversationDetail,
        builder: (_, state) => ChatScreen(conversationId: state.pathParameters['id']!),
      ),

      // Payments
      GoRoute(path: AppRoutes.payments, builder: (_, __) => const PaymentsScreen()),

      // Notifications
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),

      // Profile sub-pages
      GoRoute(path: AppRoutes.favourites, builder: (_, __) => const FavouritesScreen()),
      GoRoute(path: AppRoutes.reviews, builder: (_, __) => const ReviewsScreen()),
      GoRoute(path: AppRoutes.themeSettings, builder: (_, __) => const ThemeSettingsScreen()),
      GoRoute(path: AppRoutes.notificationSettings, builder: (_, __) => const NotificationSettingsScreen()),
      GoRoute(path: AppRoutes.privacy, builder: (_, __) => const PrivacyScreen()),
      GoRoute(path: AppRoutes.help, builder: (_, __) => const HelpScreen()),
      GoRoute(path: AppRoutes.faq, builder: (_, __) => const FaqScreen()),
      GoRoute(path: AppRoutes.deleteAccount, builder: (_, __) => const DeleteAccountScreen()),
    ],
  );
}

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const _AppShell({required this.shell});

  static const _tabs = [
    (icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Explore'),
    (icon: Icons.event_outlined, activeIcon: Icons.event_rounded, label: 'Events'),
    (icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Messages'),
    (icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final i = entry.key;
                final tab = entry.value;
                final isActive = shell.currentIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => shell.goBranch(i, initialLocation: i == shell.currentIndex),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive ? AppColors.primary : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tab.label,
                          style: AppTextStyles.caption.copyWith(
                            color: isActive ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
