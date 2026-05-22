class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const verifyOtp = '/verify-otp';
  static const phone = '/phone';
  static const locationPref = '/location-pref';
  static const categoryPref = '/category-pref';
  static const createPassword = '/create-password';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  static const homeFeed = '/home/feed';
  static const explore = '/home/explore';
  static const events = '/home/events';
  static const messages = '/home/messages';
  static const profile = '/home/profile';

  static const categoryResults = '/categories/:slug';
  static String categoryResultsPath(String slug) => '/categories/$slug';

  static const vendorProfile = '/vendors/:id';
  static String vendorProfilePath(String id) => '/vendors/$id';

  static const listingDetail = '/listings/:id';
  static String listingDetailPath(String id) => '/listings/$id';

  static const bookings = '/bookings';
  static const newBooking = '/bookings/new';
  static const bookingDetail = '/bookings/:id';
  static String bookingDetailPath(String id) => '/bookings/$id';

  static const quoteDetail = '/quotes/:id';
  static String quoteDetailPath(String id) => '/quotes/$id';

  static const conversationDetail = '/conversations/:id';
  static String conversationDetailPath(String id) => '/conversations/$id';

  static const serviceDetails = '/service-details';
  static const confirmQuote = '/bookings/confirm';
  static const awaitingResponse = '/bookings/awaiting';
  static const checkout = '/checkout';
  static const rentProduct = '/rent-product';
  static const processPayment = '/payments/process';
  static const paymentSuccess = '/payments/success';
  static const bookingConfirmed = '/bookings/confirmed';

  static const createEventStep1 = '/events/create/step1';
  static const createEventStep2 = '/events/create/step2';
  static const createEventStep3 = '/events/create/step3';
  static const createEventStep4 = '/events/create/step4';

  static const payments = '/payments';
  static const notifications = '/notifications';
  static const favourites = '/favourites';
  static const reviews = '/reviews';
  static const themeSettings = '/settings/theme';
  static const notificationSettings = '/settings/notifications';
  static const privacy = '/settings/privacy';
  static const help = '/settings/help';
  static const faq = '/settings/faq';
  static const deleteAccount = '/settings/delete-account';
}
