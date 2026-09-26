import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language. English is available now — more are on the way.'**
  String get languageIntro;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get comingSoon;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get navMessages;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your Journey on Planovar'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email address'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orLabel;

  /// No description provided for @noAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have an account?'**
  String get noAccountQuestion;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @agreeTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms & Privacy Policy'**
  String get agreeTermsError;

  /// No description provided for @registerHello.
  ///
  /// In en, this message translates to:
  /// **'Hello '**
  String get registerHello;

  /// No description provided for @registerWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Planova! Let\'s Get Started'**
  String get registerWelcome;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your Full Name'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @agreeTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By checking the box you agree to our '**
  String get agreeTermsPrefix;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @andConnector.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andConnector;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboard1TitleBlack.
  ///
  /// In en, this message translates to:
  /// **'Tired of chasing endless'**
  String get onboard1TitleBlack;

  /// No description provided for @onboard1TitlePurple.
  ///
  /// In en, this message translates to:
  /// **'referrals?'**
  String get onboard1TitlePurple;

  /// No description provided for @onboard1Body.
  ///
  /// In en, this message translates to:
  /// **'Planning an event shouldn\'t feel like a second job. Stop the fragmentation and discover quality vendors in seconds.'**
  String get onboard1Body;

  /// No description provided for @onboard2TitleBlack.
  ///
  /// In en, this message translates to:
  /// **'The finest talent, at your'**
  String get onboard2TitleBlack;

  /// No description provided for @onboard2TitlePurple.
  ///
  /// In en, this message translates to:
  /// **'fingertips.'**
  String get onboard2TitlePurple;

  /// No description provided for @onboard2Body.
  ///
  /// In en, this message translates to:
  /// **'Access our curated network of top-tier caterers, decorators, and photographers. Verified quality, every time.'**
  String get onboard2Body;

  /// No description provided for @onboard3TitleBlack.
  ///
  /// In en, this message translates to:
  /// **'Join the community of pro'**
  String get onboard3TitleBlack;

  /// No description provided for @onboard3TitlePurple.
  ///
  /// In en, this message translates to:
  /// **'planners.'**
  String get onboard3TitlePurple;

  /// No description provided for @onboard3Body.
  ///
  /// In en, this message translates to:
  /// **'Don\'t miss out on exclusive vendor rates. Join over 50,000 users hosting unforgettable moments.'**
  String get onboard3Body;

  /// No description provided for @otpNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent'**
  String get otpNewCodeSent;

  /// No description provided for @otpResendError.
  ///
  /// In en, this message translates to:
  /// **'Could not resend code: {error}'**
  String otpResendError(String error);

  /// No description provided for @otpVerifyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to verify your email, or tap Resend.'**
  String get otpVerifyPrompt;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your Email'**
  String get verifyYourEmail;

  /// No description provided for @confirmOtp.
  ///
  /// In en, this message translates to:
  /// **'Confirm OTP'**
  String get confirmOtp;

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6 digit OTP to your email'**
  String get otpSentToEmail;

  /// No description provided for @otpEnterSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP Sent to '**
  String get otpEnterSentTo;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendInSeconds(int seconds);

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @addPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your phone number'**
  String get addPhoneTitle;

  /// No description provided for @addPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience a little more'**
  String get addPhoneSubtitle;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @dialCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get dialCodeHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @createStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a Strong Password'**
  String get createStrongPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @criteriaCapital.
  ///
  /// In en, this message translates to:
  /// **'Should have a Capital Letter'**
  String get criteriaCapital;

  /// No description provided for @criteriaNumber.
  ///
  /// In en, this message translates to:
  /// **'Should have a Number e.g 1,2,4,etc'**
  String get criteriaNumber;

  /// No description provided for @criteriaSpecial.
  ///
  /// In en, this message translates to:
  /// **'Should have a Special Character e.g @,\$,%,etc'**
  String get criteriaSpecial;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email used in registration, we will\nsend a 6 digit OTP code for verification'**
  String get forgotPasswordSubtitle;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please log in.'**
  String get passwordResetSuccess;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your Password'**
  String get resetYourPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @categoryPrefTitle.
  ///
  /// In en, this message translates to:
  /// **'Let us know what events\nyou\'d want'**
  String get categoryPrefTitle;

  /// No description provided for @categoryPrefSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll personalize your recommendations and search results.'**
  String get categoryPrefSubtitle;

  /// No description provided for @locationSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save location: {error}'**
  String locationSaveError(String error);

  /// No description provided for @selectPreferredLocation.
  ///
  /// In en, this message translates to:
  /// **'Select your Preferred Location'**
  String get selectPreferredLocation;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @selectYourCity.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectYourCity;

  /// No description provided for @thereFallback.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get thereFallback;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeBack;

  /// No description provided for @searchVendorOrLocation.
  ///
  /// In en, this message translates to:
  /// **'Search for a vendor or location'**
  String get searchVendorOrLocation;

  /// No description provided for @browseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse Categories'**
  String get browseCategories;

  /// No description provided for @yourUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Your Upcoming Events'**
  String get yourUpcomingEvents;

  /// No description provided for @recommendedVendors.
  ///
  /// In en, this message translates to:
  /// **'Recommended Vendors for you'**
  String get recommendedVendors;

  /// No description provided for @recommendedProducts.
  ///
  /// In en, this message translates to:
  /// **'Recommended Products for you'**
  String get recommendedProducts;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'No upcoming events'**
  String get noUpcomingEvents;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @eventCardTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Event'**
  String eventCardTitle(String name);

  /// No description provided for @vendorLabel.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendorLabel;

  /// No description provided for @getQuote.
  ///
  /// In en, this message translates to:
  /// **'Get Quote'**
  String get getQuote;

  /// No description provided for @rentForEvent.
  ///
  /// In en, this message translates to:
  /// **'Rent for your event'**
  String get rentForEvent;

  /// No description provided for @addToEventPlus.
  ///
  /// In en, this message translates to:
  /// **'Add to Event +'**
  String get addToEventPlus;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @findYourVibe.
  ///
  /// In en, this message translates to:
  /// **'Find your vibe'**
  String get findYourVibe;

  /// No description provided for @searchCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get searchCategoriesHint;

  /// No description provided for @browseServicesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Browse Services by Category'**
  String get browseServicesByCategory;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @enterCityOrArea.
  ///
  /// In en, this message translates to:
  /// **'Enter city or area'**
  String get enterCityOrArea;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @applyFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters ({count})'**
  String applyFiltersCount(int count);

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProductsHint;

  /// No description provided for @searchCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search {name}...'**
  String searchCategoryHint(String name);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @availableForSale.
  ///
  /// In en, this message translates to:
  /// **'Available for Sale'**
  String get availableForSale;

  /// No description provided for @availableForRent.
  ///
  /// In en, this message translates to:
  /// **'Available for Rent'**
  String get availableForRent;

  /// No description provided for @somethingWentWrongRetry.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Tap to retry.'**
  String get somethingWentWrongRetry;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @noVendorsFound.
  ///
  /// In en, this message translates to:
  /// **'No vendors found'**
  String get noVendorsFound;

  /// No description provided for @contactForPrice.
  ///
  /// In en, this message translates to:
  /// **'Contact for price'**
  String get contactForPrice;

  /// No description provided for @moreFiltersComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More filter options coming soon.'**
  String get moreFiltersComingSoon;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @myEventsAmp.
  ///
  /// In en, this message translates to:
  /// **'My Events & '**
  String get myEventsAmp;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @segMyEvents.
  ///
  /// In en, this message translates to:
  /// **'My Events'**
  String get segMyEvents;

  /// No description provided for @orderTracking.
  ///
  /// In en, this message translates to:
  /// **'Order Tracking'**
  String get orderTracking;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @cancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @noPastEvents.
  ///
  /// In en, this message translates to:
  /// **'No past events'**
  String get noPastEvents;

  /// No description provided for @noCancelledEvents.
  ///
  /// In en, this message translates to:
  /// **'No cancelled events'**
  String get noCancelledEvents;

  /// No description provided for @eventChip.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventChip;

  /// No description provided for @noVendorsSourcedYet.
  ///
  /// In en, this message translates to:
  /// **'No vendors sourced yet'**
  String get noVendorsSourcedYet;

  /// No description provided for @vendorsSourced.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 vendor sourced} other{{count} vendors sourced}}'**
  String vendorsSourced(int count);

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @singleLabel.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get singleLabel;

  /// No description provided for @venueLabel.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venueLabel;

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Location not set'**
  String get locationNotSet;

  /// No description provided for @tabPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get tabPurchase;

  /// No description provided for @tabRentals.
  ///
  /// In en, this message translates to:
  /// **'Rentals'**
  String get tabRentals;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders here yet'**
  String get noOrdersYet;

  /// No description provided for @quoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Quote'**
  String get quoteLabel;

  /// No description provided for @addVendorTitle.
  ///
  /// In en, this message translates to:
  /// **'Add vendor?'**
  String get addVendorTitle;

  /// No description provided for @addVendorBody.
  ///
  /// In en, this message translates to:
  /// **'Add {vendor} to \"{event}\"?'**
  String addVendorBody(String vendor, String event);

  /// No description provided for @thisEvent.
  ///
  /// In en, this message translates to:
  /// **'this event'**
  String get thisEvent;

  /// No description provided for @addAction.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addAction;

  /// No description provided for @vendorAddedToEvent.
  ///
  /// In en, this message translates to:
  /// **'{vendor} added to your event'**
  String vendorAddedToEvent(String vendor);

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'Event Not Found'**
  String get eventNotFound;

  /// No description provided for @eventNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Event not found'**
  String get eventNotFoundBody;

  /// No description provided for @guestsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 guest} other{{count} guests}}'**
  String guestsCount(int count);

  /// No description provided for @planningProgress.
  ///
  /// In en, this message translates to:
  /// **'Planning progress'**
  String get planningProgress;

  /// No description provided for @budgetRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget: {min} – {max}'**
  String budgetRangeLabel(String min, String max);

  /// No description provided for @browseRecommendedHint.
  ///
  /// In en, this message translates to:
  /// **'Browse the Recommended tab to add vendors to this event.'**
  String get browseRecommendedHint;

  /// No description provided for @viewGroupChat.
  ///
  /// In en, this message translates to:
  /// **'💬 View Group Chat'**
  String get viewGroupChat;

  /// No description provided for @createGroupChatBtn.
  ///
  /// In en, this message translates to:
  /// **'💬 Create Group Chat'**
  String get createGroupChatBtn;

  /// No description provided for @addNewVendor.
  ///
  /// In en, this message translates to:
  /// **'+ Add a new Vendor'**
  String get addNewVendor;

  /// No description provided for @cancelEventBtn.
  ///
  /// In en, this message translates to:
  /// **'⚠ Cancel Event'**
  String get cancelEventBtn;

  /// No description provided for @cancelEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel event?'**
  String get cancelEventTitle;

  /// No description provided for @cancelEventBody.
  ///
  /// In en, this message translates to:
  /// **'This cancels \"{name}\". This cannot be undone.'**
  String cancelEventBody(String name);

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @cancelEventAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel event'**
  String get cancelEventAction;

  /// No description provided for @eventCancelled.
  ///
  /// In en, this message translates to:
  /// **'Event cancelled'**
  String get eventCancelled;

  /// No description provided for @vendorsAvailableForEvent.
  ///
  /// In en, this message translates to:
  /// **'Vendors available for your event'**
  String get vendorsAvailableForEvent;

  /// No description provided for @searchVendorsHint.
  ///
  /// In en, this message translates to:
  /// **'Search vendors...'**
  String get searchVendorsHint;

  /// No description provided for @noVendorsAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No vendors available yet'**
  String get noVendorsAvailableYet;

  /// No description provided for @noVendorsInCategories.
  ///
  /// In en, this message translates to:
  /// **'No vendors in the selected categories'**
  String get noVendorsInCategories;

  /// No description provided for @tabVendors.
  ///
  /// In en, this message translates to:
  /// **'Vendors'**
  String get tabVendors;

  /// No description provided for @tabRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get tabRecommended;

  /// No description provided for @tabTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get tabTimeline;

  /// No description provided for @tabItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get tabItems;

  /// No description provided for @statusComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get statusComplete;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @tlEventCreated.
  ///
  /// In en, this message translates to:
  /// **'Event created'**
  String get tlEventCreated;

  /// No description provided for @tlSourceVendors.
  ///
  /// In en, this message translates to:
  /// **'Source your vendors'**
  String get tlSourceVendors;

  /// No description provided for @tlEventConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Event confirmed'**
  String get tlEventConfirmed;

  /// No description provided for @tlEventDay.
  ///
  /// In en, this message translates to:
  /// **'Event day ({date})'**
  String tlEventDay(String date);

  /// No description provided for @tlEventCompleted.
  ///
  /// In en, this message translates to:
  /// **'Event completed'**
  String get tlEventCompleted;

  /// No description provided for @eventTimeline.
  ///
  /// In en, this message translates to:
  /// **'Event Timeline'**
  String get eventTimeline;

  /// No description provided for @nothingAddedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing added to this event yet.\nOpen a product or service and tap \"Add to Event\" to see it here.'**
  String get nothingAddedYet;

  /// No description provided for @addedToThisEvent.
  ///
  /// In en, this message translates to:
  /// **'Added to this event'**
  String get addedToThisEvent;

  /// No description provided for @rentNow.
  ///
  /// In en, this message translates to:
  /// **'Rent now'**
  String get rentNow;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order now'**
  String get orderNow;

  /// No description provided for @requestQuote.
  ///
  /// In en, this message translates to:
  /// **'Request Quote'**
  String get requestQuote;

  /// No description provided for @quoteInquiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'d like a quote for \"{title}\" for my event \"{event}\" on {date}.'**
  String quoteInquiryMessage(String title, String event, String date);

  /// No description provided for @inquirySent.
  ///
  /// In en, this message translates to:
  /// **'Inquiry sent — the vendor will send you a quote'**
  String get inquirySent;

  /// No description provided for @createGroupChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Create group chat?'**
  String get createGroupChatTitle;

  /// No description provided for @createGroupChatBody.
  ///
  /// In en, this message translates to:
  /// **'All vendors attached to this event will automatically join — including any you add later. Quotes and invoices stay private in your direct chats.'**
  String get createGroupChatBody;

  /// No description provided for @createAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createAction;

  /// No description provided for @removeFromEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from event?'**
  String get removeFromEventTitle;

  /// No description provided for @removeFromEventBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\" from {event}?'**
  String removeFromEventBody(String title, String event);

  /// No description provided for @removeAction.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeAction;

  /// No description provided for @listingRemoved.
  ///
  /// In en, this message translates to:
  /// **'{title} removed'**
  String listingRemoved(String title);

  /// No description provided for @createAnPrefix.
  ///
  /// In en, this message translates to:
  /// **'Create an '**
  String get createAnPrefix;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step one, Choose the Event Type'**
  String get step1Subtitle;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventType;

  /// No description provided for @typeWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get typeWedding;

  /// No description provided for @typeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get typeBirthday;

  /// No description provided for @typeCorporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get typeCorporate;

  /// No description provided for @typeGraduation.
  ///
  /// In en, this message translates to:
  /// **'Graduation'**
  String get typeGraduation;

  /// No description provided for @eventTypeWedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get eventTypeWedding;

  /// No description provided for @eventTypeFuneral.
  ///
  /// In en, this message translates to:
  /// **'Funeral'**
  String get eventTypeFuneral;

  /// No description provided for @eventTypeBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get eventTypeBirthday;

  /// No description provided for @eventTypeCorporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get eventTypeCorporate;

  /// No description provided for @eventTypeSocialParty.
  ///
  /// In en, this message translates to:
  /// **'Social party'**
  String get eventTypeSocialParty;

  /// No description provided for @eventTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get eventTypeAll;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @pleaseSpecify.
  ///
  /// In en, this message translates to:
  /// **'Please Specify'**
  String get pleaseSpecify;

  /// No description provided for @eventPrefix.
  ///
  /// In en, this message translates to:
  /// **'Event '**
  String get eventPrefix;

  /// No description provided for @detailsHighlight.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsHighlight;

  /// No description provided for @step2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step Two, Enter your Event Details'**
  String get step2Subtitle;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get eventTitle;

  /// No description provided for @eventTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Wedding Reception'**
  String get eventTitleHint;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @guestCount.
  ///
  /// In en, this message translates to:
  /// **'Guest Count'**
  String get guestCount;

  /// No description provided for @timeFrom.
  ///
  /// In en, this message translates to:
  /// **'Time From'**
  String get timeFrom;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @timeTo.
  ///
  /// In en, this message translates to:
  /// **'Time To'**
  String get timeTo;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @venue.
  ///
  /// In en, this message translates to:
  /// **'Venue'**
  String get venue;

  /// No description provided for @venueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter venue address'**
  String get venueHint;

  /// No description provided for @budgetMinLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Min (\$)'**
  String get budgetMinLabel;

  /// No description provided for @budgetMaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget Max (\$)'**
  String get budgetMaxLabel;

  /// No description provided for @eventThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Event Thumbnail'**
  String get eventThumbnail;

  /// No description provided for @uploadThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Upload thumbnail'**
  String get uploadThumbnail;

  /// No description provided for @categoriesHighlight.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesHighlight;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step Three, Select your Preferences'**
  String get step3Subtitle;

  /// No description provided for @whatServicesNeeded.
  ///
  /// In en, this message translates to:
  /// **'What services do you need for your event?'**
  String get whatServicesNeeded;

  /// No description provided for @step4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step Four, Select your Vendors'**
  String get step4Subtitle;

  /// No description provided for @eventCreatedAdded.
  ///
  /// In en, this message translates to:
  /// **'Event created — added to it 🎉'**
  String get eventCreatedAdded;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'Event created 🎉'**
  String get eventCreated;

  /// No description provided for @recommendedVendorsForEvent.
  ///
  /// In en, this message translates to:
  /// **'Recommended vendors for your event'**
  String get recommendedVendorsForEvent;

  /// No description provided for @sourcedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{sourced} of {total} Vendors'**
  String sourcedOfTotal(int sourced, int total);

  /// No description provided for @searchForItems.
  ///
  /// In en, this message translates to:
  /// **'Search for items'**
  String get searchForItems;

  /// No description provided for @addedCheck.
  ///
  /// In en, this message translates to:
  /// **'Added ✓'**
  String get addedCheck;

  /// No description provided for @reviewSourcedVendors.
  ///
  /// In en, this message translates to:
  /// **'Review Sourced Vendors'**
  String get reviewSourcedVendors;

  /// No description provided for @createEventWithoutSourcing.
  ///
  /// In en, this message translates to:
  /// **'Create Event without sourcing'**
  String get createEventWithoutSourcing;

  /// No description provided for @allVendorsSourced.
  ///
  /// In en, this message translates to:
  /// **'All {count} Vendors sourced for all categories'**
  String allVendorsSourced(int count);

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @tabProductsToBuy.
  ///
  /// In en, this message translates to:
  /// **'Products to buy'**
  String get tabProductsToBuy;

  /// No description provided for @tabServicesToBook.
  ///
  /// In en, this message translates to:
  /// **'Services to book'**
  String get tabServicesToBook;

  /// No description provided for @tabEquipmentRentals.
  ///
  /// In en, this message translates to:
  /// **'Equipment rentals'**
  String get tabEquipmentRentals;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @serviceRadiusInfo.
  ///
  /// In en, this message translates to:
  /// **'{location} · 20km service radius'**
  String serviceRadiusInfo(String location);

  /// No description provided for @businessHoursInfo.
  ///
  /// In en, this message translates to:
  /// **'Mon–Sat · 9am–6pm'**
  String get businessHoursInfo;

  /// No description provided for @respondsWithin.
  ///
  /// In en, this message translates to:
  /// **'Responds within ~30 mins'**
  String get respondsWithin;

  /// No description provided for @selectOptionPreference.
  ///
  /// In en, this message translates to:
  /// **'Select an option based on your Preference'**
  String get selectOptionPreference;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get nothingHereYet;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy:'**
  String get cancellationPolicy;

  /// No description provided for @moderateValue.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateValue;

  /// No description provided for @minServiceDuration.
  ///
  /// In en, this message translates to:
  /// **'Minimum Service Duration:'**
  String get minServiceDuration;

  /// No description provided for @fourHours.
  ///
  /// In en, this message translates to:
  /// **'4 hours'**
  String get fourHours;

  /// No description provided for @addToEvent.
  ///
  /// In en, this message translates to:
  /// **'Add to Event'**
  String get addToEvent;

  /// No description provided for @quoteSent.
  ///
  /// In en, this message translates to:
  /// **'Quote Sent'**
  String get quoteSent;

  /// No description provided for @removeVendor.
  ///
  /// In en, this message translates to:
  /// **'Remove Vendor'**
  String get removeVendor;

  /// No description provided for @swapVendor.
  ///
  /// In en, this message translates to:
  /// **'Swap Vendor'**
  String get swapVendor;

  /// No description provided for @tapStarsToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap the stars to rate your experience'**
  String get tapStarsToRate;

  /// No description provided for @ratedStars.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} stars'**
  String ratedStars(int rating);

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted — thank you! ⭐'**
  String get reviewSubmitted;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @reviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let us know how your booking went'**
  String get reviewSubtitle;

  /// No description provided for @leaveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Leave a Detailed feedback'**
  String get leaveFeedback;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Let us know how your experience was'**
  String get feedbackHint;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// No description provided for @sendReview.
  ///
  /// In en, this message translates to:
  /// **'Send Review'**
  String get sendReview;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @cancelOrderNotice.
  ///
  /// In en, this message translates to:
  /// **'Cancelling this order will notify the vendor and our support team. Cancellation fees may apply depending on the vendor\'s policy. Refunds are typically processed within 3-5 business days.'**
  String get cancelOrderNotice;

  /// No description provided for @reasonForCancellation.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancellation'**
  String get reasonForCancellation;

  /// No description provided for @cancelReasonPlans.
  ///
  /// In en, this message translates to:
  /// **'Change of plans'**
  String get cancelReasonPlans;

  /// No description provided for @cancelReasonBetter.
  ///
  /// In en, this message translates to:
  /// **'Found a better alternative'**
  String get cancelReasonBetter;

  /// No description provided for @cancelReasonNoResponse.
  ///
  /// In en, this message translates to:
  /// **'Vendor not responding'**
  String get cancelReasonNoResponse;

  /// No description provided for @cancelReasonMistake.
  ///
  /// In en, this message translates to:
  /// **'Ordered by mistake'**
  String get cancelReasonMistake;

  /// No description provided for @cancelReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other reason'**
  String get cancelReasonOther;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get describeIssue;

  /// No description provided for @provideAdditionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Provide additional details...'**
  String get provideAdditionalDetails;

  /// No description provided for @messageVendorInstead.
  ///
  /// In en, this message translates to:
  /// **'Message Vendor Instead'**
  String get messageVendorInstead;

  /// No description provided for @youLabel.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get youLabel;

  /// No description provided for @memberLabel.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get memberLabel;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet — say hello 👋'**
  String get noMessagesYet;

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String membersCount(int count);

  /// No description provided for @addTodoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add a to-do'**
  String get addTodoTooltip;

  /// No description provided for @paymentUpdate.
  ///
  /// In en, this message translates to:
  /// **'Payment update'**
  String get paymentUpdate;

  /// No description provided for @confirmedBanner.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedBanner;

  /// No description provided for @messageTheGroup.
  ///
  /// In en, this message translates to:
  /// **'Message the group…'**
  String get messageTheGroup;

  /// No description provided for @raiseDispute.
  ///
  /// In en, this message translates to:
  /// **'Raise a dispute'**
  String get raiseDispute;

  /// No description provided for @disputeNotice.
  ///
  /// In en, this message translates to:
  /// **'Raising a dispute will notify our support team who will investigate the issue. Please provide as much detail as possible. Disputes are typically resolved within 3-5 business days.'**
  String get disputeNotice;

  /// No description provided for @disputeCategory.
  ///
  /// In en, this message translates to:
  /// **'Dispute category'**
  String get disputeCategory;

  /// No description provided for @disputeReasonNotDescribed.
  ///
  /// In en, this message translates to:
  /// **'Item not as described'**
  String get disputeReasonNotDescribed;

  /// No description provided for @disputeReasonNoShow.
  ///
  /// In en, this message translates to:
  /// **'Vendor did not show up / Complete the service'**
  String get disputeReasonNoShow;

  /// No description provided for @disputeReasonOvercharged.
  ///
  /// In en, this message translates to:
  /// **'Overcharged / incorrect amount'**
  String get disputeReasonOvercharged;

  /// No description provided for @disputeReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged / missing item'**
  String get disputeReasonDamaged;

  /// No description provided for @disputeReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other issue'**
  String get disputeReasonOther;

  /// No description provided for @describeWhatHappened.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened in detail...'**
  String get describeWhatHappened;

  /// No description provided for @attachEvidence.
  ///
  /// In en, this message translates to:
  /// **'Attach evidence (optional)'**
  String get attachEvidence;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @submitDispute.
  ///
  /// In en, this message translates to:
  /// **'Submit Dispute'**
  String get submitDispute;

  /// No description provided for @requestRefund.
  ///
  /// In en, this message translates to:
  /// **'Request Refund'**
  String get requestRefund;

  /// No description provided for @refundNotice.
  ///
  /// In en, this message translates to:
  /// **'Requesting a refund will notify our support team who will investigate the issue. Please provide as much detail as possible. Refund requests are typically resolved within 3-5 business days.'**
  String get refundNotice;

  /// No description provided for @refundCategory.
  ///
  /// In en, this message translates to:
  /// **'Refund category'**
  String get refundCategory;

  /// No description provided for @refundReasonNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Item not received'**
  String get refundReasonNotReceived;

  /// No description provided for @refundReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged item received'**
  String get refundReasonDamaged;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select Bank'**
  String get selectBank;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Number'**
  String get enterAccountNumber;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'This order could not be loaded.'**
  String get orderCouldNotLoad;

  /// No description provided for @orderFallback.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get orderFallback;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @statusHeading.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusHeading;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get statusOrderConfirmed;

  /// No description provided for @statusOutForDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get statusOutForDelivery;

  /// No description provided for @statusOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get statusOrderPlaced;

  /// No description provided for @requestRefundWarn.
  ///
  /// In en, this message translates to:
  /// **'⚠ Request Refund'**
  String get requestRefundWarn;

  /// No description provided for @cancelOrderWarn.
  ///
  /// In en, this message translates to:
  /// **'⚠ Cancel Order'**
  String get cancelOrderWarn;

  /// No description provided for @rentalDetails.
  ///
  /// In en, this message translates to:
  /// **'Rental Details'**
  String get rentalDetails;

  /// No description provided for @rentalCouldNotLoad.
  ///
  /// In en, this message translates to:
  /// **'This rental could not be loaded.'**
  String get rentalCouldNotLoad;

  /// No description provided for @rentalFallback.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get rentalFallback;

  /// No description provided for @perDayRate.
  ///
  /// In en, this message translates to:
  /// **'Per day rate'**
  String get perDayRate;

  /// No description provided for @refundableDeposit.
  ///
  /// In en, this message translates to:
  /// **'Refundable deposit'**
  String get refundableDeposit;

  /// No description provided for @statusReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get statusReturned;

  /// No description provided for @statusPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get statusPickedUp;

  /// No description provided for @statusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get statusRequested;

  /// No description provided for @tabDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get tabDetails;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @addOns.
  ///
  /// In en, this message translates to:
  /// **'Ad ons'**
  String get addOns;

  /// No description provided for @guestSize.
  ///
  /// In en, this message translates to:
  /// **'Guest Size'**
  String get guestSize;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date and Time'**
  String get dateAndTime;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @quoteSentByVendor.
  ///
  /// In en, this message translates to:
  /// **'Quote Sent by Vendor'**
  String get quoteSentByVendor;

  /// No description provided for @bookingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Booking Completed'**
  String get bookingCompleted;

  /// No description provided for @awaitingQuote.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Quote from vendor'**
  String get awaitingQuote;

  /// No description provided for @viewQuote.
  ///
  /// In en, this message translates to:
  /// **'View Quote'**
  String get viewQuote;

  /// No description provided for @viewConversationHistory.
  ///
  /// In en, this message translates to:
  /// **'View Conversation History'**
  String get viewConversationHistory;

  /// No description provided for @tlQuoteAccepted.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted'**
  String get tlQuoteAccepted;

  /// No description provided for @tlPaymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed'**
  String get tlPaymentConfirmed;

  /// No description provided for @tlEventDayShort.
  ///
  /// In en, this message translates to:
  /// **'Event day'**
  String get tlEventDayShort;

  /// No description provided for @bookingTimeline.
  ///
  /// In en, this message translates to:
  /// **'Booking Timeline'**
  String get bookingTimeline;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @leaveReviewBtn.
  ///
  /// In en, this message translates to:
  /// **'⭐ Leave a Review'**
  String get leaveReviewBtn;

  /// No description provided for @messageVendor.
  ///
  /// In en, this message translates to:
  /// **'💬 Message Vendor'**
  String get messageVendor;

  /// No description provided for @callVendor.
  ///
  /// In en, this message translates to:
  /// **'📞 Call Vendor'**
  String get callVendor;

  /// No description provided for @downloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'📋 Download Booking Receipt'**
  String get downloadReceipt;

  /// No description provided for @raiseDisputeBtn.
  ///
  /// In en, this message translates to:
  /// **'⚠ Raise a Dispute'**
  String get raiseDisputeBtn;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @noBookingsHere.
  ///
  /// In en, this message translates to:
  /// **'No bookings here'**
  String get noBookingsHere;

  /// No description provided for @noBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When you book a vendor, it will appear here.'**
  String get noBookingsSubtitle;

  /// No description provided for @selectEventDateError.
  ///
  /// In en, this message translates to:
  /// **'Please select an event date'**
  String get selectEventDateError;

  /// No description provided for @enterEventLocationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter the event location'**
  String get enterEventLocationError;

  /// No description provided for @bookingRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Booking request submitted!'**
  String get bookingRequestSubmitted;

  /// No description provided for @requestAQuote.
  ///
  /// In en, this message translates to:
  /// **'Request a Quote'**
  String get requestAQuote;

  /// No description provided for @eventDetailsHeading.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetailsHeading;

  /// No description provided for @selectEventDate.
  ///
  /// In en, this message translates to:
  /// **'Select event date'**
  String get selectEventDate;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Event Location'**
  String get eventLocation;

  /// No description provided for @eventLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Grand Hotel, Downtown'**
  String get eventLocationHint;

  /// No description provided for @requirementsHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your event, guest count, special requests...'**
  String get requirementsHint;

  /// No description provided for @selectPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get selectPackage;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @bookingNotFound.
  ///
  /// In en, this message translates to:
  /// **'Booking not found'**
  String get bookingNotFound;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingBody;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @paymentArrangedNotice.
  ///
  /// In en, this message translates to:
  /// **'Payment is arranged directly between you and the vendor. Transactions happen outside Planovar and are at both parties\' own risk.'**
  String get paymentArrangedNotice;

  /// No description provided for @quoteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Quote not found'**
  String get quoteNotFound;

  /// No description provided for @quoteFrom.
  ///
  /// In en, this message translates to:
  /// **'Quote from {vendor}'**
  String quoteFrom(String vendor);

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String expiredOn(String date);

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String validUntil(String date);

  /// No description provided for @notesFromVendor.
  ///
  /// In en, this message translates to:
  /// **'Notes from vendor'**
  String get notesFromVendor;

  /// No description provided for @acceptAndBook.
  ///
  /// In en, this message translates to:
  /// **'Accept & Book'**
  String get acceptAndBook;

  /// No description provided for @acceptQuoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept Quote?'**
  String get acceptQuoteTitle;

  /// No description provided for @acceptQuoteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this quote for {amount}?'**
  String acceptQuoteBody(String amount);

  /// No description provided for @quoteAcceptedInvoice.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted — arrange payment directly with the vendor.'**
  String get quoteAcceptedInvoice;

  /// No description provided for @couldNotAcceptQuote.
  ///
  /// In en, this message translates to:
  /// **'Could not accept quote: {error}'**
  String couldNotAcceptQuote(String error);

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @listingNotFound.
  ///
  /// In en, this message translates to:
  /// **'Listing not found'**
  String get listingNotFound;

  /// No description provided for @reviewsCountParen.
  ///
  /// In en, this message translates to:
  /// **'({count}) Reviews'**
  String reviewsCountParen(int count);

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @sizes.
  ///
  /// In en, this message translates to:
  /// **'Sizes'**
  String get sizes;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @policyTitle.
  ///
  /// In en, this message translates to:
  /// **'{policy} Cancellation Policy'**
  String policyTitle(String policy);

  /// No description provided for @serviceDuration.
  ///
  /// In en, this message translates to:
  /// **'Service Duration:'**
  String get serviceDuration;

  /// No description provided for @vendorDetails.
  ///
  /// In en, this message translates to:
  /// **'Vendor Details'**
  String get vendorDetails;

  /// No description provided for @messageVendorPlain.
  ///
  /// In en, this message translates to:
  /// **'Message Vendor'**
  String get messageVendorPlain;

  /// No description provided for @rentForYourEvent.
  ///
  /// In en, this message translates to:
  /// **'Rent for your Event'**
  String get rentForYourEvent;

  /// No description provided for @addToEventPlusIcon.
  ///
  /// In en, this message translates to:
  /// **'+ Add to Event'**
  String get addToEventPlusIcon;

  /// No description provided for @fromPrice.
  ///
  /// In en, this message translates to:
  /// **'From \${price}'**
  String fromPrice(String price);

  /// No description provided for @quoteOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Quote on request'**
  String get quoteOnRequest;

  /// No description provided for @policyFlexible1.
  ///
  /// In en, this message translates to:
  /// **'Full refund if cancelled up to 24 hours before the event.'**
  String get policyFlexible1;

  /// No description provided for @policyFlexible2.
  ///
  /// In en, this message translates to:
  /// **'A small processing fee may apply.'**
  String get policyFlexible2;

  /// No description provided for @policyStrict1.
  ///
  /// In en, this message translates to:
  /// **'No refund once the booking is confirmed.'**
  String get policyStrict1;

  /// No description provided for @policyModerate1.
  ///
  /// In en, this message translates to:
  /// **'100% refund if cancelled 7+ days before the event.'**
  String get policyModerate1;

  /// No description provided for @policyModerate2.
  ///
  /// In en, this message translates to:
  /// **'50% refund if cancelled 3–6 days before the event.'**
  String get policyModerate2;

  /// No description provided for @policyModerate3.
  ///
  /// In en, this message translates to:
  /// **'No refund within 48 hours of the event.'**
  String get policyModerate3;

  /// No description provided for @vendorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vendor not found'**
  String get vendorNotFound;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get tabAbout;

  /// No description provided for @tabReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get tabReviews;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescriptionAvailable;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available'**
  String get noServicesAvailable;

  /// No description provided for @verifiedReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 verified review} other{{count} verified reviews}}'**
  String verifiedReviewsCount(int count);

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @stayConnected.
  ///
  /// In en, this message translates to:
  /// **'Stay Connected with your Vendors'**
  String get stayConnected;

  /// No description provided for @searchConversations.
  ///
  /// In en, this message translates to:
  /// **'Search conversations'**
  String get searchConversations;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// No description provided for @groupChat.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get groupChat;

  /// No description provided for @groupVendorsCount.
  ///
  /// In en, this message translates to:
  /// **'Group · {count, plural, =1{1 vendor} other{{count} vendors}}'**
  String groupVendorsCount(int count);

  /// No description provided for @quoteSentAmount.
  ///
  /// In en, this message translates to:
  /// **'Quote sent - \${amount} · '**
  String quoteSentAmount(String amount);

  /// No description provided for @tapToReview.
  ///
  /// In en, this message translates to:
  /// **'Tap to Review'**
  String get tapToReview;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @quoteAcceptedInvoiceCreated.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted — arrange payment directly with the vendor 🎉'**
  String get quoteAcceptedInvoiceCreated;

  /// No description provided for @quoteDeclined.
  ///
  /// In en, this message translates to:
  /// **'Quote declined'**
  String get quoteDeclined;

  /// No description provided for @quoteVersionValid.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · valid till {date}'**
  String quoteVersionValid(int version, String date);

  /// No description provided for @lineItems.
  ///
  /// In en, this message translates to:
  /// **'Line items'**
  String get lineItems;

  /// No description provided for @paymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Payment terms'**
  String get paymentTerms;

  /// No description provided for @noteFromVendor.
  ///
  /// In en, this message translates to:
  /// **'Note from the vendor'**
  String get noteFromVendor;

  /// No description provided for @leaveAReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get leaveAReview;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience…'**
  String get shareYourExperience;

  /// No description provided for @addShortComment.
  ///
  /// In en, this message translates to:
  /// **'Add a short comment'**
  String get addShortComment;

  /// No description provided for @reviewSubmittedStar.
  ///
  /// In en, this message translates to:
  /// **'Review submitted ⭐'**
  String get reviewSubmittedStar;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @submitReviewBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get submitReviewBtn;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @chatFallback.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatFallback;

  /// No description provided for @sayHello.
  ///
  /// In en, this message translates to:
  /// **'Say hello 👋'**
  String get sayHello;

  /// No description provided for @quoteAcceptedBanner.
  ///
  /// In en, this message translates to:
  /// **'Quote accepted'**
  String get quoteAcceptedBanner;

  /// No description provided for @quoteExpired.
  ///
  /// In en, this message translates to:
  /// **'Quote expired'**
  String get quoteExpired;

  /// No description provided for @declinedBanner.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declinedBanner;

  /// No description provided for @depositRefundedAmount.
  ///
  /// In en, this message translates to:
  /// **'Deposit refunded · \${amount}'**
  String depositRefundedAmount(String amount);

  /// No description provided for @depositRefunded.
  ///
  /// In en, this message translates to:
  /// **'Deposit refunded'**
  String get depositRefunded;

  /// No description provided for @paymentReceivedAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment received · \${amount}'**
  String paymentReceivedAmount(String amount);

  /// No description provided for @paymentReceivedBanner.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get paymentReceivedBanner;

  /// No description provided for @orderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order update'**
  String get orderUpdate;

  /// No description provided for @reviewSubmittedRating.
  ///
  /// In en, this message translates to:
  /// **'Review submitted · {rating}★'**
  String reviewSubmittedRating(String rating);

  /// No description provided for @paymentConfirmedFallback.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed'**
  String get paymentConfirmedFallback;

  /// No description provided for @paymentProcessingFallback.
  ///
  /// In en, this message translates to:
  /// **'Payment processing…'**
  String get paymentProcessingFallback;

  /// No description provided for @bookingCancelledFallback.
  ///
  /// In en, this message translates to:
  /// **'This booking has been cancelled.'**
  String get bookingCancelledFallback;

  /// No description provided for @disputeRaisedFallback.
  ///
  /// In en, this message translates to:
  /// **'A dispute has been raised.'**
  String get disputeRaisedFallback;

  /// No description provided for @howDidItGo.
  ///
  /// In en, this message translates to:
  /// **'How did it go?'**
  String get howDidItGo;

  /// No description provided for @refundRequestedFallback.
  ///
  /// In en, this message translates to:
  /// **'Refund request submitted.'**
  String get refundRequestedFallback;

  /// No description provided for @paymentConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Confirmed'**
  String get paymentConfirmedTitle;

  /// No description provided for @paymentProcessingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Processing'**
  String get paymentProcessingTitle;

  /// No description provided for @bookingCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get bookingCancelledTitle;

  /// No description provided for @disputeRaisedTitle.
  ///
  /// In en, this message translates to:
  /// **'Dispute Raised'**
  String get disputeRaisedTitle;

  /// No description provided for @disputeReviewNote.
  ///
  /// In en, this message translates to:
  /// **'Our team will review this dispute within 24 hours.'**
  String get disputeReviewNote;

  /// No description provided for @howWasExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasExperience;

  /// No description provided for @leaveReviewPlain.
  ///
  /// In en, this message translates to:
  /// **'Leave a Review'**
  String get leaveReviewPlain;

  /// No description provided for @refundRequestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund Requested'**
  String get refundRequestedTitle;

  /// No description provided for @refundProcessNote.
  ///
  /// In en, this message translates to:
  /// **'Refund will be processed within 5–7 business days.'**
  String get refundProcessNote;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeAMessage;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get myAccount;

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSection;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get yourProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @savedLabel.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedLabel;

  /// No description provided for @savedVendors.
  ///
  /// In en, this message translates to:
  /// **'Saved Vendors'**
  String get savedVendors;

  /// No description provided for @yourWishlist.
  ///
  /// In en, this message translates to:
  /// **'Your Wishlist'**
  String get yourWishlist;

  /// No description provided for @myReviews.
  ///
  /// In en, this message translates to:
  /// **'My Reviews'**
  String get myReviews;

  /// No description provided for @myReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your overall ratings from vendors'**
  String get myReviewsSubtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred display'**
  String get themeSubtitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage alerts & preferences'**
  String get notificationsSubtitle;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Security'**
  String get privacySecurity;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account security settings'**
  String get privacySubtitle;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpSupport;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visit our help centre for inquiries'**
  String get helpSubtitle;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete your account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account'**
  String get deleteAccountSubtitle;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out'**
  String get signOutConfirm;

  /// No description provided for @couldNotUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not upload photo: {error}'**
  String couldNotUploadPhoto(String error);

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @couldNotUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not update profile: {error}'**
  String couldNotUpdateProfile(String error);

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enterLastName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @reviewsScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your reviews from past events'**
  String get reviewsScreenSubtitle;

  /// No description provided for @noSavedVendors.
  ///
  /// In en, this message translates to:
  /// **'No saved vendors yet'**
  String get noSavedVendors;

  /// No description provided for @noSavedVendorsSub.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any vendor to save it here.'**
  String get noSavedVendorsSub;

  /// No description provided for @noSavedProducts.
  ///
  /// In en, this message translates to:
  /// **'No saved products yet'**
  String get noSavedProducts;

  /// No description provided for @noSavedProductsSub.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to save it here.'**
  String get noSavedProductsSub;

  /// No description provided for @yourFavourites.
  ///
  /// In en, this message translates to:
  /// **'Your Favourites'**
  String get yourFavourites;

  /// No description provided for @favouritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View all your saved vendors and products'**
  String get favouritesSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new strong password'**
  String get changePasswordSubtitle;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @hasCapital.
  ///
  /// In en, this message translates to:
  /// **'Has capital letter'**
  String get hasCapital;

  /// No description provided for @hasNumber.
  ///
  /// In en, this message translates to:
  /// **'Has number'**
  String get hasNumber;

  /// No description provided for @hasSpecial.
  ///
  /// In en, this message translates to:
  /// **'Has special character'**
  String get hasSpecial;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePassword;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two factor authentication'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'add an extra layer of security'**
  String get twoFactorSubtitle;

  /// No description provided for @twoFactorEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Authentication code will be sent to your email for verification'**
  String get twoFactorEmailDesc;

  /// No description provided for @twoFactorPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Authentication code will be sent to your phone for verification'**
  String get twoFactorPhoneDesc;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @chatWithTeam.
  ///
  /// In en, this message translates to:
  /// **'Chat with our team'**
  String get chatWithTeam;

  /// No description provided for @supportBeingSetup.
  ///
  /// In en, this message translates to:
  /// **'Support is being set up'**
  String get supportBeingSetup;

  /// No description provided for @openLiveChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Open our live chat to talk to a support agent.'**
  String get openLiveChatDesc;

  /// No description provided for @supportEmailDesc.
  ///
  /// In en, this message translates to:
  /// **'Our live chat isn\'t connected yet — email us and we\'ll get right back to you.'**
  String get supportEmailDesc;

  /// No description provided for @openLiveChat.
  ///
  /// In en, this message translates to:
  /// **'Open live chat'**
  String get openLiveChat;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email support'**
  String get emailSupport;

  /// No description provided for @themeScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred theme appearance'**
  String get themeScreenSubtitle;

  /// No description provided for @lightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightLabel;

  /// No description provided for @darkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkLabel;

  /// No description provided for @systemLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLabel;

  /// No description provided for @systemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your default system preference'**
  String get systemSubtitle;

  /// No description provided for @notifSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage when you\'ll receive notifications'**
  String get notifSettingsSubtitle;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All notifications'**
  String get allNotifications;

  /// No description provided for @notifChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose where you want to receive notifications'**
  String get notifChannelDesc;

  /// No description provided for @channelNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get channelNone;

  /// No description provided for @channelInApp.
  ///
  /// In en, this message translates to:
  /// **'In app'**
  String get channelInApp;

  /// No description provided for @channelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get channelEmail;

  /// No description provided for @channelBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get channelBoth;

  /// No description provided for @notifAllMessages.
  ///
  /// In en, this message translates to:
  /// **'All messages'**
  String get notifAllMessages;

  /// No description provided for @notifAllMessagesSub.
  ///
  /// In en, this message translates to:
  /// **'someone replies your message'**
  String get notifAllMessagesSub;

  /// No description provided for @notifOrderDelivery.
  ///
  /// In en, this message translates to:
  /// **'Order/Delivery Timeline'**
  String get notifOrderDelivery;

  /// No description provided for @notifOrderDeliverySub.
  ///
  /// In en, this message translates to:
  /// **'get notified when there\'s a new delivery status'**
  String get notifOrderDeliverySub;

  /// No description provided for @notifEventTimeline.
  ///
  /// In en, this message translates to:
  /// **'Event Timeline'**
  String get notifEventTimeline;

  /// No description provided for @notifEventTimelineSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when there\'s a new event timeline'**
  String get notifEventTimelineSub;

  /// No description provided for @notifPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment alerts'**
  String get notifPayment;

  /// No description provided for @notifPaymentSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when a payment is successful'**
  String get notifPaymentSub;

  /// No description provided for @notifQuote.
  ///
  /// In en, this message translates to:
  /// **'Quote / Invoice alerts'**
  String get notifQuote;

  /// No description provided for @notifQuoteSub.
  ///
  /// In en, this message translates to:
  /// **'get notified when you get a quote'**
  String get notifQuoteSub;

  /// No description provided for @notifVendorMatch.
  ///
  /// In en, this message translates to:
  /// **'Vendor Match'**
  String get notifVendorMatch;

  /// No description provided for @notifVendorMatchSub.
  ///
  /// In en, this message translates to:
  /// **'get alerts for recommended vendors'**
  String get notifVendorMatchSub;

  /// No description provided for @privacyScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'manage your password and 2 factor authentications'**
  String get privacyScreenSubtitle;

  /// No description provided for @changeYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get changeYourPassword;

  /// No description provided for @changePasswordRowSub.
  ///
  /// In en, this message translates to:
  /// **'Update your login credentials'**
  String get changePasswordRowSub;

  /// No description provided for @twoFactorRow.
  ///
  /// In en, this message translates to:
  /// **'2 factor authentication'**
  String get twoFactorRow;

  /// No description provided for @twoFactorRowSub.
  ///
  /// In en, this message translates to:
  /// **'add extra layer of security'**
  String get twoFactorRowSub;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get real time help for all your inquires'**
  String get helpScreenSubtitle;

  /// No description provided for @searchForHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for help'**
  String get searchForHelp;

  /// No description provided for @emailSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupportTitle;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @liveChatSub.
  ///
  /// In en, this message translates to:
  /// **'chat with our support team available Mon - Fri 8am - 5pm'**
  String get liveChatSub;

  /// No description provided for @phoneSupport.
  ///
  /// In en, this message translates to:
  /// **'Phone Support'**
  String get phoneSupport;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqTitle;

  /// No description provided for @faqSub.
  ///
  /// In en, this message translates to:
  /// **'Get answers to your burning questions'**
  String get faqSub;

  /// No description provided for @faqScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqScreenTitle;

  /// No description provided for @faqScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answers to your burning questions'**
  String get faqScreenSubtitle;

  /// No description provided for @searchFaqs.
  ///
  /// In en, this message translates to:
  /// **'Search FAQs'**
  String get searchFaqs;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I book a vendor?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Browse vendors, tap on one you like, view their listings, and tap \"Request a Quote\" or \"Book Now\". Fill in your event details and submit. The vendor will respond within 24 hours.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How does the payment process work?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'Once a vendor accepts your booking and you accept their quote, you\'ll pay a 50% deposit to confirm the booking. The remaining balance is due 7 days before your event.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel a booking?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can cancel a booking before it is confirmed at no charge. After confirmation, our cancellation policy applies — please review the vendor\'s cancellation terms in their profile.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'What if I\'m not satisfied with a vendor?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team within 48 hours of your event. We\'ll mediate with the vendor and work towards a resolution, including partial refunds where appropriate.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'Are vendors verified?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'Vendors with a verified badge have had their business credentials and portfolio reviewed by our team. We also use client reviews to maintain quality standards.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I leave a review?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'After your event is marked as completed, you\'ll receive a prompt to leave a review. You can also go to Bookings → Past → the completed booking → Leave Review.'**
  String get faqA6;

  /// No description provided for @sadToSeeYouGo.
  ///
  /// In en, this message translates to:
  /// **'We\'re sad to see you go'**
  String get sadToSeeYouGo;

  /// No description provided for @letUsKnow.
  ///
  /// In en, this message translates to:
  /// **'Let us know what went wrong'**
  String get letUsKnow;

  /// No description provided for @deleteReason1.
  ///
  /// In en, this message translates to:
  /// **'No longer using the platform/service'**
  String get deleteReason1;

  /// No description provided for @deleteReason2.
  ///
  /// In en, this message translates to:
  /// **'Found a better alternative'**
  String get deleteReason2;

  /// No description provided for @deleteReason3.
  ///
  /// In en, this message translates to:
  /// **'Privacy Concerns'**
  String get deleteReason3;

  /// No description provided for @deleteReason4.
  ///
  /// In en, this message translates to:
  /// **'Too many emails/notifications'**
  String get deleteReason4;

  /// No description provided for @deleteReason5.
  ///
  /// In en, this message translates to:
  /// **'Difficulty navigating the platform'**
  String get deleteReason5;

  /// No description provided for @deleteReason6.
  ///
  /// In en, this message translates to:
  /// **'Personal Reasons'**
  String get deleteReason6;

  /// No description provided for @deleteReason7.
  ///
  /// In en, this message translates to:
  /// **'Other not listed above'**
  String get deleteReason7;

  /// No description provided for @tellUsMore.
  ///
  /// In en, this message translates to:
  /// **'Tell us more...'**
  String get tellUsMore;

  /// No description provided for @deleteAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountBtn;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'by deleting your account you will lose the following'**
  String get deleteAccountWarning;

  /// No description provided for @deleteLoss1.
  ///
  /// In en, this message translates to:
  /// **'• Access to your active events'**
  String get deleteLoss1;

  /// No description provided for @deleteLoss2.
  ///
  /// In en, this message translates to:
  /// **'• Access to your account records and credentials'**
  String get deleteLoss2;

  /// No description provided for @deleteLoss3.
  ///
  /// In en, this message translates to:
  /// **'• Login details'**
  String get deleteLoss3;

  /// No description provided for @deleteLoss4.
  ///
  /// In en, this message translates to:
  /// **'• All Vendor contacts via message and call'**
  String get deleteLoss4;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get connecting;

  /// No description provided for @ringing.
  ///
  /// In en, this message translates to:
  /// **'Ringing…'**
  String get ringing;

  /// No description provided for @wrongAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrong app'**
  String get wrongAppTitle;

  /// No description provided for @wrongAppMessage.
  ///
  /// In en, this message translates to:
  /// **'This account is registered as a vendor. Please use the Planovar Vendor app to sign in.'**
  String get wrongAppMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @orderFeeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Fee Breakdown'**
  String get orderFeeBreakdown;

  /// No description provided for @orderSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get orderSubtotal;

  /// No description provided for @orderDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get orderDeliveryFee;

  /// No description provided for @orderDeposit.
  ///
  /// In en, this message translates to:
  /// **'Refundable Deposit'**
  String get orderDeposit;

  /// No description provided for @orderTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderTotal;

  /// No description provided for @orderPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get orderPaymentHistory;

  /// No description provided for @orderPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get orderPaid;

  /// No description provided for @orderDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get orderDue;

  /// No description provided for @orderPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderPending;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @twofaConfirmPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get twofaConfirmPasswordTitle;

  /// No description provided for @twofaContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get twofaContinue;

  /// No description provided for @twofaEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get twofaEnable;

  /// No description provided for @twofaDisable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get twofaDisable;

  /// No description provided for @twofaStatusOn.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is on'**
  String get twofaStatusOn;

  /// No description provided for @twofaStatusOff.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication is off'**
  String get twofaStatusOff;

  /// No description provided for @twofaOnDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account is protected with an authenticator app.'**
  String get twofaOnDesc;

  /// No description provided for @twofaOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security using an authenticator app.'**
  String get twofaOffDesc;

  /// No description provided for @twofaEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication enabled'**
  String get twofaEnabledMsg;

  /// No description provided for @twofaDisabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication disabled'**
  String get twofaDisabledMsg;

  /// No description provided for @twofaSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up authenticator'**
  String get twofaSetupTitle;

  /// No description provided for @twofaSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code with your authenticator app, then enter the 6-digit code to finish.'**
  String get twofaSetupHint;

  /// No description provided for @twofaCantScan.
  ///
  /// In en, this message translates to:
  /// **'Can\'t scan? Enter this key manually:'**
  String get twofaCantScan;

  /// No description provided for @twofaSecretCopied.
  ///
  /// In en, this message translates to:
  /// **'Secret copied'**
  String get twofaSecretCopied;

  /// No description provided for @twofaBackupCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup codes'**
  String get twofaBackupCodesTitle;

  /// No description provided for @twofaBackupCodesHint.
  ///
  /// In en, this message translates to:
  /// **'Save these somewhere safe. Each can be used once.'**
  String get twofaBackupCodesHint;

  /// No description provided for @twofaEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get twofaEnterCode;

  /// No description provided for @twofaVerifyEnable.
  ///
  /// In en, this message translates to:
  /// **'Verify & Enable'**
  String get twofaVerifyEnable;

  /// No description provided for @tfaChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Verification'**
  String get tfaChallengeTitle;

  /// No description provided for @tfaChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app to continue.'**
  String get tfaChallengeSubtitle;

  /// No description provided for @tfaVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get tfaVerify;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
