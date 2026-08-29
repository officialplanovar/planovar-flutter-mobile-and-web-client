import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../state/overlay_state.dart';
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
import '../../features/booking/screens/service_details_screen.dart';
import '../../features/booking/screens/awaiting_response_screen.dart';
import '../../features/booking/screens/confirm_quote_screen.dart';
import '../../features/quote/screens/quote_detail_screen.dart';
import '../../features/messaging/screens/messages_screen.dart';
import '../../features/messaging/screens/chat_screen.dart';
import '../../features/payments/screens/payments_screen.dart';
import '../../features/payments/screens/process_payment_screen.dart';
import '../../features/payments/screens/payment_success_screen.dart';
import '../../features/explore/screens/category_results_screen.dart';
import '../../features/booking/screens/checkout_screen.dart';
import '../../features/booking/screens/rent_product_screen.dart';
import '../../features/booking/screens/booking_confirmed_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/favourites_screen.dart';
import '../../features/profile/screens/reviews_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/language_screen.dart';
import '../../features/profile/screens/settings_screens.dart' show
    ThemeSettingsScreen, NotificationSettingsScreen, PrivacyScreen,
    HelpScreen, FaqScreen, DeleteAccountScreen;
import '../../features/profile/screens/security_screens.dart';
import '../../features/events/screens/my_events_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/events/screens/booking_detail_screen.dart';
import '../../features/events/screens/group_chat_screen.dart';
import '../../shared/models/vendor_model.dart';
import '../../features/events/screens/raise_dispute_screen.dart';
import '../../features/events/screens/review_screen.dart';
import '../../features/events/screens/order_detail_screen.dart';
import '../../features/events/screens/rental_detail_screen.dart';
import '../../features/events/screens/cancel_order_screen.dart';
import '../../features/events/screens/request_refund_screen.dart';
import '../../features/events/screens/create_event_step1_screen.dart';
import '../../features/events/screens/create_event_step2_screen.dart';
import '../../features/events/screens/create_event_step3_screen.dart';
import '../../features/events/screens/create_event_step4_screen.dart';
import 'app_routes.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    redirect: (context, state) async {
      debugPrint('[router] redirect fired for matchedLocation=${state.matchedLocation} uri=${state.uri}');
      // Splash handles its own navigation — no redirect needed for '/'
      if (state.matchedLocation == AppRoutes.splash) {
        debugPrint('[router] on splash, no redirect');
        return null;
      }
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
      debugPrint('[router] isLoggedIn=$isLoggedIn isOnAuthRoute=$isOnAuthRoute currentPath=$currentPath');
      if (!isLoggedIn && !isOnAuthRoute) {
        debugPrint('[router] redirecting to onboarding');
        return AppRoutes.onboarding;
      }
      debugPrint('[router] no redirect');
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      // Auth routes
      GoRoute(path: AppRoutes.onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) {
        debugPrint('[router] building LoginScreen route');
        return const LoginScreen();
      }),
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
          return ResetPasswordScreen(
            email: extra['email'] as String? ?? '',
            otp: extra['otp'] as String? ?? '',
          );
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
            routes: [GoRoute(path: AppRoutes.events, builder: (_, __) => const MyEventsScreen())],
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
        builder: (_, state) => VendorProfileScreen(
          vendorId: state.pathParameters['id']!,
          eventId: (state.extra as Map<String, dynamic>?)?['eventId'] as String?,
          eventName:
              (state.extra as Map<String, dynamic>?)?['eventName'] as String?,
        ),
      ),

      // Listing
      GoRoute(
        path: AppRoutes.listingDetail,
        builder: (_, state) => ListingDetailScreen(
          listingId: state.pathParameters['id']!,
          eventId: (state.extra as Map<String, dynamic>?)?['eventId'] as String?,
          eventName:
              (state.extra as Map<String, dynamic>?)?['eventName'] as String?,
        ),
      ),

      // Bookings — literal paths must come before /bookings/:id
      GoRoute(path: AppRoutes.bookings, builder: (_, __) => const BookingsScreen()),
      GoRoute(
        path: AppRoutes.newBooking,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return NewBookingScreen(listingId: extra['listingId'] as String? ?? '');
        },
      ),

      // Service details & quote flow (all before /bookings/:id to avoid param capture)
      GoRoute(
        path: AppRoutes.serviceDetails,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ServiceDetailsScreen(
            listingId: extra['listingId'] as String? ?? '',
            eventId: extra['eventId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.confirmQuote,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ConfirmQuoteScreen(
            listingId: extra['listingId'] as String? ?? '',
            eventId: extra['eventId'] as String? ?? '',
            preferredDate: extra['preferredDate'] as String?,
            notes: extra['notes'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.awaitingResponse,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AwaitingResponseScreen(
            vendorName: extra['vendorName'] as String? ?? 'Vendor',
            bookingRef: extra['bookingRef'] as String? ?? '#PN-49204',
            date: extra['date'] as String? ?? 'TBD',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.bookingConfirmed,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BookingConfirmedScreen(
            vendorName: extra['vendorName'] as String? ?? 'Vendor',
            bookingRef: extra['bookingRef'] as String? ?? '#PN-49204',
            date: extra['date'] as String? ?? 'TBD',
          );
        },
      ),

      // Event creation flow
      GoRoute(
        path: AppRoutes.createEventStep1,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CreateEventStep1Screen(
            fromListingId: extra['fromListingId'] as String?,
            fromVendorId: extra['fromVendorId'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createEventStep2,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CreateEventStep2Screen(eventData: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.createEventStep3,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CreateEventStep3Screen(eventData: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.createEventStep4,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CreateEventStep4Screen(eventData: extra);
        },
      ),

      // Event detail
      GoRoute(
        path: AppRoutes.eventDetail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return EventDetailScreen(eventId: extra['eventId'] as String? ?? '');
        },
      ),

      // Event group chat
      GoRoute(
        path: AppRoutes.eventGroupChat,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final rawVendors = extra['groupVendors'];
          final groupVendors = rawVendors is List
              ? rawVendors.whereType<VendorModel>().toList()
              : <VendorModel>[];
          return EventGroupChatScreen(
            eventId: extra['eventId'] as String? ?? '',
            eventName: extra['eventName'] as String? ?? 'Group Chat',
            conversationId: extra['conversationId'] as String?,
            groupVendors: groupVendors,
          );
        },
      ),

      // Event booking detail
      GoRoute(
        path: AppRoutes.eventBookingDetail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return EventBookingDetailScreen(
            vendorName: extra['vendorName'] as String? ?? 'Vendor',
            bookingStatus: extra['bookingStatus'] as String? ?? 'awaiting',
          );
        },
      ),

      // Raise dispute
      GoRoute(
        path: AppRoutes.raiseDispute,
        builder: (_, __) => const RaiseDisputeScreen(),
      ),

      // Order detail
      GoRoute(
        path: AppRoutes.orderDetail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OrderDetailScreen(
            listingId: extra['listingId'] as String? ?? '',
            status: extra['status'] as String? ?? 'pending',
          );
        },
      ),

      // Rental detail
      GoRoute(
        path: AppRoutes.rentalDetail,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return RentalDetailScreen(
            listingId: extra['listingId'] as String? ?? '',
          );
        },
      ),

      // Cancel order
      GoRoute(
        path: AppRoutes.cancelOrder,
        builder: (_, __) => const CancelOrderScreen(),
      ),

      // Request refund
      GoRoute(
        path: AppRoutes.requestRefund,
        builder: (_, __) => const RequestRefundScreen(),
      ),

      // Leave review
      GoRoute(
        path: AppRoutes.leaveReview,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return LeaveReviewScreen(
            vendorName: extra['vendorName'] as String? ?? 'Vendor',
            bookingId: extra['bookingId'] as String?,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.bookingDetail,
        builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),

      // Category results
      GoRoute(
        path: AppRoutes.categoryResults,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CategoryResultsScreen(
            categorySlug: state.pathParameters['slug']!,
            categoryName: extra['categoryName'] as String? ?? '',
          );
        },
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
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CheckoutScreen(
            listingId: extra['listingId'] as String? ?? '',
            eventId: extra['eventId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.rentProduct,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return RentProductScreen(
            listingId: extra['listingId'] as String? ?? '',
            eventId: extra['eventId'] as String? ?? '',
          );
        },
      ),
      GoRoute(path: AppRoutes.payments, builder: (_, __) => const PaymentsScreen()),
      GoRoute(
        path: AppRoutes.processPayment,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ProcessPaymentScreen(
            vendorName: extra['vendorName'] as String?,
            amount: extra['amount'] as double?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentSuccessScreen(
            eventId: extra['eventId'] as String? ?? '',
            vendorName: extra['vendorName'] as String? ?? 'Vendor',
            eventDate: extra['eventDate'] as DateTime? ?? DateTime.now(),
          );
        },
      ),

      // Notifications
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),

      // Profile sub-pages
      GoRoute(path: AppRoutes.favourites, builder: (_, __) => const FavouritesScreen()),
      GoRoute(path: AppRoutes.reviews, builder: (_, __) => const ReviewsScreen()),
      GoRoute(path: AppRoutes.editProfile, builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.language, builder: (_, __) => const LanguageScreen()),
      GoRoute(path: AppRoutes.themeSettings, builder: (_, __) => const ThemeSettingsScreen()),
      GoRoute(path: AppRoutes.notificationSettings, builder: (_, __) => const NotificationSettingsScreen()),
      GoRoute(path: AppRoutes.privacy, builder: (_, __) => const PrivacyScreen()),
      GoRoute(path: AppRoutes.help, builder: (_, __) => const HelpScreen()),
      GoRoute(path: AppRoutes.faq, builder: (_, __) => const FaqScreen()),
      GoRoute(path: AppRoutes.deleteAccount, builder: (_, __) => const DeleteAccountScreen()),
      GoRoute(path: AppRoutes.changePassword, builder: (_, __) => const ChangePasswordScreen()),
      GoRoute(path: AppRoutes.twoFactor, builder: (_, __) => const TwoFactorScreen()),
      GoRoute(path: AppRoutes.supportChat, builder: (_, __) => const SupportChatScreen()),
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

  /// Localized nav label for tab [i]; falls back to the English label.
  static String _navLabel(BuildContext context, int i) {
    final t = AppLocalizations.of(context);
    switch (i) {
      case 0:
        return t.navHome;
      case 1:
        return t.navExplore;
      case 2:
        return t.navEvents;
      case 3:
        return t.navMessages;
      case 4:
        return t.navProfile;
      default:
        return _tabs[i].label;
    }
  }

  Widget _buildNavBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: context.c.surface.withValues(alpha: 0.82),
            border: Border(
              top: BorderSide(color: context.c.border, width: 0.5),
            ),
          ),
          height: 56 + bottomPadding,
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final i = entry.key;
              final tab = entry.value;
              final isActive = shell.currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => shell.goBranch(i,
                      initialLocation: i == shell.currentIndex),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: isActive ? 14 : 0,
                        vertical: isActive ? 5 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(
                                alpha: context.isDark ? 0.22 : 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                        border: isActive
                            ? Border.all(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                width: 0.5,
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive ? tab.activeIcon : tab.icon,
                            color: isActive
                                ? AppColors.primary
                                : context.c.textSecondary,
                            size: 24,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _navLabel(context, i),
                            style: AppTextStyles.caption(context).copyWith(
                              color: isActive
                                  ? AppColors.primary
                                  : context.c.textSecondary,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Side navigation rail for wide/desktop layouts, replacing the bottom bar.
  Widget _buildSideRail(BuildContext context) {
    return NavigationRail(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: (i) =>
          shell.goBranch(i, initialLocation: i == shell.currentIndex),
      labelType: NavigationRailLabelType.all,
      backgroundColor: context.c.surface,
      groupAlignment: -0.85,
      indicatorColor:
          AppColors.primary.withValues(alpha: context.isDark ? 0.22 : 0.12),
      selectedIconTheme: const IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(color: context.c.textSecondary),
      selectedLabelTextStyle: AppTextStyles.caption(context)
          .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      unselectedLabelTextStyle: AppTextStyles.caption(context)
          .copyWith(color: context.c.textSecondary),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 52,
          height: 52,
          errorBuilder: (_, __, ___) => const Icon(Icons.celebration_rounded,
              color: AppColors.primary, size: 40),
        ),
      ),
      destinations: _tabs
          .asMap()
          .entries
          .map((e) => NavigationRailDestination(
                icon: Icon(e.value.icon),
                selectedIcon: Icon(e.value.activeIcon),
                label: Text(_navLabel(context, e.key)),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wide/desktop: a side rail + the content area, so navigation and content
    // use the horizontal space instead of a phone-style bottom bar.
    if (context.useSideNav) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              _buildSideRail(context),
              VerticalDivider(width: 1, thickness: 1, color: context.c.border),
              Expanded(child: shell),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: shell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: bottomSheetCount,
              builder: (context, count, child) => AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                offset: count > 0 ? const Offset(0, 1) : Offset.zero,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: count > 0 ? 0.0 : 1.0,
                  child: child,
                ),
              ),
              child: _buildNavBar(context),
            ),
          ),
        ],
      ),
    );
  }
}
