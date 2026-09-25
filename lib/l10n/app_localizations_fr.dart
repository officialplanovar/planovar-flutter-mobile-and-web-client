// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Langue';

  @override
  String get languageIntro =>
      'Choisissez votre langue préférée. L\'anglais est disponible maintenant — d\'autres arrivent bientôt.';

  @override
  String get comingSoon => 'Bientôt';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get retry => 'Réessayer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get search => 'Rechercher';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navEvents => 'Événements';

  @override
  String get navMessages => 'Messages';

  @override
  String get navProfile => 'Profil';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue =>
      'Connectez-vous pour continuer votre parcours sur Planovar';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get emailHint => 'Saisissez votre adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Saisissez le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get orLabel => 'ou';

  @override
  String get noAccountQuestion => 'Vous n\'avez pas de compte ?';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get emailRequired => 'L\'e-mail est requis';

  @override
  String get emailInvalid => 'Saisissez un e-mail valide';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get agreeTermsError =>
      'Veuillez accepter les Conditions et la Politique de confidentialité';

  @override
  String get registerHello => 'Bonjour ';

  @override
  String get registerWelcome => 'Bienvenue sur Planova ! Commençons';

  @override
  String get fullName => 'Nom complet';

  @override
  String get fullNameHint => 'Saisissez votre nom complet';

  @override
  String get fullNameRequired => 'Le nom complet est requis';

  @override
  String get proceed => 'Continuer';

  @override
  String get agreeTermsPrefix => 'En cochant la case, vous acceptez nos ';

  @override
  String get termsConditions => 'Conditions générales';

  @override
  String get andConnector => ' et ';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get signUpWithGoogle => 'S\'inscrire avec Google';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get getStarted => 'Commencer';

  @override
  String get onboard1TitleBlack => 'Fatigué de courir après d\'interminables';

  @override
  String get onboard1TitlePurple => 'recommandations ?';

  @override
  String get onboard1Body =>
      'Organiser un événement ne devrait pas ressembler à un second emploi. Fini la dispersion : découvrez des prestataires de qualité en quelques secondes.';

  @override
  String get onboard2TitleBlack => 'Les meilleurs talents, au bout de vos';

  @override
  String get onboard2TitlePurple => 'doigts.';

  @override
  String get onboard2Body =>
      'Accédez à notre réseau soigneusement sélectionné de traiteurs, décorateurs et photographes de premier plan. Une qualité vérifiée, à chaque fois.';

  @override
  String get onboard3TitleBlack => 'Rejoignez la communauté des pros de';

  @override
  String get onboard3TitlePurple => 'l\'organisation.';

  @override
  String get onboard3Body =>
      'Ne manquez pas les tarifs exclusifs des prestataires. Rejoignez plus de 50 000 utilisateurs qui vivent des moments inoubliables.';

  @override
  String get otpNewCodeSent => 'Un nouveau code a été envoyé';

  @override
  String otpResendError(String error) {
    return 'Impossible de renvoyer le code : $error';
  }

  @override
  String get otpVerifyPrompt =>
      'Saisissez le code que nous avons envoyé pour vérifier votre e-mail, ou appuyez sur Renvoyer.';

  @override
  String get verifyYourEmail => 'Vérifiez votre e-mail';

  @override
  String get confirmOtp => 'Confirmer le code';

  @override
  String get otpSentToEmail =>
      'Nous avons envoyé un code à 6 chiffres à votre e-mail';

  @override
  String get otpEnterSentTo => 'Saisissez le code envoyé à ';

  @override
  String resendInSeconds(int seconds) {
    return 'Renvoyer dans $seconds s';
  }

  @override
  String get resendOtp => 'Renvoyer le code';

  @override
  String get addPhoneTitle => 'Ajoutez votre numéro de téléphone';

  @override
  String get addPhoneSubtitle =>
      'Cela nous aide à personnaliser un peu plus votre expérience';

  @override
  String get enterPhoneNumber => 'Saisissez le numéro de téléphone';

  @override
  String get saving => 'Enregistrement…';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get createStrongPassword => 'Créez un mot de passe fort';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get criteriaCapital => 'Doit contenir une lettre majuscule';

  @override
  String get criteriaNumber =>
      'Doit contenir un chiffre, par ex. 1, 2, 4, etc.';

  @override
  String get criteriaSpecial =>
      'Doit contenir un caractère spécial, par ex. @, \$, %, etc.';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordSubtitle =>
      'Saisissez l\'e-mail utilisé lors de l\'inscription, nous\nenverrons un code OTP à 6 chiffres pour vérification';

  @override
  String get passwordResetSuccess =>
      'Mot de passe réinitialisé avec succès. Veuillez vous connecter.';

  @override
  String get resetYourPassword => 'Réinitialisez votre mot de passe';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get categoryPrefTitle => 'Dites-nous quels événements\nvous souhaitez';

  @override
  String get categoryPrefSubtitle =>
      'Nous personnaliserons vos recommandations et vos résultats de recherche.';

  @override
  String locationSaveError(String error) {
    return 'Impossible d\'enregistrer la localisation : $error';
  }

  @override
  String get selectPreferredLocation =>
      'Sélectionnez votre localisation préférée';

  @override
  String get country => 'Pays';

  @override
  String get selectCountry => 'Sélectionnez un pays';

  @override
  String get city => 'Ville';

  @override
  String get selectYourCity => 'Sélectionnez votre ville';

  @override
  String get thereFallback => 'vous';

  @override
  String get homeWelcomeBack => 'Bon retour';

  @override
  String get searchVendorOrLocation => 'Rechercher un prestataire ou un lieu';

  @override
  String get browseCategories => 'Parcourir les catégories';

  @override
  String get yourUpcomingEvents => 'Vos événements à venir';

  @override
  String get recommendedVendors => 'Prestataires recommandés pour vous';

  @override
  String get recommendedProducts => 'Produits recommandés pour vous';

  @override
  String get noUpcomingEvents => 'Aucun événement à venir';

  @override
  String get viewAll => 'Tout voir';

  @override
  String eventCardTitle(String name) {
    return 'Événement $name';
  }

  @override
  String get vendorLabel => 'Prestataire';

  @override
  String get getQuote => 'Obtenir un devis';

  @override
  String get rentForEvent => 'Louer pour votre événement';

  @override
  String get addToEventPlus => 'Ajouter à l\'événement +';

  @override
  String get services => 'Services';

  @override
  String get products => 'Produits';

  @override
  String get findYourVibe => 'Trouvez votre ambiance';

  @override
  String get searchCategoriesHint => 'Rechercher des catégories...';

  @override
  String get browseServicesByCategory => 'Parcourir les services par catégorie';

  @override
  String get noCategoriesFound => 'Aucune catégorie trouvée';

  @override
  String get filterReset => 'Réinitialiser';

  @override
  String get filters => 'Filtres';

  @override
  String get priceRange => 'Fourchette de prix';

  @override
  String get rating => 'Note';

  @override
  String get locationTitle => 'Localisation';

  @override
  String get enterCityOrArea => 'Saisissez une ville ou une zone';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String applyFiltersCount(int count) {
    return 'Appliquer les filtres ($count)';
  }

  @override
  String get searchProductsHint => 'Rechercher des produits...';

  @override
  String searchCategoryHint(String name) {
    return 'Rechercher $name...';
  }

  @override
  String get filterAll => 'Tous';

  @override
  String get availableForSale => 'Disponible à la vente';

  @override
  String get availableForRent => 'Disponible à la location';

  @override
  String get somethingWentWrongRetry =>
      'Une erreur s\'est produite. Appuyez pour réessayer.';

  @override
  String get noProductsFound => 'Aucun produit trouvé';

  @override
  String get noVendorsFound => 'Aucun prestataire trouvé';

  @override
  String get contactForPrice => 'Contacter pour le prix';

  @override
  String get moreFiltersComingSoon =>
      'D\'autres options de filtre arrivent bientôt.';

  @override
  String get close => 'Fermer';

  @override
  String get myEventsAmp => 'Mes événements et ';

  @override
  String get ordersTitle => 'commandes';

  @override
  String get segMyEvents => 'Mes événements';

  @override
  String get orderTracking => 'Suivi des commandes';

  @override
  String get upcoming => 'À venir';

  @override
  String get past => 'Passés';

  @override
  String get cancelledLabel => 'Annulé';

  @override
  String get completedLabel => 'Terminé';

  @override
  String get noPastEvents => 'Aucun événement passé';

  @override
  String get noCancelledEvents => 'Aucun événement annulé';

  @override
  String get eventChip => 'Événement';

  @override
  String get noVendorsSourcedYet => 'Aucun prestataire trouvé pour le moment';

  @override
  String vendorsSourced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prestataires trouvés',
      one: '1 prestataire trouvé',
    );
    return '$_temp0';
  }

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get singleLabel => 'Unique';

  @override
  String get venueLabel => 'Lieu';

  @override
  String get locationNotSet => 'Localisation non définie';

  @override
  String get tabPurchase => 'Achat';

  @override
  String get tabRentals => 'Locations';

  @override
  String get noOrdersYet => 'Aucune commande pour le moment';

  @override
  String get quoteLabel => 'Devis';

  @override
  String get addVendorTitle => 'Ajouter un prestataire ?';

  @override
  String addVendorBody(String vendor, String event) {
    return 'Ajouter $vendor à « $event » ?';
  }

  @override
  String get thisEvent => 'cet événement';

  @override
  String get addAction => 'Ajouter';

  @override
  String vendorAddedToEvent(String vendor) {
    return '$vendor a été ajouté à votre événement';
  }

  @override
  String get eventNotFound => 'Événement introuvable';

  @override
  String get eventNotFoundBody => 'Événement introuvable';

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invités',
      one: '1 invité',
    );
    return '$_temp0';
  }

  @override
  String get planningProgress => 'Progression de la planification';

  @override
  String budgetRangeLabel(String min, String max) {
    return 'Budget : $min – $max';
  }

  @override
  String get browseRecommendedHint =>
      'Parcourez l\'onglet Recommandés pour ajouter des prestataires à cet événement.';

  @override
  String get viewGroupChat => '💬 Voir la discussion de groupe';

  @override
  String get createGroupChatBtn => '💬 Créer une discussion de groupe';

  @override
  String get addNewVendor => '+ Ajouter un nouveau prestataire';

  @override
  String get cancelEventBtn => '⚠ Annuler l\'événement';

  @override
  String get cancelEventTitle => 'Annuler l\'événement ?';

  @override
  String cancelEventBody(String name) {
    return 'Cela annule « $name ». Cette action est irréversible.';
  }

  @override
  String get keep => 'Conserver';

  @override
  String get cancelEventAction => 'Annuler l\'événement';

  @override
  String get eventCancelled => 'Événement annulé';

  @override
  String get vendorsAvailableForEvent =>
      'Prestataires disponibles pour votre événement';

  @override
  String get searchVendorsHint => 'Rechercher des prestataires...';

  @override
  String get noVendorsAvailableYet =>
      'Aucun prestataire disponible pour le moment';

  @override
  String get noVendorsInCategories =>
      'Aucun prestataire dans les catégories sélectionnées';

  @override
  String get tabVendors => 'Prestataires';

  @override
  String get tabRecommended => 'Recommandés';

  @override
  String get tabTimeline => 'Chronologie';

  @override
  String get tabItems => 'Articles';

  @override
  String get statusComplete => 'Terminé';

  @override
  String get statusPending => 'En attente';

  @override
  String get tlEventCreated => 'Événement créé';

  @override
  String get tlSourceVendors => 'Trouvez vos prestataires';

  @override
  String get tlEventConfirmed => 'Événement confirmé';

  @override
  String tlEventDay(String date) {
    return 'Jour de l\'événement ($date)';
  }

  @override
  String get tlEventCompleted => 'Événement terminé';

  @override
  String get eventTimeline => 'Chronologie de l\'événement';

  @override
  String get nothingAddedYet =>
      'Rien n\'a encore été ajouté à cet événement.\nOuvrez un produit ou un service et appuyez sur « Ajouter à l\'événement » pour le voir ici.';

  @override
  String get addedToThisEvent => 'Ajouté à cet événement';

  @override
  String get rentNow => 'Louer maintenant';

  @override
  String get orderNow => 'Commander maintenant';

  @override
  String get requestQuote => 'Demander un devis';

  @override
  String quoteInquiryMessage(String title, String event, String date) {
    return 'Bonjour ! Je souhaiterais un devis pour « $title » pour mon événement « $event » le $date.';
  }

  @override
  String get inquirySent =>
      'Demande envoyée — le prestataire vous enverra un devis';

  @override
  String get createGroupChatTitle => 'Créer une discussion de groupe ?';

  @override
  String get createGroupChatBody =>
      'Tous les prestataires associés à cet événement rejoindront automatiquement la discussion — y compris ceux que vous ajouterez plus tard. Les devis et factures restent privés dans vos discussions directes.';

  @override
  String get createAction => 'Créer';

  @override
  String get removeFromEventTitle => 'Retirer de l\'événement ?';

  @override
  String removeFromEventBody(String title, String event) {
    return 'Retirer « $title » de $event ?';
  }

  @override
  String get removeAction => 'Retirer';

  @override
  String listingRemoved(String title) {
    return '$title a été retiré';
  }

  @override
  String get createAnPrefix => 'Créer un ';

  @override
  String get step1Subtitle => 'Étape une, choisissez le type d\'événement';

  @override
  String get eventType => 'Type d\'événement';

  @override
  String get typeWedding => 'Mariage';

  @override
  String get typeBirthday => 'Anniversaire';

  @override
  String get typeCorporate => 'Entreprise';

  @override
  String get typeGraduation => 'Remise de diplôme';

  @override
  String get otherLabel => 'Autre';

  @override
  String get pleaseSpecify => 'Veuillez préciser';

  @override
  String get eventPrefix => 'Événement ';

  @override
  String get detailsHighlight => 'Détails';

  @override
  String get step2Subtitle =>
      'Étape deux, saisissez les détails de votre événement';

  @override
  String get eventTitle => 'Titre de l\'événement';

  @override
  String get eventTitleHint => 'ex. Ma réception de mariage';

  @override
  String get eventDate => 'Date de l\'événement';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get guestCount => 'Nombre d\'invités';

  @override
  String get timeFrom => 'Heure de début';

  @override
  String get startTime => 'Heure de début';

  @override
  String get timeTo => 'Heure de fin';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get venue => 'Lieu';

  @override
  String get venueHint => 'Saisissez l\'adresse du lieu';

  @override
  String get budgetMinLabel => 'Budget min (₦)';

  @override
  String get budgetMaxLabel => 'Budget max (₦)';

  @override
  String get eventThumbnail => 'Vignette de l\'événement';

  @override
  String get uploadThumbnail => 'Téléverser une vignette';

  @override
  String get categoriesHighlight => 'Catégories';

  @override
  String get step3Subtitle => 'Étape trois, sélectionnez vos préférences';

  @override
  String get whatServicesNeeded =>
      'De quels services avez-vous besoin pour votre événement ?';

  @override
  String get step4Subtitle => 'Étape quatre, sélectionnez vos prestataires';

  @override
  String get eventCreatedAdded => 'Événement créé — ajouté à celui-ci 🎉';

  @override
  String get eventCreated => 'Événement créé 🎉';

  @override
  String get recommendedVendorsForEvent =>
      'Prestataires recommandés pour votre événement';

  @override
  String sourcedOfTotal(int sourced, int total) {
    return '$sourced sur $total prestataires';
  }

  @override
  String get searchForItems => 'Rechercher des articles';

  @override
  String get addedCheck => 'Ajouté ✓';

  @override
  String get reviewSourcedVendors => 'Vérifier les prestataires trouvés';

  @override
  String get createEventWithoutSourcing =>
      'Créer l\'événement sans prestataires';

  @override
  String allVendorsSourced(int count) {
    return 'Tous les $count prestataires trouvés pour toutes les catégories';
  }

  @override
  String get createEvent => 'Créer l\'événement';

  @override
  String get tabProductsToBuy => 'Produits à acheter';

  @override
  String get tabServicesToBook => 'Services à réserver';

  @override
  String get tabEquipmentRentals => 'Location d\'équipement';

  @override
  String get verified => 'Vérifié';

  @override
  String serviceRadiusInfo(String location) {
    return '$location · rayon de service de 20 km';
  }

  @override
  String get businessHoursInfo => 'Lun–Sam · 9h–18h';

  @override
  String get respondsWithin => 'Répond en ~30 min';

  @override
  String get selectOptionPreference =>
      'Sélectionnez une option selon votre préférence';

  @override
  String get nothingHereYet => 'Rien ici pour le moment.';

  @override
  String get serviceDetails => 'Détails du service';

  @override
  String get description => 'Description';

  @override
  String get cancellationPolicy => 'Politique d\'annulation :';

  @override
  String get moderateValue => 'Modérée';

  @override
  String get minServiceDuration => 'Durée minimale du service :';

  @override
  String get fourHours => '4 heures';

  @override
  String get addToEvent => 'Ajouter à l\'événement';

  @override
  String get quoteSent => 'Devis envoyé';

  @override
  String get removeVendor => 'Retirer le prestataire';

  @override
  String get swapVendor => 'Remplacer le prestataire';

  @override
  String get tapStarsToRate =>
      'Appuyez sur les étoiles pour noter votre expérience';

  @override
  String ratedStars(int rating) {
    return 'Noté $rating étoiles';
  }

  @override
  String get reviewSubmitted => 'Avis envoyé — merci ! ⭐';

  @override
  String get reviewTitle => 'Avis';

  @override
  String get reviewSubtitle =>
      'Dites-nous comment s\'est passée votre réservation';

  @override
  String get leaveFeedback => 'Laissez un avis détaillé';

  @override
  String get feedbackHint =>
      'Dites-nous comment s\'est passée votre expérience';

  @override
  String get sending => 'Envoi…';

  @override
  String get sendReview => 'Envoyer l\'avis';

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get notice => 'Avis';

  @override
  String get cancelOrderNotice =>
      'L\'annulation de cette commande avertira le prestataire et notre équipe d\'assistance. Des frais d\'annulation peuvent s\'appliquer selon la politique du prestataire. Les remboursements sont généralement traités sous 3 à 5 jours ouvrés.';

  @override
  String get reasonForCancellation => 'Motif de l\'annulation';

  @override
  String get cancelReasonPlans => 'Changement de plans';

  @override
  String get cancelReasonBetter => 'J\'ai trouvé une meilleure alternative';

  @override
  String get cancelReasonNoResponse => 'Le prestataire ne répond pas';

  @override
  String get cancelReasonMistake => 'Commandé par erreur';

  @override
  String get cancelReasonOther => 'Autre motif';

  @override
  String get describeIssue => 'Décrivez le problème';

  @override
  String get provideAdditionalDetails =>
      'Fournissez des détails supplémentaires...';

  @override
  String get messageVendorInstead => 'Contacter le prestataire à la place';

  @override
  String get youLabel => 'Vous';

  @override
  String get memberLabel => 'Membre';

  @override
  String get noMessagesYet => 'Aucun message pour le moment — dites bonjour 👋';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get addTodoTooltip => 'Ajouter une tâche';

  @override
  String get paymentUpdate => 'Mise à jour du paiement';

  @override
  String get confirmedBanner => 'Confirmé';

  @override
  String get messageTheGroup => 'Envoyer un message au groupe…';

  @override
  String get raiseDispute => 'Ouvrir un litige';

  @override
  String get disputeNotice =>
      'L\'ouverture d\'un litige avertira notre équipe d\'assistance qui enquêtera sur le problème. Veuillez fournir autant de détails que possible. Les litiges sont généralement résolus sous 3 à 5 jours ouvrés.';

  @override
  String get disputeCategory => 'Catégorie du litige';

  @override
  String get disputeReasonNotDescribed =>
      'Article non conforme à la description';

  @override
  String get disputeReasonNoShow =>
      'Le prestataire ne s\'est pas présenté / n\'a pas fourni le service';

  @override
  String get disputeReasonOvercharged => 'Surfacturé / montant incorrect';

  @override
  String get disputeReasonDamaged => 'Article endommagé / manquant';

  @override
  String get disputeReasonOther => 'Autre problème';

  @override
  String get describeWhatHappened =>
      'Décrivez en détail ce qui s\'est passé...';

  @override
  String get attachEvidence => 'Joindre des preuves (facultatif)';

  @override
  String get uploadImage => 'Téléverser une image';

  @override
  String get submitDispute => 'Soumettre le litige';

  @override
  String get requestRefund => 'Demander un remboursement';

  @override
  String get refundNotice =>
      'La demande de remboursement avertira notre équipe d\'assistance qui enquêtera sur le problème. Veuillez fournir autant de détails que possible. Les demandes de remboursement sont généralement résolues sous 3 à 5 jours ouvrés.';

  @override
  String get refundCategory => 'Catégorie du remboursement';

  @override
  String get refundReasonNotReceived => 'Article non reçu';

  @override
  String get refundReasonDamaged => 'Article reçu endommagé';

  @override
  String get bankDetails => 'Coordonnées bancaires';

  @override
  String get selectBank => 'Sélectionner une banque';

  @override
  String get enterAccountNumber => 'Saisissez le numéro de compte';

  @override
  String get orderDetails => 'Détails de la commande';

  @override
  String get orderCouldNotLoad => 'Cette commande n\'a pas pu être chargée.';

  @override
  String get orderFallback => 'Commande';

  @override
  String get total => 'Total';

  @override
  String get statusHeading => 'Statut';

  @override
  String get requirements => 'Exigences';

  @override
  String get statusDelivered => 'Livré';

  @override
  String get statusOrderConfirmed => 'Commande confirmée';

  @override
  String get statusOutForDelivery => 'En cours de livraison';

  @override
  String get statusOrderPlaced => 'Commande passée';

  @override
  String get requestRefundWarn => '⚠ Demander un remboursement';

  @override
  String get cancelOrderWarn => '⚠ Annuler la commande';

  @override
  String get rentalDetails => 'Détails de la location';

  @override
  String get rentalCouldNotLoad => 'Cette location n\'a pas pu être chargée.';

  @override
  String get rentalFallback => 'Location';

  @override
  String get perDayRate => 'Tarif journalier';

  @override
  String get refundableDeposit => 'Caution remboursable';

  @override
  String get statusReturned => 'Retourné';

  @override
  String get statusPickedUp => 'Récupéré';

  @override
  String get statusRequested => 'Demandé';

  @override
  String get tabDetails => 'Détails';

  @override
  String get serviceType => 'Type de service';

  @override
  String get addOns => 'Options';

  @override
  String get guestSize => 'Nombre d\'invités';

  @override
  String get dateAndTime => 'Date et heure';

  @override
  String get duration => 'Durée';

  @override
  String get additionalInformation => 'Informations complémentaires';

  @override
  String get quoteSentByVendor => 'Devis envoyé par le prestataire';

  @override
  String get bookingCompleted => 'Réservation terminée';

  @override
  String get awaitingQuote => 'En attente du devis du prestataire';

  @override
  String get viewQuote => 'Voir le devis';

  @override
  String get viewConversationHistory => 'Voir l\'historique de la conversation';

  @override
  String get tlQuoteAccepted => 'Devis accepté';

  @override
  String get tlPaymentConfirmed => 'Paiement confirmé';

  @override
  String get tlEventDayShort => 'Jour de l\'événement';

  @override
  String get bookingTimeline => 'Chronologie de la réservation';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get leaveReviewBtn => '⭐ Laisser un avis';

  @override
  String get messageVendor => '💬 Contacter le prestataire';

  @override
  String get callVendor => '📞 Appeler le prestataire';

  @override
  String get downloadReceipt => '📋 Télécharger le reçu de réservation';

  @override
  String get raiseDisputeBtn => '⚠ Ouvrir un litige';

  @override
  String get myBookings => 'Mes réservations';

  @override
  String get tabActive => 'Actives';

  @override
  String get noBookingsHere => 'Aucune réservation ici';

  @override
  String get noBookingsSubtitle =>
      'Lorsque vous réservez un prestataire, cela apparaîtra ici.';

  @override
  String get selectEventDateError =>
      'Veuillez sélectionner une date d\'événement';

  @override
  String get enterEventLocationError =>
      'Veuillez saisir le lieu de l\'événement';

  @override
  String get bookingRequestSubmitted => 'Demande de réservation envoyée !';

  @override
  String get requestAQuote => 'Demander un devis';

  @override
  String get eventDetailsHeading => 'Détails de l\'événement';

  @override
  String get selectEventDate => 'Sélectionner la date de l\'événement';

  @override
  String get eventLocation => 'Lieu de l\'événement';

  @override
  String get eventLocationHint => 'ex. Eko Hotel, Victoria Island, Lagos';

  @override
  String get requirementsHint =>
      'Décrivez votre événement, le nombre d\'invités, les demandes spéciales...';

  @override
  String get selectPackage => 'Sélectionner une formule';

  @override
  String get submitRequest => 'Envoyer la demande';

  @override
  String get bookingNotFound => 'Réservation introuvable';

  @override
  String get bookingDetails => 'Détails de la réservation';

  @override
  String get progress => 'Progression';

  @override
  String get statusActive => 'Active';

  @override
  String get dateLabel => 'Date';

  @override
  String get cancelBookingTitle => 'Annuler la réservation ?';

  @override
  String get cancelBookingBody =>
      'Êtes-vous sûr de vouloir annuler cette réservation ?';

  @override
  String get noLabel => 'Non';

  @override
  String get yesCancel => 'Oui, annuler';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get paymentArrangedNotice =>
      'Le paiement est organisé directement entre vous et le prestataire. Les transactions se déroulent en dehors de Planovar et sont aux risques des deux parties.';

  @override
  String get quoteNotFound => 'Devis introuvable';

  @override
  String quoteFrom(String vendor) {
    return 'Devis de $vendor';
  }

  @override
  String expiredOn(String date) {
    return 'Expiré le $date';
  }

  @override
  String validUntil(String date) {
    return 'Valable jusqu\'au $date';
  }

  @override
  String get notesFromVendor => 'Notes du prestataire';

  @override
  String get acceptAndBook => 'Accepter et réserver';

  @override
  String get acceptQuoteTitle => 'Accepter le devis ?';

  @override
  String acceptQuoteBody(String amount) {
    return 'Êtes-vous sûr de vouloir accepter ce devis pour $amount ?';
  }

  @override
  String get quoteAcceptedInvoice =>
      'Devis accepté — une facture a été ajoutée à votre discussion.';

  @override
  String couldNotAcceptQuote(String error) {
    return 'Impossible d\'accepter le devis : $error';
  }

  @override
  String get decline => 'Refuser';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get listingNotFound => 'Annonce introuvable';

  @override
  String reviewsCountParen(int count) {
    return '($count) avis';
  }

  @override
  String get readLess => 'Voir moins';

  @override
  String get readMore => 'Voir plus';

  @override
  String get quantity => 'Quantité';

  @override
  String get sizes => 'Tailles';

  @override
  String get colorLabel => 'Couleur';

  @override
  String policyTitle(String policy) {
    return 'Politique d\'annulation $policy';
  }

  @override
  String get serviceDuration => 'Durée du service :';

  @override
  String get vendorDetails => 'Détails du prestataire';

  @override
  String get messageVendorPlain => 'Contacter le prestataire';

  @override
  String get rentForYourEvent => 'Louer pour votre événement';

  @override
  String get addToEventPlusIcon => '+ Ajouter à l\'événement';

  @override
  String fromPrice(String price) {
    return 'À partir de ₦ $price';
  }

  @override
  String get quoteOnRequest => 'Devis sur demande';

  @override
  String get policyFlexible1 =>
      'Remboursement intégral en cas d\'annulation jusqu\'à 24 heures avant l\'événement.';

  @override
  String get policyFlexible2 =>
      'Des frais de traitement modiques peuvent s\'appliquer.';

  @override
  String get policyStrict1 =>
      'Aucun remboursement une fois la réservation confirmée.';

  @override
  String get policyModerate1 =>
      'Remboursement à 100 % en cas d\'annulation 7 jours ou plus avant l\'événement.';

  @override
  String get policyModerate2 =>
      'Remboursement à 50 % en cas d\'annulation 3 à 6 jours avant l\'événement.';

  @override
  String get policyModerate3 =>
      'Aucun remboursement dans les 48 heures précédant l\'événement.';

  @override
  String get vendorNotFound => 'Prestataire introuvable';

  @override
  String get linkCopied => 'Lien copié dans le presse-papiers';

  @override
  String get tabAbout => 'À propos';

  @override
  String get tabReviews => 'Avis';

  @override
  String get noDescriptionAvailable => 'Aucune description disponible.';

  @override
  String get noProductsAvailable => 'Aucun produit disponible';

  @override
  String get noServicesAvailable => 'Aucun service disponible';

  @override
  String verifiedReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis vérifiés',
      one: '1 avis vérifié',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsYet => 'Aucun avis pour le moment';

  @override
  String get stayConnected => 'Restez en contact avec vos prestataires';

  @override
  String get searchConversations => 'Rechercher des conversations';

  @override
  String get noConversationsYet => 'Aucune conversation pour le moment';

  @override
  String get groupChat => 'Discussion de groupe';

  @override
  String groupVendorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prestataires',
      one: '1 prestataire',
    );
    return 'Groupe · $_temp0';
  }

  @override
  String quoteSentAmount(String amount) {
    return 'Devis envoyé - ₦$amount · ';
  }

  @override
  String get tapToReview => 'Appuyez pour consulter';

  @override
  String daysAgo(int days) {
    return 'il y a $days j';
  }

  @override
  String get quoteAcceptedInvoiceCreated => 'Devis accepté — facture créée 🎉';

  @override
  String get quoteDeclined => 'Devis refusé';

  @override
  String quoteVersionValid(int version, String date) {
    return 'Version $version · valable jusqu\'au $date';
  }

  @override
  String get lineItems => 'Lignes du devis';

  @override
  String get paymentTerms => 'Conditions de paiement';

  @override
  String get noteFromVendor => 'Note du prestataire';

  @override
  String get leaveAReview => 'Laisser un avis';

  @override
  String get shareYourExperience => 'Partagez votre expérience…';

  @override
  String get addShortComment => 'Ajoutez un court commentaire';

  @override
  String get reviewSubmittedStar => 'Avis envoyé ⭐';

  @override
  String get submitting => 'Envoi…';

  @override
  String get submitReviewBtn => 'Envoyer l\'avis';

  @override
  String get couldNotOpenPayment => 'Impossible d\'ouvrir la page de paiement';

  @override
  String get finishPayment => 'Finaliser le paiement';

  @override
  String finishPaymentBody(String charge, String fee) {
    return 'Appuyez sur « J\'ai payé » une fois le paiement de ₦$charge effectué (frais de transaction de ₦$fee inclus) sur Paystack.';
  }

  @override
  String get notYet => 'Pas encore';

  @override
  String get ivePaid => 'J\'ai payé';

  @override
  String get paymentReceived => 'Paiement reçu 🎉';

  @override
  String get paymentStillProcessing =>
      'Le paiement est en cours de traitement — nous le mettrons à jour sous peu';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get chatFallback => 'Discussion';

  @override
  String get sayHello => 'Dites bonjour 👋';

  @override
  String get quoteAcceptedBanner => 'Devis accepté';

  @override
  String get quoteExpired => 'Devis expiré';

  @override
  String get declinedBanner => 'Refusé';

  @override
  String depositRefundedAmount(String amount) {
    return 'Caution remboursée · ₦$amount';
  }

  @override
  String get depositRefunded => 'Caution remboursée';

  @override
  String paymentReceivedAmount(String amount) {
    return 'Paiement reçu · ₦$amount';
  }

  @override
  String get paymentReceivedBanner => 'Paiement reçu';

  @override
  String get orderUpdate => 'Mise à jour de la commande';

  @override
  String reviewSubmittedRating(String rating) {
    return 'Avis envoyé · $rating★';
  }

  @override
  String get paymentConfirmedFallback => 'Paiement confirmé';

  @override
  String get paymentProcessingFallback => 'Paiement en cours…';

  @override
  String get bookingCancelledFallback => 'Cette réservation a été annulée.';

  @override
  String get disputeRaisedFallback => 'Un litige a été ouvert.';

  @override
  String get howDidItGo => 'Comment cela s\'est-il passé ?';

  @override
  String get refundRequestedFallback => 'Demande de remboursement envoyée.';

  @override
  String get paymentConfirmedTitle => 'Paiement confirmé';

  @override
  String get paymentProcessingTitle => 'Paiement en cours';

  @override
  String get bookingCancelledTitle => 'Réservation annulée';

  @override
  String get disputeRaisedTitle => 'Litige ouvert';

  @override
  String get disputeReviewNote =>
      'Notre équipe examinera ce litige sous 24 heures.';

  @override
  String get howWasExperience => 'Comment s\'est passée votre expérience ?';

  @override
  String get leaveReviewPlain => 'Laisser un avis';

  @override
  String get refundRequestedTitle => 'Remboursement demandé';

  @override
  String get refundProcessNote =>
      'Le remboursement sera traité sous 5 à 7 jours ouvrés.';

  @override
  String get typeAMessage => 'Écrivez un message';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get settingsSection => 'Paramètres';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get yourProfile => 'Votre profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get savedLabel => 'Enregistrés';

  @override
  String get savedVendors => 'Prestataires enregistrés';

  @override
  String get yourWishlist => 'Votre liste de souhaits';

  @override
  String get myReviews => 'Mes avis';

  @override
  String get myReviewsSubtitle =>
      'Consultez vos évaluations globales par les prestataires';

  @override
  String get theme => 'Thème';

  @override
  String get themeSubtitle => 'Choisissez votre affichage préféré';

  @override
  String get languageSubtitle => 'Choisissez votre langue préférée';

  @override
  String get notificationsSubtitle => 'Gérer les alertes et préférences';

  @override
  String get privacySecurity => 'Confidentialité et sécurité';

  @override
  String get privacySubtitle => 'Paramètres de sécurité du compte';

  @override
  String get helpSupport => 'Aide et assistance';

  @override
  String get helpSubtitle =>
      'Consultez notre centre d\'aide pour vos questions';

  @override
  String get deleteAccount => 'Supprimer votre compte';

  @override
  String get deleteAccountSubtitle => 'Supprimer définitivement votre compte';

  @override
  String get signOutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter';

  @override
  String couldNotUploadPhoto(String error) {
    return 'Impossible de téléverser la photo : $error';
  }

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String couldNotUpdateProfile(String error) {
    return 'Impossible de mettre à jour le profil : $error';
  }

  @override
  String get firstName => 'Prénom';

  @override
  String get enterFirstName => 'Saisissez le prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get enterLastName => 'Saisissez le nom';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get reviewsScreenSubtitle =>
      'Consultez tous vos avis d\'événements passés';

  @override
  String get noSavedVendors => 'Aucun prestataire enregistré';

  @override
  String get noSavedVendorsSub =>
      'Appuyez sur le cœur d\'un prestataire pour l\'enregistrer ici.';

  @override
  String get noSavedProducts => 'Aucun produit enregistré';

  @override
  String get noSavedProductsSub =>
      'Appuyez sur le cœur d\'un produit pour l\'enregistrer ici.';

  @override
  String get yourFavourites => 'Vos favoris';

  @override
  String get favouritesSubtitle =>
      'Consultez tous vos prestataires et produits enregistrés';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordSubtitle => 'Créez un nouveau mot de passe fort';

  @override
  String get enterNewPassword => 'Saisissez le nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmez le nouveau mot de passe';

  @override
  String get hasCapital => 'Contient une lettre majuscule';

  @override
  String get hasNumber => 'Contient un chiffre';

  @override
  String get hasSpecial => 'Contient un caractère spécial';

  @override
  String get savePassword => 'Enregistrer le mot de passe';

  @override
  String get twoFactorAuth => 'Authentification à deux facteurs';

  @override
  String get twoFactorSubtitle =>
      'ajoutez une couche de sécurité supplémentaire';

  @override
  String get twoFactorEmailDesc =>
      'Un code d\'authentification sera envoyé à votre e-mail pour vérification';

  @override
  String get twoFactorPhoneDesc =>
      'Un code d\'authentification sera envoyé à votre téléphone pour vérification';

  @override
  String get savePreferences => 'Enregistrer les préférences';

  @override
  String get support => 'Assistance';

  @override
  String get chatWithTeam => 'Discutez avec notre équipe';

  @override
  String get supportBeingSetup => 'L\'assistance est en cours de configuration';

  @override
  String get openLiveChatDesc =>
      'Ouvrez notre chat en direct pour parler à un agent d\'assistance.';

  @override
  String get supportEmailDesc =>
      'Notre chat en direct n\'est pas encore connecté — envoyez-nous un e-mail et nous vous répondrons rapidement.';

  @override
  String get openLiveChat => 'Ouvrir le chat en direct';

  @override
  String get emailSupport => 'Envoyer un e-mail à l\'assistance';

  @override
  String get themeScreenSubtitle =>
      'Sélectionnez votre apparence de thème préférée';

  @override
  String get lightLabel => 'Clair';

  @override
  String get darkLabel => 'Sombre';

  @override
  String get systemLabel => 'Système';

  @override
  String get systemSubtitle =>
      'Utiliser la préférence par défaut de votre système';

  @override
  String get notifSettingsSubtitle =>
      'Gérez quand vous recevrez des notifications';

  @override
  String get allNotifications => 'Toutes les notifications';

  @override
  String get notifChannelDesc =>
      'Choisissez où vous souhaitez recevoir les notifications';

  @override
  String get channelNone => 'Aucun';

  @override
  String get channelInApp => 'Dans l\'app';

  @override
  String get channelEmail => 'E-mail';

  @override
  String get channelBoth => 'Les deux';

  @override
  String get notifAllMessages => 'Tous les messages';

  @override
  String get notifAllMessagesSub => 'quelqu\'un répond à votre message';

  @override
  String get notifOrderDelivery => 'Suivi commande/livraison';

  @override
  String get notifOrderDeliverySub =>
      'soyez averti d\'un nouveau statut de livraison';

  @override
  String get notifEventTimeline => 'Chronologie de l\'événement';

  @override
  String get notifEventTimelineSub =>
      'soyez averti d\'une nouvelle chronologie d\'événement';

  @override
  String get notifPayment => 'Alertes de paiement';

  @override
  String get notifPaymentSub => 'soyez averti lorsqu\'un paiement aboutit';

  @override
  String get notifQuote => 'Alertes devis / facture';

  @override
  String get notifQuoteSub => 'soyez averti lorsque vous recevez un devis';

  @override
  String get notifVendorMatch => 'Correspondance prestataire';

  @override
  String get notifVendorMatchSub =>
      'recevez des alertes pour les prestataires recommandés';

  @override
  String get privacyScreenSubtitle =>
      'gérez votre mot de passe et l\'authentification à deux facteurs';

  @override
  String get changeYourPassword => 'Changer votre mot de passe';

  @override
  String get changePasswordRowSub =>
      'Mettez à jour vos identifiants de connexion';

  @override
  String get twoFactorRow => 'Authentification à deux facteurs';

  @override
  String get twoFactorRowSub => 'ajoutez une couche de sécurité supplémentaire';

  @override
  String get helpAndSupport => 'Aide et assistance';

  @override
  String get helpScreenSubtitle =>
      'Obtenez de l\'aide en temps réel pour toutes vos questions';

  @override
  String get searchForHelp => 'Rechercher de l\'aide';

  @override
  String get emailSupportTitle => 'Assistance par e-mail';

  @override
  String get liveChat => 'Chat en direct';

  @override
  String get liveChatSub =>
      'discutez avec notre équipe d\'assistance disponible du lun. au ven. de 8h à 17h';

  @override
  String get phoneSupport => 'Assistance téléphonique';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqSub => 'Obtenez des réponses à vos questions urgentes';

  @override
  String get faqScreenTitle => 'Foire aux questions';

  @override
  String get faqScreenSubtitle => 'Des réponses à vos questions urgentes';

  @override
  String get searchFaqs => 'Rechercher dans la FAQ';

  @override
  String get faqQ1 => 'Comment réserver un prestataire ?';

  @override
  String get faqA1 =>
      'Parcourez les prestataires, appuyez sur celui qui vous plaît, consultez ses annonces et appuyez sur « Demander un devis » ou « Réserver ». Renseignez les détails de votre événement et validez. Le prestataire répondra sous 24 heures.';

  @override
  String get faqQ2 => 'Comment fonctionne le processus de paiement ?';

  @override
  String get faqA2 =>
      'Une fois que le prestataire accepte votre réservation et que vous acceptez son devis, vous payez un acompte de 50 % pour confirmer la réservation. Le solde restant est dû 7 jours avant votre événement.';

  @override
  String get faqQ3 => 'Puis-je annuler une réservation ?';

  @override
  String get faqA3 =>
      'Oui, vous pouvez annuler une réservation avant sa confirmation, sans frais. Après confirmation, notre politique d\'annulation s\'applique — veuillez consulter les conditions d\'annulation du prestataire dans son profil.';

  @override
  String get faqQ4 =>
      'Que faire si je ne suis pas satisfait d\'un prestataire ?';

  @override
  String get faqA4 =>
      'Contactez notre équipe d\'assistance dans les 48 heures suivant votre événement. Nous ferons la médiation avec le prestataire et œuvrerons à une résolution, y compris des remboursements partiels le cas échéant.';

  @override
  String get faqQ5 => 'Les prestataires sont-ils vérifiés ?';

  @override
  String get faqA5 =>
      'Les prestataires avec un badge vérifié ont fait examiner leurs références professionnelles et leur portfolio par notre équipe. Nous utilisons également les avis clients pour maintenir des normes de qualité.';

  @override
  String get faqQ6 => 'Comment laisser un avis ?';

  @override
  String get faqA6 =>
      'Une fois votre événement marqué comme terminé, vous recevrez une invitation à laisser un avis. Vous pouvez aussi aller dans Réservations → Passées → la réservation terminée → Laisser un avis.';

  @override
  String get sadToSeeYouGo => 'Nous sommes tristes de vous voir partir';

  @override
  String get letUsKnow => 'Dites-nous ce qui n\'a pas fonctionné';

  @override
  String get deleteReason1 => 'Je n\'utilise plus la plateforme/le service';

  @override
  String get deleteReason2 => 'J\'ai trouvé une meilleure alternative';

  @override
  String get deleteReason3 => 'Préoccupations liées à la confidentialité';

  @override
  String get deleteReason4 => 'Trop d\'e-mails/notifications';

  @override
  String get deleteReason5 => 'Difficulté à naviguer sur la plateforme';

  @override
  String get deleteReason6 => 'Raisons personnelles';

  @override
  String get deleteReason7 => 'Autre non listé ci-dessus';

  @override
  String get tellUsMore => 'Dites-nous en plus...';

  @override
  String get deleteAccountBtn => 'Supprimer le compte';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get deleteAccountWarning =>
      'en supprimant votre compte, vous perdrez ce qui suit';

  @override
  String get deleteLoss1 => '• L\'accès à vos événements actifs';

  @override
  String get deleteLoss2 =>
      '• L\'accès à vos données de compte et identifiants';

  @override
  String get deleteLoss3 => '• Les informations de connexion';

  @override
  String get deleteLoss4 =>
      '• Tous les contacts de prestataires par message et appel';

  @override
  String get connecting => 'Connexion…';

  @override
  String get ringing => 'Sonnerie…';

  @override
  String get wrongAppTitle => 'Mauvaise application';

  @override
  String get wrongAppMessage =>
      'Ce compte est enregistré en tant que vendeur. Veuillez utiliser l\'application Planovar Vendor pour vous connecter.';

  @override
  String get ok => 'OK';

  @override
  String get orderFeeBreakdown => 'Détail des frais';

  @override
  String get orderSubtotal => 'Sous-total';

  @override
  String get orderDeliveryFee => 'Frais de livraison';

  @override
  String get orderPlatformFee => 'Frais de plateforme';

  @override
  String get orderDeposit => 'Caution remboursable';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderPaymentHistory => 'Historique des paiements';

  @override
  String get orderPaid => 'Payé';

  @override
  String get orderDue => 'À payer';

  @override
  String get orderPending => 'En attente';
}
