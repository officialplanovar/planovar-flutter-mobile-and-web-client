// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get languageIntro =>
      'Choose your preferred language. English is available now — more are on the way.';

  @override
  String get comingSoon => 'Soon';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get search => 'Search';

  @override
  String get seeAll => 'See All';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navEvents => 'Events';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue your Journey on Planovar';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'Enter your Email address';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get orLabel => 'or';

  @override
  String get noAccountQuestion => 'Don\'t Have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get agreeTermsError => 'Please agree to the Terms & Privacy Policy';

  @override
  String get registerHello => 'Hello ';

  @override
  String get registerWelcome => 'Welcome to Planova! Let\'s Get Started';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your Full Name';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get proceed => 'Proceed';

  @override
  String get agreeTermsPrefix => 'By checking the box you agree to our ';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get andConnector => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get alreadyHaveAccount => 'Already Have an account? ';

  @override
  String get signInLink => 'Sign in';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboard1TitleBlack => 'Tired of chasing endless';

  @override
  String get onboard1TitlePurple => 'referrals?';

  @override
  String get onboard1Body =>
      'Planning an event shouldn\'t feel like a second job. Stop the fragmentation and discover quality vendors in seconds.';

  @override
  String get onboard2TitleBlack => 'The finest talent, at your';

  @override
  String get onboard2TitlePurple => 'fingertips.';

  @override
  String get onboard2Body =>
      'Access our curated network of top-tier caterers, decorators, and photographers. Verified quality, every time.';

  @override
  String get onboard3TitleBlack => 'Join the community of pro';

  @override
  String get onboard3TitlePurple => 'planners.';

  @override
  String get onboard3Body =>
      'Don\'t miss out on exclusive vendor rates. Join over 50,000 users hosting unforgettable moments.';

  @override
  String get otpNewCodeSent => 'A new code has been sent';

  @override
  String otpResendError(String error) {
    return 'Could not resend code: $error';
  }

  @override
  String get otpVerifyPrompt =>
      'Enter the code we sent to verify your email, or tap Resend.';

  @override
  String get verifyYourEmail => 'Verify your Email';

  @override
  String get confirmOtp => 'Confirm OTP';

  @override
  String get otpSentToEmail => 'We\'ve sent a 6 digit OTP to your email';

  @override
  String get otpEnterSentTo => 'Enter the OTP Sent to ';

  @override
  String resendInSeconds(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get addPhoneTitle => 'Add your phone number';

  @override
  String get addPhoneSubtitle =>
      'This helps us personalize your experience a little more';

  @override
  String get enterPhoneNumber => 'Enter Phone Number';

  @override
  String get saving => 'Saving…';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get createStrongPassword => 'Create a Strong Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get criteriaCapital => 'Should have a Capital Letter';

  @override
  String get criteriaNumber => 'Should have a Number e.g 1,2,4,etc';

  @override
  String get criteriaSpecial =>
      'Should have a Special Character e.g @,\$,%,etc';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter the email used in registration, we will\nsend a 6 digit OTP code for verification';

  @override
  String get passwordResetSuccess =>
      'Password reset successfully. Please log in.';

  @override
  String get resetYourPassword => 'Reset your Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get categoryPrefTitle => 'Let us know what events\nyou\'d want';

  @override
  String get categoryPrefSubtitle =>
      'We\'ll personalize your recommendations and search results.';

  @override
  String locationSaveError(String error) {
    return 'Could not save location: $error';
  }

  @override
  String get selectPreferredLocation => 'Select your Preferred Location';

  @override
  String get country => 'Country';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get city => 'City';

  @override
  String get selectYourCity => 'Select your city';

  @override
  String get thereFallback => 'there';

  @override
  String get homeWelcomeBack => 'Welcome back';

  @override
  String get searchVendorOrLocation => 'Search for a vendor or location';

  @override
  String get browseCategories => 'Browse Categories';

  @override
  String get yourUpcomingEvents => 'Your Upcoming Events';

  @override
  String get recommendedVendors => 'Recommended Vendors for you';

  @override
  String get recommendedProducts => 'Recommended Products for you';

  @override
  String get noUpcomingEvents => 'No upcoming events';

  @override
  String get viewAll => 'View All';

  @override
  String eventCardTitle(String name) {
    return '$name Event';
  }

  @override
  String get vendorLabel => 'Vendor';

  @override
  String get getQuote => 'Get Quote';

  @override
  String get rentForEvent => 'Rent for your event';

  @override
  String get addToEventPlus => 'Add to Event +';

  @override
  String get services => 'Services';

  @override
  String get products => 'Products';

  @override
  String get findYourVibe => 'Find your vibe';

  @override
  String get searchCategoriesHint => 'Search categories...';

  @override
  String get browseServicesByCategory => 'Browse Services by Category';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get filterReset => 'Reset';

  @override
  String get filters => 'Filters';

  @override
  String get priceRange => 'Price Range';

  @override
  String get rating => 'Rating';

  @override
  String get locationTitle => 'Location';

  @override
  String get enterCityOrArea => 'Enter city or area';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String applyFiltersCount(int count) {
    return 'Apply Filters ($count)';
  }

  @override
  String get searchProductsHint => 'Search products...';

  @override
  String searchCategoryHint(String name) {
    return 'Search $name...';
  }

  @override
  String get filterAll => 'All';

  @override
  String get availableForSale => 'Available for Sale';

  @override
  String get availableForRent => 'Available for Rent';

  @override
  String get somethingWentWrongRetry => 'Something went wrong. Tap to retry.';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get noVendorsFound => 'No vendors found';

  @override
  String get contactForPrice => 'Contact for price';

  @override
  String get moreFiltersComingSoon => 'More filter options coming soon.';

  @override
  String get close => 'Close';

  @override
  String get myEventsAmp => 'My Events & ';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get segMyEvents => 'My Events';

  @override
  String get orderTracking => 'Order Tracking';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get cancelledLabel => 'Cancelled';

  @override
  String get completedLabel => 'Completed';

  @override
  String get noPastEvents => 'No past events';

  @override
  String get noCancelledEvents => 'No cancelled events';

  @override
  String get eventChip => 'Event';

  @override
  String get noVendorsSourcedYet => 'No vendors sourced yet';

  @override
  String vendorsSourced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vendors sourced',
      one: '1 vendor sourced',
    );
    return '$_temp0';
  }

  @override
  String get viewDetails => 'View Details';

  @override
  String get singleLabel => 'Single';

  @override
  String get venueLabel => 'Venue';

  @override
  String get locationNotSet => 'Location not set';

  @override
  String get tabPurchase => 'Purchase';

  @override
  String get tabRentals => 'Rentals';

  @override
  String get noOrdersYet => 'No orders here yet';

  @override
  String get quoteLabel => 'Quote';

  @override
  String get addVendorTitle => 'Add vendor?';

  @override
  String addVendorBody(String vendor, String event) {
    return 'Add $vendor to \"$event\"?';
  }

  @override
  String get thisEvent => 'this event';

  @override
  String get addAction => 'Add';

  @override
  String vendorAddedToEvent(String vendor) {
    return '$vendor added to your event';
  }

  @override
  String get eventNotFound => 'Event Not Found';

  @override
  String get eventNotFoundBody => 'Event not found';

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guests',
      one: '1 guest',
    );
    return '$_temp0';
  }

  @override
  String get planningProgress => 'Planning progress';

  @override
  String budgetRangeLabel(String min, String max) {
    return 'Budget: $min – $max';
  }

  @override
  String get browseRecommendedHint =>
      'Browse the Recommended tab to add vendors to this event.';

  @override
  String get viewGroupChat => '💬 View Group Chat';

  @override
  String get createGroupChatBtn => '💬 Create Group Chat';

  @override
  String get addNewVendor => '+ Add a new Vendor';

  @override
  String get cancelEventBtn => '⚠ Cancel Event';

  @override
  String get cancelEventTitle => 'Cancel event?';

  @override
  String cancelEventBody(String name) {
    return 'This cancels \"$name\". This cannot be undone.';
  }

  @override
  String get keep => 'Keep';

  @override
  String get cancelEventAction => 'Cancel event';

  @override
  String get eventCancelled => 'Event cancelled';

  @override
  String get vendorsAvailableForEvent => 'Vendors available for your event';

  @override
  String get searchVendorsHint => 'Search vendors...';

  @override
  String get noVendorsAvailableYet => 'No vendors available yet';

  @override
  String get noVendorsInCategories => 'No vendors in the selected categories';

  @override
  String get tabVendors => 'Vendors';

  @override
  String get tabRecommended => 'Recommended';

  @override
  String get tabTimeline => 'Timeline';

  @override
  String get tabItems => 'Items';

  @override
  String get statusComplete => 'Complete';

  @override
  String get statusPending => 'Pending';

  @override
  String get tlEventCreated => 'Event created';

  @override
  String get tlSourceVendors => 'Source your vendors';

  @override
  String get tlEventConfirmed => 'Event confirmed';

  @override
  String tlEventDay(String date) {
    return 'Event day ($date)';
  }

  @override
  String get tlEventCompleted => 'Event completed';

  @override
  String get eventTimeline => 'Event Timeline';

  @override
  String get nothingAddedYet =>
      'Nothing added to this event yet.\nOpen a product or service and tap \"Add to Event\" to see it here.';

  @override
  String get addedToThisEvent => 'Added to this event';

  @override
  String get rentNow => 'Rent now';

  @override
  String get orderNow => 'Order now';

  @override
  String get requestQuote => 'Request Quote';

  @override
  String quoteInquiryMessage(String title, String event, String date) {
    return 'Hi! I\'d like a quote for \"$title\" for my event \"$event\" on $date.';
  }

  @override
  String get inquirySent => 'Inquiry sent — the vendor will send you a quote';

  @override
  String get createGroupChatTitle => 'Create group chat?';

  @override
  String get createGroupChatBody =>
      'All vendors attached to this event will automatically join — including any you add later. Quotes and invoices stay private in your direct chats.';

  @override
  String get createAction => 'Create';

  @override
  String get removeFromEventTitle => 'Remove from event?';

  @override
  String removeFromEventBody(String title, String event) {
    return 'Remove \"$title\" from $event?';
  }

  @override
  String get removeAction => 'Remove';

  @override
  String listingRemoved(String title) {
    return '$title removed';
  }

  @override
  String get createAnPrefix => 'Create an ';

  @override
  String get step1Subtitle => 'Step one, Choose the Event Type';

  @override
  String get eventType => 'Event Type';

  @override
  String get typeWedding => 'Wedding';

  @override
  String get typeBirthday => 'Birthday';

  @override
  String get typeCorporate => 'Corporate';

  @override
  String get typeGraduation => 'Graduation';

  @override
  String get otherLabel => 'Other';

  @override
  String get pleaseSpecify => 'Please Specify';

  @override
  String get eventPrefix => 'Event ';

  @override
  String get detailsHighlight => 'Details';

  @override
  String get step2Subtitle => 'Step Two, Enter your Event Details';

  @override
  String get eventTitle => 'Event Title';

  @override
  String get eventTitleHint => 'e.g. My Wedding Reception';

  @override
  String get eventDate => 'Event Date';

  @override
  String get selectDate => 'Select date';

  @override
  String get guestCount => 'Guest Count';

  @override
  String get timeFrom => 'Time From';

  @override
  String get startTime => 'Start time';

  @override
  String get timeTo => 'Time To';

  @override
  String get endTime => 'End time';

  @override
  String get venue => 'Venue';

  @override
  String get venueHint => 'Enter venue address';

  @override
  String get budgetMinLabel => 'Budget Min (₦)';

  @override
  String get budgetMaxLabel => 'Budget Max (₦)';

  @override
  String get eventThumbnail => 'Event Thumbnail';

  @override
  String get uploadThumbnail => 'Upload thumbnail';

  @override
  String get categoriesHighlight => 'Categories';

  @override
  String get step3Subtitle => 'Step Three, Select your Preferences';

  @override
  String get whatServicesNeeded => 'What services do you need for your event?';

  @override
  String get step4Subtitle => 'Step Four, Select your Vendors';

  @override
  String get eventCreatedAdded => 'Event created — added to it 🎉';

  @override
  String get eventCreated => 'Event created 🎉';

  @override
  String get recommendedVendorsForEvent => 'Recommended vendors for your event';

  @override
  String sourcedOfTotal(int sourced, int total) {
    return '$sourced of $total Vendors';
  }

  @override
  String get searchForItems => 'Search for items';

  @override
  String get addedCheck => 'Added ✓';

  @override
  String get reviewSourcedVendors => 'Review Sourced Vendors';

  @override
  String get createEventWithoutSourcing => 'Create Event without sourcing';

  @override
  String allVendorsSourced(int count) {
    return 'All $count Vendors sourced for all categories';
  }

  @override
  String get createEvent => 'Create Event';

  @override
  String get tabProductsToBuy => 'Products to buy';

  @override
  String get tabServicesToBook => 'Services to book';

  @override
  String get tabEquipmentRentals => 'Equipment rentals';

  @override
  String get verified => 'Verified';

  @override
  String serviceRadiusInfo(String location) {
    return '$location · 20km service radius';
  }

  @override
  String get businessHoursInfo => 'Mon–Sat · 9am–6pm';

  @override
  String get respondsWithin => 'Responds within ~30 mins';

  @override
  String get selectOptionPreference =>
      'Select an option based on your Preference';

  @override
  String get nothingHereYet => 'Nothing here yet.';

  @override
  String get serviceDetails => 'Service Details';

  @override
  String get description => 'Description';

  @override
  String get cancellationPolicy => 'Cancellation Policy:';

  @override
  String get moderateValue => 'Moderate';

  @override
  String get minServiceDuration => 'Minimum Service Duration:';

  @override
  String get fourHours => '4 hours';

  @override
  String get addToEvent => 'Add to Event';

  @override
  String get quoteSent => 'Quote Sent';

  @override
  String get removeVendor => 'Remove Vendor';

  @override
  String get swapVendor => 'Swap Vendor';

  @override
  String get tapStarsToRate => 'Tap the stars to rate your experience';

  @override
  String ratedStars(int rating) {
    return 'Rated $rating stars';
  }

  @override
  String get reviewSubmitted => 'Review submitted — thank you! ⭐';

  @override
  String get reviewTitle => 'Review';

  @override
  String get reviewSubtitle => 'Let us know how your booking went';

  @override
  String get leaveFeedback => 'Leave a Detailed feedback';

  @override
  String get feedbackHint => 'Let us know how your experience was';

  @override
  String get sending => 'Sending…';

  @override
  String get sendReview => 'Send Review';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get notice => 'Notice';

  @override
  String get cancelOrderNotice =>
      'Cancelling this order will notify the vendor and our support team. Cancellation fees may apply depending on the vendor\'s policy. Refunds are typically processed within 3-5 business days.';

  @override
  String get reasonForCancellation => 'Reason for cancellation';

  @override
  String get cancelReasonPlans => 'Change of plans';

  @override
  String get cancelReasonBetter => 'Found a better alternative';

  @override
  String get cancelReasonNoResponse => 'Vendor not responding';

  @override
  String get cancelReasonMistake => 'Ordered by mistake';

  @override
  String get cancelReasonOther => 'Other reason';

  @override
  String get describeIssue => 'Describe the issue';

  @override
  String get provideAdditionalDetails => 'Provide additional details...';

  @override
  String get messageVendorInstead => 'Message Vendor Instead';

  @override
  String get youLabel => 'You';

  @override
  String get memberLabel => 'Member';

  @override
  String get noMessagesYet => 'No messages yet — say hello 👋';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get addTodoTooltip => 'Add a to-do';

  @override
  String get paymentUpdate => 'Payment update';

  @override
  String get confirmedBanner => 'Confirmed';

  @override
  String get messageTheGroup => 'Message the group…';

  @override
  String get raiseDispute => 'Raise a dispute';

  @override
  String get disputeNotice =>
      'Raising a dispute will notify our support team who will investigate the issue. Please provide as much detail as possible. Disputes are typically resolved within 3-5 business days.';

  @override
  String get disputeCategory => 'Dispute category';

  @override
  String get disputeReasonNotDescribed => 'Item not as described';

  @override
  String get disputeReasonNoShow =>
      'Vendor did not show up / Complete the service';

  @override
  String get disputeReasonOvercharged => 'Overcharged / incorrect amount';

  @override
  String get disputeReasonDamaged => 'Damaged / missing item';

  @override
  String get disputeReasonOther => 'Other issue';

  @override
  String get describeWhatHappened => 'Describe what happened in detail...';

  @override
  String get attachEvidence => 'Attach evidence (optional)';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get submitDispute => 'Submit Dispute';

  @override
  String get requestRefund => 'Request Refund';

  @override
  String get refundNotice =>
      'Requesting a refund will notify our support team who will investigate the issue. Please provide as much detail as possible. Refund requests are typically resolved within 3-5 business days.';

  @override
  String get refundCategory => 'Refund category';

  @override
  String get refundReasonNotReceived => 'Item not received';

  @override
  String get refundReasonDamaged => 'Damaged item received';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get selectBank => 'Select Bank';

  @override
  String get enterAccountNumber => 'Enter Account Number';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderCouldNotLoad => 'This order could not be loaded.';

  @override
  String get orderFallback => 'Order';

  @override
  String get total => 'Total';

  @override
  String get statusHeading => 'Status';

  @override
  String get requirements => 'Requirements';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusOrderConfirmed => 'Order Confirmed';

  @override
  String get statusOutForDelivery => 'Out for Delivery';

  @override
  String get statusOrderPlaced => 'Order placed';

  @override
  String get requestRefundWarn => '⚠ Request Refund';

  @override
  String get cancelOrderWarn => '⚠ Cancel Order';

  @override
  String get rentalDetails => 'Rental Details';

  @override
  String get rentalCouldNotLoad => 'This rental could not be loaded.';

  @override
  String get rentalFallback => 'Rental';

  @override
  String get perDayRate => 'Per day rate';

  @override
  String get refundableDeposit => 'Refundable deposit';

  @override
  String get statusReturned => 'Returned';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get statusRequested => 'Requested';

  @override
  String get tabDetails => 'Details';

  @override
  String get serviceType => 'Service Type';

  @override
  String get addOns => 'Ad ons';

  @override
  String get guestSize => 'Guest Size';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get duration => 'Duration';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get quoteSentByVendor => 'Quote Sent by Vendor';

  @override
  String get bookingCompleted => 'Booking Completed';

  @override
  String get awaitingQuote => 'Awaiting Quote from vendor';

  @override
  String get viewQuote => 'View Quote';

  @override
  String get viewConversationHistory => 'View Conversation History';

  @override
  String get tlQuoteAccepted => 'Quote accepted';

  @override
  String get tlPaymentConfirmed => 'Payment confirmed';

  @override
  String get tlEventDayShort => 'Event day';

  @override
  String get bookingTimeline => 'Booking Timeline';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get leaveReviewBtn => '⭐ Leave a Review';

  @override
  String get messageVendor => '💬 Message Vendor';

  @override
  String get callVendor => '📞 Call Vendor';

  @override
  String get downloadReceipt => '📋 Download Booking Receipt';

  @override
  String get raiseDisputeBtn => '⚠ Raise a Dispute';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get tabActive => 'Active';

  @override
  String get noBookingsHere => 'No bookings here';

  @override
  String get noBookingsSubtitle =>
      'When you book a vendor, it will appear here.';

  @override
  String get selectEventDateError => 'Please select an event date';

  @override
  String get enterEventLocationError => 'Please enter the event location';

  @override
  String get bookingRequestSubmitted => 'Booking request submitted!';

  @override
  String get requestAQuote => 'Request a Quote';

  @override
  String get eventDetailsHeading => 'Event Details';

  @override
  String get selectEventDate => 'Select event date';

  @override
  String get eventLocation => 'Event Location';

  @override
  String get eventLocationHint => 'e.g. Eko Hotel, Victoria Island, Lagos';

  @override
  String get requirementsHint =>
      'Describe your event, guest count, special requests...';

  @override
  String get selectPackage => 'Select Package';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get bookingNotFound => 'Booking not found';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get progress => 'Progress';

  @override
  String get statusActive => 'Active';

  @override
  String get dateLabel => 'Date';

  @override
  String get cancelBookingTitle => 'Cancel Booking?';

  @override
  String get cancelBookingBody =>
      'Are you sure you want to cancel this booking?';

  @override
  String get noLabel => 'No';

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get paymentArrangedNotice =>
      'Payment is arranged directly between you and the vendor. Transactions happen outside Planovar and are at both parties\' own risk.';

  @override
  String get quoteNotFound => 'Quote not found';

  @override
  String quoteFrom(String vendor) {
    return 'Quote from $vendor';
  }

  @override
  String expiredOn(String date) {
    return 'Expired on $date';
  }

  @override
  String validUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get notesFromVendor => 'Notes from vendor';

  @override
  String get acceptAndBook => 'Accept & Book';

  @override
  String get acceptQuoteTitle => 'Accept Quote?';

  @override
  String acceptQuoteBody(String amount) {
    return 'Are you sure you want to accept this quote for $amount?';
  }

  @override
  String get quoteAcceptedInvoice =>
      'Quote accepted — arrange payment directly with the vendor.';

  @override
  String couldNotAcceptQuote(String error) {
    return 'Could not accept quote: $error';
  }

  @override
  String get decline => 'Decline';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get listingNotFound => 'Listing not found';

  @override
  String reviewsCountParen(int count) {
    return '($count) Reviews';
  }

  @override
  String get readLess => 'Read less';

  @override
  String get readMore => 'Read more';

  @override
  String get quantity => 'Quantity';

  @override
  String get sizes => 'Sizes';

  @override
  String get colorLabel => 'Color';

  @override
  String policyTitle(String policy) {
    return '$policy Cancellation Policy';
  }

  @override
  String get serviceDuration => 'Service Duration:';

  @override
  String get vendorDetails => 'Vendor Details';

  @override
  String get messageVendorPlain => 'Message Vendor';

  @override
  String get rentForYourEvent => 'Rent for your Event';

  @override
  String get addToEventPlusIcon => '+ Add to Event';

  @override
  String fromPrice(String price) {
    return 'From ₦ $price';
  }

  @override
  String get quoteOnRequest => 'Quote on request';

  @override
  String get policyFlexible1 =>
      'Full refund if cancelled up to 24 hours before the event.';

  @override
  String get policyFlexible2 => 'A small processing fee may apply.';

  @override
  String get policyStrict1 => 'No refund once the booking is confirmed.';

  @override
  String get policyModerate1 =>
      '100% refund if cancelled 7+ days before the event.';

  @override
  String get policyModerate2 =>
      '50% refund if cancelled 3–6 days before the event.';

  @override
  String get policyModerate3 => 'No refund within 48 hours of the event.';

  @override
  String get vendorNotFound => 'Vendor not found';

  @override
  String get linkCopied => 'Link copied to clipboard';

  @override
  String get tabAbout => 'About';

  @override
  String get tabReviews => 'Reviews';

  @override
  String get noDescriptionAvailable => 'No description available.';

  @override
  String get noProductsAvailable => 'No products available';

  @override
  String get noServicesAvailable => 'No services available';

  @override
  String verifiedReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verified reviews',
      one: '1 verified review',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get stayConnected => 'Stay Connected with your Vendors';

  @override
  String get searchConversations => 'Search conversations';

  @override
  String get noConversationsYet => 'No conversations yet';

  @override
  String get groupChat => 'Group Chat';

  @override
  String groupVendorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vendors',
      one: '1 vendor',
    );
    return 'Group · $_temp0';
  }

  @override
  String quoteSentAmount(String amount) {
    return 'Quote sent - ₦$amount · ';
  }

  @override
  String get tapToReview => 'Tap to Review';

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get quoteAcceptedInvoiceCreated =>
      'Quote accepted — arrange payment directly with the vendor 🎉';

  @override
  String get quoteDeclined => 'Quote declined';

  @override
  String quoteVersionValid(int version, String date) {
    return 'Version $version · valid till $date';
  }

  @override
  String get lineItems => 'Line items';

  @override
  String get paymentTerms => 'Payment terms';

  @override
  String get noteFromVendor => 'Note from the vendor';

  @override
  String get leaveAReview => 'Leave a review';

  @override
  String get shareYourExperience => 'Share your experience…';

  @override
  String get addShortComment => 'Add a short comment';

  @override
  String get reviewSubmittedStar => 'Review submitted ⭐';

  @override
  String get submitting => 'Submitting…';

  @override
  String get submitReviewBtn => 'Submit review';

  @override
  String get notYet => 'Not yet';

  @override
  String get today => 'Today';

  @override
  String get chatFallback => 'Chat';

  @override
  String get sayHello => 'Say hello 👋';

  @override
  String get quoteAcceptedBanner => 'Quote accepted';

  @override
  String get quoteExpired => 'Quote expired';

  @override
  String get declinedBanner => 'Declined';

  @override
  String depositRefundedAmount(String amount) {
    return 'Deposit refunded · ₦$amount';
  }

  @override
  String get depositRefunded => 'Deposit refunded';

  @override
  String paymentReceivedAmount(String amount) {
    return 'Payment received · ₦$amount';
  }

  @override
  String get paymentReceivedBanner => 'Payment received';

  @override
  String get orderUpdate => 'Order update';

  @override
  String reviewSubmittedRating(String rating) {
    return 'Review submitted · $rating★';
  }

  @override
  String get paymentConfirmedFallback => 'Payment confirmed';

  @override
  String get paymentProcessingFallback => 'Payment processing…';

  @override
  String get bookingCancelledFallback => 'This booking has been cancelled.';

  @override
  String get disputeRaisedFallback => 'A dispute has been raised.';

  @override
  String get howDidItGo => 'How did it go?';

  @override
  String get refundRequestedFallback => 'Refund request submitted.';

  @override
  String get paymentConfirmedTitle => 'Payment Confirmed';

  @override
  String get paymentProcessingTitle => 'Payment Processing';

  @override
  String get bookingCancelledTitle => 'Booking Cancelled';

  @override
  String get disputeRaisedTitle => 'Dispute Raised';

  @override
  String get disputeReviewNote =>
      'Our team will review this dispute within 24 hours.';

  @override
  String get howWasExperience => 'How was your experience?';

  @override
  String get leaveReviewPlain => 'Leave a Review';

  @override
  String get refundRequestedTitle => 'Refund Requested';

  @override
  String get refundProcessNote =>
      'Refund will be processed within 5–7 business days.';

  @override
  String get typeAMessage => 'Type a message';

  @override
  String get myAccount => 'My account';

  @override
  String get settingsSection => 'Settings';

  @override
  String get signOut => 'Sign out';

  @override
  String get yourProfile => 'Your profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get savedLabel => 'Saved';

  @override
  String get savedVendors => 'Saved Vendors';

  @override
  String get yourWishlist => 'Your Wishlist';

  @override
  String get myReviews => 'My Reviews';

  @override
  String get myReviewsSubtitle => 'View your overall ratings from vendors';

  @override
  String get theme => 'Theme';

  @override
  String get themeSubtitle => 'Select your preferred display';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get notificationsSubtitle => 'Manage alerts & preferences';

  @override
  String get privacySecurity => 'Privacy and Security';

  @override
  String get privacySubtitle => 'Account security settings';

  @override
  String get helpSupport => 'Help and Support';

  @override
  String get helpSubtitle => 'Visit our help centre for inquiries';

  @override
  String get deleteAccount => 'Delete your account';

  @override
  String get deleteAccountSubtitle => 'Permanently delete your account';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out';

  @override
  String couldNotUploadPhoto(String error) {
    return 'Could not upload photo: $error';
  }

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String couldNotUpdateProfile(String error) {
    return 'Could not update profile: $error';
  }

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get reviewsScreenSubtitle => 'View all your reviews from past events';

  @override
  String get noSavedVendors => 'No saved vendors yet';

  @override
  String get noSavedVendorsSub =>
      'Tap the heart on any vendor to save it here.';

  @override
  String get noSavedProducts => 'No saved products yet';

  @override
  String get noSavedProductsSub =>
      'Tap the heart on any product to save it here.';

  @override
  String get yourFavourites => 'Your Favourites';

  @override
  String get favouritesSubtitle => 'View all your saved vendors and products';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Create a new strong password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get hasCapital => 'Has capital letter';

  @override
  String get hasNumber => 'Has number';

  @override
  String get hasSpecial => 'Has special character';

  @override
  String get savePassword => 'Save Password';

  @override
  String get twoFactorAuth => 'Two factor authentication';

  @override
  String get twoFactorSubtitle => 'add an extra layer of security';

  @override
  String get twoFactorEmailDesc =>
      'Authentication code will be sent to your email for verification';

  @override
  String get twoFactorPhoneDesc =>
      'Authentication code will be sent to your phone for verification';

  @override
  String get savePreferences => 'Save Preferences';

  @override
  String get support => 'Support';

  @override
  String get chatWithTeam => 'Chat with our team';

  @override
  String get supportBeingSetup => 'Support is being set up';

  @override
  String get openLiveChatDesc =>
      'Open our live chat to talk to a support agent.';

  @override
  String get supportEmailDesc =>
      'Our live chat isn\'t connected yet — email us and we\'ll get right back to you.';

  @override
  String get openLiveChat => 'Open live chat';

  @override
  String get emailSupport => 'Email support';

  @override
  String get themeScreenSubtitle => 'Select your preferred theme appearance';

  @override
  String get lightLabel => 'Light';

  @override
  String get darkLabel => 'Dark';

  @override
  String get systemLabel => 'System';

  @override
  String get systemSubtitle => 'Use your default system preference';

  @override
  String get notifSettingsSubtitle =>
      'Manage when you\'ll receive notifications';

  @override
  String get allNotifications => 'All notifications';

  @override
  String get notifChannelDesc =>
      'Choose where you want to receive notifications';

  @override
  String get channelNone => 'None';

  @override
  String get channelInApp => 'In app';

  @override
  String get channelEmail => 'Email';

  @override
  String get channelBoth => 'Both';

  @override
  String get notifAllMessages => 'All messages';

  @override
  String get notifAllMessagesSub => 'someone replies your message';

  @override
  String get notifOrderDelivery => 'Order/Delivery Timeline';

  @override
  String get notifOrderDeliverySub =>
      'get notified when there\'s a new delivery status';

  @override
  String get notifEventTimeline => 'Event Timeline';

  @override
  String get notifEventTimelineSub =>
      'get notified when there\'s a new event timeline';

  @override
  String get notifPayment => 'Payment alerts';

  @override
  String get notifPaymentSub => 'get notified when a payment is successful';

  @override
  String get notifQuote => 'Quote / Invoice alerts';

  @override
  String get notifQuoteSub => 'get notified when you get a quote';

  @override
  String get notifVendorMatch => 'Vendor Match';

  @override
  String get notifVendorMatchSub => 'get alerts for recommended vendors';

  @override
  String get privacyScreenSubtitle =>
      'manage your password and 2 factor authentications';

  @override
  String get changeYourPassword => 'Change your password';

  @override
  String get changePasswordRowSub => 'Update your login credentials';

  @override
  String get twoFactorRow => '2 factor authentication';

  @override
  String get twoFactorRowSub => 'add extra layer of security';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpScreenSubtitle => 'Get real time help for all your inquires';

  @override
  String get searchForHelp => 'Search for help';

  @override
  String get emailSupportTitle => 'Email Support';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get liveChatSub =>
      'chat with our support team available Mon - Fri 8am - 5pm';

  @override
  String get phoneSupport => 'Phone Support';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqSub => 'Get answers to your burning questions';

  @override
  String get faqScreenTitle => 'Frequently Asked Questions';

  @override
  String get faqScreenSubtitle => 'Answers to your burning questions';

  @override
  String get searchFaqs => 'Search FAQs';

  @override
  String get faqQ1 => 'How do I book a vendor?';

  @override
  String get faqA1 =>
      'Browse vendors, tap on one you like, view their listings, and tap \"Request a Quote\" or \"Book Now\". Fill in your event details and submit. The vendor will respond within 24 hours.';

  @override
  String get faqQ2 => 'How does the payment process work?';

  @override
  String get faqA2 =>
      'Once a vendor accepts your booking and you accept their quote, you\'ll pay a 50% deposit to confirm the booking. The remaining balance is due 7 days before your event.';

  @override
  String get faqQ3 => 'Can I cancel a booking?';

  @override
  String get faqA3 =>
      'Yes, you can cancel a booking before it is confirmed at no charge. After confirmation, our cancellation policy applies — please review the vendor\'s cancellation terms in their profile.';

  @override
  String get faqQ4 => 'What if I\'m not satisfied with a vendor?';

  @override
  String get faqA4 =>
      'Contact our support team within 48 hours of your event. We\'ll mediate with the vendor and work towards a resolution, including partial refunds where appropriate.';

  @override
  String get faqQ5 => 'Are vendors verified?';

  @override
  String get faqA5 =>
      'Vendors with a verified badge have had their business credentials and portfolio reviewed by our team. We also use client reviews to maintain quality standards.';

  @override
  String get faqQ6 => 'How do I leave a review?';

  @override
  String get faqA6 =>
      'After your event is marked as completed, you\'ll receive a prompt to leave a review. You can also go to Bookings → Past → the completed booking → Leave Review.';

  @override
  String get sadToSeeYouGo => 'We\'re sad to see you go';

  @override
  String get letUsKnow => 'Let us know what went wrong';

  @override
  String get deleteReason1 => 'No longer using the platform/service';

  @override
  String get deleteReason2 => 'Found a better alternative';

  @override
  String get deleteReason3 => 'Privacy Concerns';

  @override
  String get deleteReason4 => 'Too many emails/notifications';

  @override
  String get deleteReason5 => 'Difficulty navigating the platform';

  @override
  String get deleteReason6 => 'Personal Reasons';

  @override
  String get deleteReason7 => 'Other not listed above';

  @override
  String get tellUsMore => 'Tell us more...';

  @override
  String get deleteAccountBtn => 'Delete Account';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get deleteAccountWarning =>
      'by deleting your account you will lose the following';

  @override
  String get deleteLoss1 => '• Access to your active events';

  @override
  String get deleteLoss2 => '• Access to your account records and credentials';

  @override
  String get deleteLoss3 => '• Login details';

  @override
  String get deleteLoss4 => '• All Vendor contacts via message and call';

  @override
  String get connecting => 'Connecting…';

  @override
  String get ringing => 'Ringing…';

  @override
  String get wrongAppTitle => 'Wrong app';

  @override
  String get wrongAppMessage =>
      'This account is registered as a vendor. Please use the Planovar Vendor app to sign in.';

  @override
  String get ok => 'OK';

  @override
  String get orderFeeBreakdown => 'Fee Breakdown';

  @override
  String get orderSubtotal => 'Subtotal';

  @override
  String get orderDeliveryFee => 'Delivery Fee';

  @override
  String get orderDeposit => 'Refundable Deposit';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderPaymentHistory => 'Payment History';

  @override
  String get orderPaid => 'Paid';

  @override
  String get orderDue => 'Due';

  @override
  String get orderPending => 'Pending';
}
