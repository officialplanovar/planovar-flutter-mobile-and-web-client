// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Idioma';

  @override
  String get languageIntro =>
      'Elige tu idioma preferido. El inglés ya está disponible — pronto habrá más.';

  @override
  String get comingSoon => 'Pronto';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get retry => 'Reintentar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get search => 'Buscar';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get navHome => 'Inicio';

  @override
  String get navExplore => 'Explorar';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navMessages => 'Mensajes';

  @override
  String get navProfile => 'Perfil';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToContinue =>
      'Inicia sesión para continuar tu recorrido en Planovar';

  @override
  String get emailAddress => 'Correo electrónico';

  @override
  String get emailHint => 'Introduce tu correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Introduce la contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get orLabel => 'o';

  @override
  String get noAccountQuestion => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get emailInvalid => 'Introduce un correo electrónico válido';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get agreeTermsError =>
      'Acepta los Términos y la Política de privacidad';

  @override
  String get registerHello => 'Hola ';

  @override
  String get registerWelcome => '¡Bienvenido a Planova! Empecemos';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get fullNameHint => 'Introduce tu nombre completo';

  @override
  String get fullNameRequired => 'El nombre completo es obligatorio';

  @override
  String get proceed => 'Continuar';

  @override
  String get agreeTermsPrefix => 'Al marcar la casilla aceptas nuestros ';

  @override
  String get termsConditions => 'Términos y Condiciones';

  @override
  String get andConnector => ' y ';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get signUpWithGoogle => 'Regístrate con Google';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? ';

  @override
  String get signInLink => 'Iniciar sesión';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get onboard1TitleBlack => 'Cansado de perseguir infinitas';

  @override
  String get onboard1TitlePurple => '¿recomendaciones?';

  @override
  String get onboard1Body =>
      'Organizar un evento no debería parecer un segundo trabajo. Acaba con la dispersión y descubre proveedores de calidad en segundos.';

  @override
  String get onboard2TitleBlack => 'El mejor talento, al alcance de tu';

  @override
  String get onboard2TitlePurple => 'mano.';

  @override
  String get onboard2Body =>
      'Accede a nuestra red seleccionada de los mejores servicios de catering, decoración y fotografía. Calidad verificada, siempre.';

  @override
  String get onboard3TitleBlack => 'Únete a la comunidad de';

  @override
  String get onboard3TitlePurple => 'organizadores profesionales.';

  @override
  String get onboard3Body =>
      'No te pierdas tarifas exclusivas de proveedores. Únete a más de 50.000 usuarios que viven momentos inolvidables.';

  @override
  String get otpNewCodeSent => 'Se ha enviado un nuevo código';

  @override
  String otpResendError(String error) {
    return 'No se pudo reenviar el código: $error';
  }

  @override
  String get otpVerifyPrompt =>
      'Introduce el código que enviamos para verificar tu correo, o toca Reenviar.';

  @override
  String get verifyYourEmail => 'Verifica tu correo';

  @override
  String get confirmOtp => 'Confirmar código';

  @override
  String get otpSentToEmail =>
      'Hemos enviado un código de 6 dígitos a tu correo';

  @override
  String get otpEnterSentTo => 'Introduce el código enviado a ';

  @override
  String resendInSeconds(int seconds) {
    return 'Reenviar en $seconds s';
  }

  @override
  String get resendOtp => 'Reenviar código';

  @override
  String get addPhoneTitle => 'Añade tu número de teléfono';

  @override
  String get addPhoneSubtitle =>
      'Esto nos ayuda a personalizar un poco más tu experiencia';

  @override
  String get enterPhoneNumber => 'Introduce el número de teléfono';

  @override
  String get dialCodeHint => 'Código';

  @override
  String get saving => 'Guardando…';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get createStrongPassword => 'Crea una contraseña segura';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get criteriaCapital => 'Debe tener una letra mayúscula';

  @override
  String get criteriaNumber => 'Debe tener un número, p. ej. 1, 2, 4, etc.';

  @override
  String get criteriaSpecial =>
      'Debe tener un carácter especial, p. ej. @, \$, %, etc.';

  @override
  String get forgotPasswordTitle => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordSubtitle =>
      'Introduce el correo usado en el registro y\nenviaremos un código OTP de 6 dígitos para verificarlo';

  @override
  String get passwordResetSuccess =>
      'Contraseña restablecida correctamente. Inicia sesión.';

  @override
  String get resetYourPassword => 'Restablece tu contraseña';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get categoryPrefTitle => 'Cuéntanos qué eventos\ndeseas';

  @override
  String get categoryPrefSubtitle =>
      'Personalizaremos tus recomendaciones y resultados de búsqueda.';

  @override
  String locationSaveError(String error) {
    return 'No se pudo guardar la ubicación: $error';
  }

  @override
  String get selectPreferredLocation => 'Selecciona tu ubicación preferida';

  @override
  String get country => 'País';

  @override
  String get selectCountry => 'Selecciona un país';

  @override
  String get city => 'Ciudad';

  @override
  String get selectYourCity => 'Selecciona tu ciudad';

  @override
  String get thereFallback => 'ti';

  @override
  String get homeWelcomeBack => 'Bienvenido de nuevo';

  @override
  String get searchVendorOrLocation => 'Busca un proveedor o ubicación';

  @override
  String get browseCategories => 'Explorar categorías';

  @override
  String get yourUpcomingEvents => 'Tus próximos eventos';

  @override
  String get recommendedVendors => 'Proveedores recomendados para ti';

  @override
  String get recommendedProducts => 'Productos recomendados para ti';

  @override
  String get noUpcomingEvents => 'No hay eventos próximos';

  @override
  String get viewAll => 'Ver todo';

  @override
  String eventCardTitle(String name) {
    return 'Evento $name';
  }

  @override
  String get vendorLabel => 'Proveedor';

  @override
  String get getQuote => 'Obtener presupuesto';

  @override
  String get rentForEvent => 'Alquila para tu evento';

  @override
  String get addToEventPlus => 'Añadir al evento +';

  @override
  String get services => 'Servicios';

  @override
  String get products => 'Productos';

  @override
  String get findYourVibe => 'Encuentra tu estilo';

  @override
  String get searchCategoriesHint => 'Buscar categorías...';

  @override
  String get browseServicesByCategory => 'Explorar servicios por categoría';

  @override
  String get noCategoriesFound => 'No se encontraron categorías';

  @override
  String get filterReset => 'Restablecer';

  @override
  String get filters => 'Filtros';

  @override
  String get priceRange => 'Rango de precio';

  @override
  String get rating => 'Valoración';

  @override
  String get locationTitle => 'Ubicación';

  @override
  String get enterCityOrArea => 'Introduce una ciudad o zona';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String applyFiltersCount(int count) {
    return 'Aplicar filtros ($count)';
  }

  @override
  String get searchProductsHint => 'Buscar productos...';

  @override
  String searchCategoryHint(String name) {
    return 'Buscar $name...';
  }

  @override
  String get filterAll => 'Todos';

  @override
  String get availableForSale => 'Disponible para venta';

  @override
  String get availableForRent => 'Disponible para alquiler';

  @override
  String get somethingWentWrongRetry => 'Algo salió mal. Toca para reintentar.';

  @override
  String get noProductsFound => 'No se encontraron productos';

  @override
  String get noVendorsFound => 'No se encontraron proveedores';

  @override
  String get contactForPrice => 'Consultar precio';

  @override
  String get moreFiltersComingSoon => 'Pronto habrá más opciones de filtro.';

  @override
  String get close => 'Cerrar';

  @override
  String get myEventsAmp => 'Mis eventos y ';

  @override
  String get ordersTitle => 'pedidos';

  @override
  String get segMyEvents => 'Mis eventos';

  @override
  String get orderTracking => 'Seguimiento de pedidos';

  @override
  String get upcoming => 'Próximos';

  @override
  String get past => 'Pasados';

  @override
  String get cancelledLabel => 'Cancelado';

  @override
  String get completedLabel => 'Completado';

  @override
  String get noPastEvents => 'No hay eventos pasados';

  @override
  String get noCancelledEvents => 'No hay eventos cancelados';

  @override
  String get eventChip => 'Evento';

  @override
  String get noVendorsSourcedYet => 'Aún no se han añadido proveedores';

  @override
  String vendorsSourced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count proveedores añadidos',
      one: '1 proveedor añadido',
    );
    return '$_temp0';
  }

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get singleLabel => 'Individual';

  @override
  String get venueLabel => 'Lugar';

  @override
  String get locationNotSet => 'Ubicación no establecida';

  @override
  String get tabPurchase => 'Compra';

  @override
  String get tabRentals => 'Alquileres';

  @override
  String get noOrdersYet => 'Aún no hay pedidos aquí';

  @override
  String get quoteLabel => 'Presupuesto';

  @override
  String get addVendorTitle => '¿Añadir proveedor?';

  @override
  String addVendorBody(String vendor, String event) {
    return '¿Añadir $vendor a \"$event\"?';
  }

  @override
  String get thisEvent => 'este evento';

  @override
  String get addAction => 'Añadir';

  @override
  String vendorAddedToEvent(String vendor) {
    return '$vendor añadido a tu evento';
  }

  @override
  String get eventNotFound => 'Evento no encontrado';

  @override
  String get eventNotFoundBody => 'Evento no encontrado';

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invitados',
      one: '1 invitado',
    );
    return '$_temp0';
  }

  @override
  String get planningProgress => 'Progreso de la planificación';

  @override
  String budgetRangeLabel(String min, String max) {
    return 'Presupuesto: $min – $max';
  }

  @override
  String get browseRecommendedHint =>
      'Explora la pestaña Recomendados para añadir proveedores a este evento.';

  @override
  String get viewGroupChat => '💬 Ver chat de grupo';

  @override
  String get createGroupChatBtn => '💬 Crear chat de grupo';

  @override
  String get addNewVendor => '+ Añadir un nuevo proveedor';

  @override
  String get cancelEventBtn => '⚠ Cancelar evento';

  @override
  String get cancelEventTitle => '¿Cancelar evento?';

  @override
  String cancelEventBody(String name) {
    return 'Esto cancela \"$name\". No se puede deshacer.';
  }

  @override
  String get keep => 'Mantener';

  @override
  String get cancelEventAction => 'Cancelar evento';

  @override
  String get eventCancelled => 'Evento cancelado';

  @override
  String get vendorsAvailableForEvent =>
      'Proveedores disponibles para tu evento';

  @override
  String get searchVendorsHint => 'Buscar proveedores...';

  @override
  String get noVendorsAvailableYet => 'Aún no hay proveedores disponibles';

  @override
  String get noVendorsInCategories =>
      'No hay proveedores en las categorías seleccionadas';

  @override
  String get tabVendors => 'Proveedores';

  @override
  String get tabRecommended => 'Recomendados';

  @override
  String get tabTimeline => 'Cronología';

  @override
  String get tabItems => 'Artículos';

  @override
  String get statusComplete => 'Completado';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get tlEventCreated => 'Evento creado';

  @override
  String get tlSourceVendors => 'Busca tus proveedores';

  @override
  String get tlEventConfirmed => 'Evento confirmado';

  @override
  String tlEventDay(String date) {
    return 'Día del evento ($date)';
  }

  @override
  String get tlEventCompleted => 'Evento completado';

  @override
  String get eventTimeline => 'Cronología del evento';

  @override
  String get nothingAddedYet =>
      'Aún no has añadido nada a este evento.\nAbre un producto o servicio y toca \"Añadir al evento\" para verlo aquí.';

  @override
  String get addedToThisEvent => 'Añadido a este evento';

  @override
  String get rentNow => 'Alquilar ahora';

  @override
  String get orderNow => 'Pedir ahora';

  @override
  String get requestQuote => 'Solicitar presupuesto';

  @override
  String quoteInquiryMessage(String title, String event, String date) {
    return '¡Hola! Me gustaría un presupuesto para \"$title\" para mi evento \"$event\" el $date.';
  }

  @override
  String get inquirySent =>
      'Consulta enviada — el proveedor te enviará un presupuesto';

  @override
  String get createGroupChatTitle => '¿Crear chat de grupo?';

  @override
  String get createGroupChatBody =>
      'Todos los proveedores asociados a este evento se unirán automáticamente, incluidos los que añadas más adelante. Los presupuestos y las facturas permanecen privados en tus chats directos.';

  @override
  String get createAction => 'Crear';

  @override
  String get removeFromEventTitle => '¿Quitar del evento?';

  @override
  String removeFromEventBody(String title, String event) {
    return '¿Quitar \"$title\" de $event?';
  }

  @override
  String get removeAction => 'Quitar';

  @override
  String listingRemoved(String title) {
    return '$title eliminado';
  }

  @override
  String get createAnPrefix => 'Crear un ';

  @override
  String get step1Subtitle => 'Paso uno, elige el tipo de evento';

  @override
  String get eventType => 'Tipo de evento';

  @override
  String get typeWedding => 'Boda';

  @override
  String get typeBirthday => 'Cumpleaños';

  @override
  String get typeCorporate => 'Corporativo';

  @override
  String get typeGraduation => 'Graduación';

  @override
  String get otherLabel => 'Otro';

  @override
  String get pleaseSpecify => 'Especifica';

  @override
  String get eventPrefix => 'Evento ';

  @override
  String get detailsHighlight => 'Detalles';

  @override
  String get step2Subtitle => 'Paso dos, introduce los detalles de tu evento';

  @override
  String get eventTitle => 'Título del evento';

  @override
  String get eventTitleHint => 'p. ej. Mi banquete de boda';

  @override
  String get eventDate => 'Fecha del evento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get guestCount => 'Número de invitados';

  @override
  String get timeFrom => 'Desde las';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get timeTo => 'Hasta las';

  @override
  String get endTime => 'Hora de fin';

  @override
  String get venue => 'Lugar';

  @override
  String get venueHint => 'Introduce la dirección del lugar';

  @override
  String get budgetMinLabel => 'Presupuesto mín. (\$)';

  @override
  String get budgetMaxLabel => 'Presupuesto máx. (\$)';

  @override
  String get eventThumbnail => 'Miniatura del evento';

  @override
  String get uploadThumbnail => 'Subir miniatura';

  @override
  String get categoriesHighlight => 'Categorías';

  @override
  String get step3Subtitle => 'Paso tres, selecciona tus preferencias';

  @override
  String get whatServicesNeeded => '¿Qué servicios necesitas para tu evento?';

  @override
  String get step4Subtitle => 'Paso cuatro, selecciona tus proveedores';

  @override
  String get eventCreatedAdded => 'Evento creado — añadido a él 🎉';

  @override
  String get eventCreated => 'Evento creado 🎉';

  @override
  String get recommendedVendorsForEvent =>
      'Proveedores recomendados para tu evento';

  @override
  String sourcedOfTotal(int sourced, int total) {
    return '$sourced de $total proveedores';
  }

  @override
  String get searchForItems => 'Buscar artículos';

  @override
  String get addedCheck => 'Añadido ✓';

  @override
  String get reviewSourcedVendors => 'Revisar proveedores añadidos';

  @override
  String get createEventWithoutSourcing =>
      'Crear evento sin buscar proveedores';

  @override
  String allVendorsSourced(int count) {
    return 'Los $count proveedores añadidos para todas las categorías';
  }

  @override
  String get createEvent => 'Crear evento';

  @override
  String get tabProductsToBuy => 'Productos para comprar';

  @override
  String get tabServicesToBook => 'Servicios para reservar';

  @override
  String get tabEquipmentRentals => 'Alquiler de equipos';

  @override
  String get verified => 'Verificado';

  @override
  String serviceRadiusInfo(String location) {
    return '$location · radio de servicio de 20 km';
  }

  @override
  String get businessHoursInfo => 'Lun–Sáb · 9:00–18:00';

  @override
  String get respondsWithin => 'Responde en ~30 min';

  @override
  String get selectOptionPreference =>
      'Selecciona una opción según tu preferencia';

  @override
  String get nothingHereYet => 'Aún no hay nada aquí.';

  @override
  String get serviceDetails => 'Detalles del servicio';

  @override
  String get description => 'Descripción';

  @override
  String get cancellationPolicy => 'Política de cancelación:';

  @override
  String get moderateValue => 'Moderada';

  @override
  String get minServiceDuration => 'Duración mínima del servicio:';

  @override
  String get fourHours => '4 horas';

  @override
  String get addToEvent => 'Añadir al evento';

  @override
  String get quoteSent => 'Presupuesto enviado';

  @override
  String get removeVendor => 'Quitar proveedor';

  @override
  String get swapVendor => 'Cambiar proveedor';

  @override
  String get tapStarsToRate => 'Toca las estrellas para valorar tu experiencia';

  @override
  String ratedStars(int rating) {
    return 'Valorado con $rating estrellas';
  }

  @override
  String get reviewSubmitted => 'Reseña enviada — ¡gracias! ⭐';

  @override
  String get reviewTitle => 'Reseña';

  @override
  String get reviewSubtitle => 'Cuéntanos cómo fue tu reserva';

  @override
  String get leaveFeedback => 'Deja un comentario detallado';

  @override
  String get feedbackHint => 'Cuéntanos cómo fue tu experiencia';

  @override
  String get sending => 'Enviando…';

  @override
  String get sendReview => 'Enviar reseña';

  @override
  String get cancelOrder => 'Cancelar pedido';

  @override
  String get notice => 'Aviso';

  @override
  String get cancelOrderNotice =>
      'Cancelar este pedido notificará al proveedor y a nuestro equipo de soporte. Pueden aplicarse tarifas de cancelación según la política del proveedor. Los reembolsos suelen procesarse en un plazo de 3 a 5 días hábiles.';

  @override
  String get reasonForCancellation => 'Motivo de la cancelación';

  @override
  String get cancelReasonPlans => 'Cambio de planes';

  @override
  String get cancelReasonBetter => 'Encontré una mejor alternativa';

  @override
  String get cancelReasonNoResponse => 'El proveedor no responde';

  @override
  String get cancelReasonMistake => 'Pedido por error';

  @override
  String get cancelReasonOther => 'Otro motivo';

  @override
  String get describeIssue => 'Describe el problema';

  @override
  String get provideAdditionalDetails => 'Proporciona detalles adicionales...';

  @override
  String get messageVendorInstead => 'Mejor enviar un mensaje al proveedor';

  @override
  String get youLabel => 'Tú';

  @override
  String get memberLabel => 'Miembro';

  @override
  String get noMessagesYet => 'Aún no hay mensajes — saluda 👋';

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get addTodoTooltip => 'Añadir una tarea';

  @override
  String get paymentUpdate => 'Actualización de pago';

  @override
  String get confirmedBanner => 'Confirmado';

  @override
  String get messageTheGroup => 'Escribe al grupo…';

  @override
  String get raiseDispute => 'Presentar una disputa';

  @override
  String get disputeNotice =>
      'Presentar una disputa notificará a nuestro equipo de soporte, que investigará el problema. Proporciona todos los detalles posibles. Las disputas suelen resolverse en un plazo de 3 a 5 días hábiles.';

  @override
  String get disputeCategory => 'Categoría de la disputa';

  @override
  String get disputeReasonNotDescribed => 'El artículo no es como se describió';

  @override
  String get disputeReasonNoShow =>
      'El proveedor no se presentó / no completó el servicio';

  @override
  String get disputeReasonOvercharged => 'Cobro excesivo / importe incorrecto';

  @override
  String get disputeReasonDamaged => 'Artículo dañado / faltante';

  @override
  String get disputeReasonOther => 'Otro problema';

  @override
  String get describeWhatHappened => 'Describe en detalle lo que ocurrió...';

  @override
  String get attachEvidence => 'Adjuntar pruebas (opcional)';

  @override
  String get uploadImage => 'Subir imagen';

  @override
  String get submitDispute => 'Enviar disputa';

  @override
  String get requestRefund => 'Solicitar reembolso';

  @override
  String get refundNotice =>
      'Solicitar un reembolso notificará a nuestro equipo de soporte, que investigará el problema. Proporciona todos los detalles posibles. Las solicitudes de reembolso suelen resolverse en un plazo de 3 a 5 días hábiles.';

  @override
  String get refundCategory => 'Categoría del reembolso';

  @override
  String get refundReasonNotReceived => 'Artículo no recibido';

  @override
  String get refundReasonDamaged => 'Artículo dañado recibido';

  @override
  String get bankDetails => 'Datos bancarios';

  @override
  String get selectBank => 'Selecciona el banco';

  @override
  String get enterAccountNumber => 'Introduce el número de cuenta';

  @override
  String get orderDetails => 'Detalles del pedido';

  @override
  String get orderCouldNotLoad => 'No se pudo cargar este pedido.';

  @override
  String get orderFallback => 'Pedido';

  @override
  String get total => 'Total';

  @override
  String get statusHeading => 'Estado';

  @override
  String get requirements => 'Requisitos';

  @override
  String get statusDelivered => 'Entregado';

  @override
  String get statusOrderConfirmed => 'Pedido confirmado';

  @override
  String get statusOutForDelivery => 'En reparto';

  @override
  String get statusOrderPlaced => 'Pedido realizado';

  @override
  String get requestRefundWarn => '⚠ Solicitar reembolso';

  @override
  String get cancelOrderWarn => '⚠ Cancelar pedido';

  @override
  String get rentalDetails => 'Detalles del alquiler';

  @override
  String get rentalCouldNotLoad => 'No se pudo cargar este alquiler.';

  @override
  String get rentalFallback => 'Alquiler';

  @override
  String get perDayRate => 'Tarifa por día';

  @override
  String get refundableDeposit => 'Depósito reembolsable';

  @override
  String get statusReturned => 'Devuelto';

  @override
  String get statusPickedUp => 'Recogido';

  @override
  String get statusRequested => 'Solicitado';

  @override
  String get tabDetails => 'Detalles';

  @override
  String get serviceType => 'Tipo de servicio';

  @override
  String get addOns => 'Extras';

  @override
  String get guestSize => 'Número de invitados';

  @override
  String get dateAndTime => 'Fecha y hora';

  @override
  String get duration => 'Duración';

  @override
  String get additionalInformation => 'Información adicional';

  @override
  String get quoteSentByVendor => 'Presupuesto enviado por el proveedor';

  @override
  String get bookingCompleted => 'Reserva completada';

  @override
  String get awaitingQuote => 'Esperando el presupuesto del proveedor';

  @override
  String get viewQuote => 'Ver presupuesto';

  @override
  String get viewConversationHistory => 'Ver historial de conversación';

  @override
  String get tlQuoteAccepted => 'Presupuesto aceptado';

  @override
  String get tlPaymentConfirmed => 'Pago confirmado';

  @override
  String get tlEventDayShort => 'Día del evento';

  @override
  String get bookingTimeline => 'Cronología de la reserva';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get leaveReviewBtn => '⭐ Dejar una reseña';

  @override
  String get messageVendor => '💬 Enviar mensaje al proveedor';

  @override
  String get callVendor => '📞 Llamar al proveedor';

  @override
  String get downloadReceipt => '📋 Descargar recibo de la reserva';

  @override
  String get raiseDisputeBtn => '⚠ Presentar una disputa';

  @override
  String get myBookings => 'Mis reservas';

  @override
  String get tabActive => 'Activas';

  @override
  String get noBookingsHere => 'No hay reservas aquí';

  @override
  String get noBookingsSubtitle =>
      'Cuando reserves un proveedor, aparecerá aquí.';

  @override
  String get selectEventDateError => 'Selecciona una fecha para el evento';

  @override
  String get enterEventLocationError => 'Introduce la ubicación del evento';

  @override
  String get bookingRequestSubmitted => '¡Solicitud de reserva enviada!';

  @override
  String get requestAQuote => 'Solicitar un presupuesto';

  @override
  String get eventDetailsHeading => 'Detalles del evento';

  @override
  String get selectEventDate => 'Selecciona la fecha del evento';

  @override
  String get eventLocation => 'Ubicación del evento';

  @override
  String get eventLocationHint => 'p. ej. Grand Hotel, Centro';

  @override
  String get requirementsHint =>
      'Describe tu evento, número de invitados, peticiones especiales...';

  @override
  String get selectPackage => 'Selecciona un paquete';

  @override
  String get submitRequest => 'Enviar solicitud';

  @override
  String get bookingNotFound => 'Reserva no encontrada';

  @override
  String get bookingDetails => 'Detalles de la reserva';

  @override
  String get progress => 'Progreso';

  @override
  String get statusActive => 'Activa';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get cancelBookingTitle => '¿Cancelar reserva?';

  @override
  String get cancelBookingBody => '¿Seguro que quieres cancelar esta reserva?';

  @override
  String get noLabel => 'No';

  @override
  String get yesCancel => 'Sí, cancelar';

  @override
  String get cancelBooking => 'Cancelar reserva';

  @override
  String get paymentArrangedNotice =>
      'El pago se acuerda directamente entre tú y el proveedor. Las transacciones ocurren fuera de Planovar y son responsabilidad de ambas partes.';

  @override
  String get quoteNotFound => 'Presupuesto no encontrado';

  @override
  String quoteFrom(String vendor) {
    return 'Presupuesto de $vendor';
  }

  @override
  String expiredOn(String date) {
    return 'Caducó el $date';
  }

  @override
  String validUntil(String date) {
    return 'Válido hasta el $date';
  }

  @override
  String get notesFromVendor => 'Notas del proveedor';

  @override
  String get acceptAndBook => 'Aceptar y reservar';

  @override
  String get acceptQuoteTitle => '¿Aceptar presupuesto?';

  @override
  String acceptQuoteBody(String amount) {
    return '¿Seguro que quieres aceptar este presupuesto por $amount?';
  }

  @override
  String get quoteAcceptedInvoice =>
      'Presupuesto aceptado — organiza el pago directamente con el proveedor.';

  @override
  String couldNotAcceptQuote(String error) {
    return 'No se pudo aceptar el presupuesto: $error';
  }

  @override
  String get decline => 'Rechazar';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get noNotifications => 'No hay notificaciones';

  @override
  String get listingNotFound => 'Anuncio no encontrado';

  @override
  String reviewsCountParen(int count) {
    return '($count) reseñas';
  }

  @override
  String get readLess => 'Leer menos';

  @override
  String get readMore => 'Leer más';

  @override
  String get quantity => 'Cantidad';

  @override
  String get sizes => 'Tallas';

  @override
  String get colorLabel => 'Color';

  @override
  String policyTitle(String policy) {
    return 'Política de cancelación $policy';
  }

  @override
  String get serviceDuration => 'Duración del servicio:';

  @override
  String get vendorDetails => 'Detalles del proveedor';

  @override
  String get messageVendorPlain => 'Enviar mensaje al proveedor';

  @override
  String get rentForYourEvent => 'Alquila para tu evento';

  @override
  String get addToEventPlusIcon => '+ Añadir al evento';

  @override
  String fromPrice(String price) {
    return 'Desde \$$price';
  }

  @override
  String get quoteOnRequest => 'Presupuesto a petición';

  @override
  String get policyFlexible1 =>
      'Reembolso completo si se cancela hasta 24 horas antes del evento.';

  @override
  String get policyFlexible2 =>
      'Puede aplicarse una pequeña tarifa de gestión.';

  @override
  String get policyStrict1 => 'Sin reembolso una vez confirmada la reserva.';

  @override
  String get policyModerate1 =>
      'Reembolso del 100 % si se cancela 7 o más días antes del evento.';

  @override
  String get policyModerate2 =>
      'Reembolso del 50 % si se cancela entre 3 y 6 días antes del evento.';

  @override
  String get policyModerate3 =>
      'Sin reembolso dentro de las 48 horas previas al evento.';

  @override
  String get vendorNotFound => 'Proveedor no encontrado';

  @override
  String get linkCopied => 'Enlace copiado al portapapeles';

  @override
  String get tabAbout => 'Acerca de';

  @override
  String get tabReviews => 'Reseñas';

  @override
  String get noDescriptionAvailable => 'No hay descripción disponible.';

  @override
  String get noProductsAvailable => 'No hay productos disponibles';

  @override
  String get noServicesAvailable => 'No hay servicios disponibles';

  @override
  String verifiedReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseñas verificadas',
      one: '1 reseña verificada',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsYet => 'Aún no hay reseñas';

  @override
  String get stayConnected => 'Mantente en contacto con tus proveedores';

  @override
  String get searchConversations => 'Buscar conversaciones';

  @override
  String get noConversationsYet => 'Aún no hay conversaciones';

  @override
  String get groupChat => 'Chat de grupo';

  @override
  String groupVendorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count proveedores',
      one: '1 proveedor',
    );
    return 'Grupo · $_temp0';
  }

  @override
  String quoteSentAmount(String amount) {
    return 'Presupuesto enviado - \$$amount · ';
  }

  @override
  String get tapToReview => 'Toca para reseñar';

  @override
  String daysAgo(int days) {
    return 'hace $days d';
  }

  @override
  String get quoteAcceptedInvoiceCreated =>
      'Presupuesto aceptado — organiza el pago directamente con el proveedor 🎉';

  @override
  String get quoteDeclined => 'Presupuesto rechazado';

  @override
  String quoteVersionValid(int version, String date) {
    return 'Versión $version · válido hasta el $date';
  }

  @override
  String get lineItems => 'Conceptos';

  @override
  String get paymentTerms => 'Condiciones de pago';

  @override
  String get noteFromVendor => 'Nota del proveedor';

  @override
  String get leaveAReview => 'Deja una reseña';

  @override
  String get shareYourExperience => 'Comparte tu experiencia…';

  @override
  String get addShortComment => 'Añade un comentario breve';

  @override
  String get reviewSubmittedStar => 'Reseña enviada ⭐';

  @override
  String get submitting => 'Enviando…';

  @override
  String get submitReviewBtn => 'Enviar reseña';

  @override
  String get notYet => 'Todavía no';

  @override
  String get today => 'Hoy';

  @override
  String get chatFallback => 'Chat';

  @override
  String get sayHello => 'Saluda 👋';

  @override
  String get quoteAcceptedBanner => 'Presupuesto aceptado';

  @override
  String get quoteExpired => 'Presupuesto caducado';

  @override
  String get declinedBanner => 'Rechazado';

  @override
  String depositRefundedAmount(String amount) {
    return 'Depósito reembolsado · \$$amount';
  }

  @override
  String get depositRefunded => 'Depósito reembolsado';

  @override
  String paymentReceivedAmount(String amount) {
    return 'Pago recibido · \$$amount';
  }

  @override
  String get paymentReceivedBanner => 'Pago recibido';

  @override
  String get orderUpdate => 'Actualización del pedido';

  @override
  String reviewSubmittedRating(String rating) {
    return 'Reseña enviada · $rating★';
  }

  @override
  String get paymentConfirmedFallback => 'Pago confirmado';

  @override
  String get paymentProcessingFallback => 'Procesando el pago…';

  @override
  String get bookingCancelledFallback => 'Esta reserva ha sido cancelada.';

  @override
  String get disputeRaisedFallback => 'Se ha presentado una disputa.';

  @override
  String get howDidItGo => '¿Cómo fue?';

  @override
  String get refundRequestedFallback => 'Solicitud de reembolso enviada.';

  @override
  String get paymentConfirmedTitle => 'Pago confirmado';

  @override
  String get paymentProcessingTitle => 'Procesando el pago';

  @override
  String get bookingCancelledTitle => 'Reserva cancelada';

  @override
  String get disputeRaisedTitle => 'Disputa presentada';

  @override
  String get disputeReviewNote =>
      'Nuestro equipo revisará esta disputa en un plazo de 24 horas.';

  @override
  String get howWasExperience => '¿Qué tal tu experiencia?';

  @override
  String get leaveReviewPlain => 'Dejar una reseña';

  @override
  String get refundRequestedTitle => 'Reembolso solicitado';

  @override
  String get refundProcessNote =>
      'El reembolso se procesará en un plazo de 5 a 7 días hábiles.';

  @override
  String get typeAMessage => 'Escribe un mensaje';

  @override
  String get myAccount => 'Mi cuenta';

  @override
  String get settingsSection => 'Ajustes';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get yourProfile => 'Tu perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get savedLabel => 'Guardados';

  @override
  String get savedVendors => 'Proveedores guardados';

  @override
  String get yourWishlist => 'Tu lista de deseos';

  @override
  String get myReviews => 'Mis reseñas';

  @override
  String get myReviewsSubtitle =>
      'Consulta tus valoraciones generales de los proveedores';

  @override
  String get theme => 'Tema';

  @override
  String get themeSubtitle => 'Selecciona tu apariencia preferida';

  @override
  String get languageSubtitle => 'Elige tu idioma preferido';

  @override
  String get notificationsSubtitle => 'Gestiona alertas y preferencias';

  @override
  String get privacySecurity => 'Privacidad y seguridad';

  @override
  String get privacySubtitle => 'Ajustes de seguridad de la cuenta';

  @override
  String get helpSupport => 'Ayuda y soporte';

  @override
  String get helpSubtitle => 'Visita nuestro centro de ayuda para consultas';

  @override
  String get deleteAccount => 'Eliminar tu cuenta';

  @override
  String get deleteAccountSubtitle => 'Elimina tu cuenta de forma permanente';

  @override
  String get signOutConfirm => '¿Seguro que quieres cerrar sesión?';

  @override
  String couldNotUploadPhoto(String error) {
    return 'No se pudo subir la foto: $error';
  }

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String couldNotUpdateProfile(String error) {
    return 'No se pudo actualizar el perfil: $error';
  }

  @override
  String get firstName => 'Nombre';

  @override
  String get enterFirstName => 'Introduce el nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get enterLastName => 'Introduce el apellido';

  @override
  String get phoneNumber => 'Número de teléfono';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get reviewsScreenSubtitle =>
      'Consulta todas tus reseñas de eventos pasados';

  @override
  String get noSavedVendors => 'Aún no hay proveedores guardados';

  @override
  String get noSavedVendorsSub =>
      'Toca el corazón en cualquier proveedor para guardarlo aquí.';

  @override
  String get noSavedProducts => 'Aún no hay productos guardados';

  @override
  String get noSavedProductsSub =>
      'Toca el corazón en cualquier producto para guardarlo aquí.';

  @override
  String get yourFavourites => 'Tus favoritos';

  @override
  String get favouritesSubtitle =>
      'Consulta todos tus proveedores y productos guardados';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get changePasswordSubtitle => 'Crea una nueva contraseña segura';

  @override
  String get enterNewPassword => 'Introduce la nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirma la nueva contraseña';

  @override
  String get hasCapital => 'Tiene letra mayúscula';

  @override
  String get hasNumber => 'Tiene número';

  @override
  String get hasSpecial => 'Tiene carácter especial';

  @override
  String get savePassword => 'Guardar contraseña';

  @override
  String get twoFactorAuth => 'Autenticación de dos factores';

  @override
  String get twoFactorSubtitle => 'añade una capa extra de seguridad';

  @override
  String get twoFactorEmailDesc =>
      'Se enviará un código de autenticación a tu correo para verificarlo';

  @override
  String get twoFactorPhoneDesc =>
      'Se enviará un código de autenticación a tu teléfono para verificarlo';

  @override
  String get savePreferences => 'Guardar preferencias';

  @override
  String get support => 'Soporte';

  @override
  String get chatWithTeam => 'Chatea con nuestro equipo';

  @override
  String get supportBeingSetup => 'El soporte se está configurando';

  @override
  String get openLiveChatDesc =>
      'Abre nuestro chat en vivo para hablar con un agente de soporte.';

  @override
  String get supportEmailDesc =>
      'Nuestro chat en vivo aún no está conectado — escríbenos y te responderemos enseguida.';

  @override
  String get openLiveChat => 'Abrir chat en vivo';

  @override
  String get emailSupport => 'Soporte por correo';

  @override
  String get themeScreenSubtitle =>
      'Selecciona la apariencia de tema que prefieras';

  @override
  String get lightLabel => 'Claro';

  @override
  String get darkLabel => 'Oscuro';

  @override
  String get systemLabel => 'Sistema';

  @override
  String get systemSubtitle =>
      'Usa la preferencia predeterminada de tu sistema';

  @override
  String get notifSettingsSubtitle =>
      'Gestiona cuándo recibirás notificaciones';

  @override
  String get allNotifications => 'Todas las notificaciones';

  @override
  String get notifChannelDesc =>
      'Elige dónde quieres recibir las notificaciones';

  @override
  String get channelNone => 'Ninguno';

  @override
  String get channelInApp => 'En la app';

  @override
  String get channelEmail => 'Correo';

  @override
  String get channelBoth => 'Ambos';

  @override
  String get notifAllMessages => 'Todos los mensajes';

  @override
  String get notifAllMessagesSub => 'alguien responde a tu mensaje';

  @override
  String get notifOrderDelivery => 'Cronología de pedido/entrega';

  @override
  String get notifOrderDeliverySub =>
      'recibe una notificación cuando haya un nuevo estado de entrega';

  @override
  String get notifEventTimeline => 'Cronología del evento';

  @override
  String get notifEventTimelineSub =>
      'recibe una notificación cuando haya una nueva cronología del evento';

  @override
  String get notifPayment => 'Alertas de pago';

  @override
  String get notifPaymentSub =>
      'recibe una notificación cuando un pago sea exitoso';

  @override
  String get notifQuote => 'Alertas de presupuesto / factura';

  @override
  String get notifQuoteSub =>
      'recibe una notificación cuando obtengas un presupuesto';

  @override
  String get notifVendorMatch => 'Coincidencia de proveedores';

  @override
  String get notifVendorMatchSub =>
      'recibe alertas de proveedores recomendados';

  @override
  String get privacyScreenSubtitle =>
      'gestiona tu contraseña y la autenticación de dos factores';

  @override
  String get changeYourPassword => 'Cambia tu contraseña';

  @override
  String get changePasswordRowSub => 'Actualiza tus credenciales de acceso';

  @override
  String get twoFactorRow => 'Autenticación de dos factores';

  @override
  String get twoFactorRowSub => 'añade una capa extra de seguridad';

  @override
  String get helpAndSupport => 'Ayuda y soporte';

  @override
  String get helpScreenSubtitle =>
      'Obtén ayuda en tiempo real para todas tus consultas';

  @override
  String get searchForHelp => 'Buscar ayuda';

  @override
  String get emailSupportTitle => 'Soporte por correo';

  @override
  String get liveChat => 'Chat en vivo';

  @override
  String get liveChatSub =>
      'chatea con nuestro equipo de soporte disponible de lun a vie de 8:00 a 17:00';

  @override
  String get phoneSupport => 'Soporte telefónico';

  @override
  String get faqTitle => 'Preguntas frecuentes';

  @override
  String get faqSub => 'Obtén respuestas a tus dudas más urgentes';

  @override
  String get faqScreenTitle => 'Preguntas frecuentes';

  @override
  String get faqScreenSubtitle => 'Respuestas a tus dudas más urgentes';

  @override
  String get searchFaqs => 'Buscar preguntas frecuentes';

  @override
  String get faqQ1 => '¿Cómo reservo un proveedor?';

  @override
  String get faqA1 =>
      'Explora los proveedores, toca uno que te guste, mira sus anuncios y toca \"Solicitar un presupuesto\" o \"Reservar ahora\". Rellena los detalles de tu evento y envíalo. El proveedor responderá en un plazo de 24 horas.';

  @override
  String get faqQ2 => '¿Cómo funciona el proceso de pago?';

  @override
  String get faqA2 =>
      'Una vez que un proveedor acepta tu reserva y tú aceptas su presupuesto, pagarás un depósito del 50 % para confirmar la reserva. El saldo restante se abona 7 días antes de tu evento.';

  @override
  String get faqQ3 => '¿Puedo cancelar una reserva?';

  @override
  String get faqA3 =>
      'Sí, puedes cancelar una reserva antes de que se confirme sin coste alguno. Después de la confirmación, se aplica nuestra política de cancelación — revisa las condiciones de cancelación del proveedor en su perfil.';

  @override
  String get faqQ4 => '¿Y si no estoy satisfecho con un proveedor?';

  @override
  String get faqA4 =>
      'Contacta con nuestro equipo de soporte en un plazo de 48 horas tras tu evento. Mediaremos con el proveedor y buscaremos una solución, incluidos reembolsos parciales cuando corresponda.';

  @override
  String get faqQ5 => '¿Están verificados los proveedores?';

  @override
  String get faqA5 =>
      'Los proveedores con una insignia de verificado han tenido sus credenciales de negocio y su portafolio revisados por nuestro equipo. También usamos las reseñas de los clientes para mantener los estándares de calidad.';

  @override
  String get faqQ6 => '¿Cómo dejo una reseña?';

  @override
  String get faqA6 =>
      'Una vez que tu evento se marque como completado, recibirás un aviso para dejar una reseña. También puedes ir a Reservas → Pasadas → la reserva completada → Dejar reseña.';

  @override
  String get sadToSeeYouGo => 'Lamentamos que te vayas';

  @override
  String get letUsKnow => 'Cuéntanos qué salió mal';

  @override
  String get deleteReason1 => 'Ya no uso la plataforma/servicio';

  @override
  String get deleteReason2 => 'Encontré una mejor alternativa';

  @override
  String get deleteReason3 => 'Preocupaciones de privacidad';

  @override
  String get deleteReason4 => 'Demasiados correos/notificaciones';

  @override
  String get deleteReason5 => 'Dificultad para navegar por la plataforma';

  @override
  String get deleteReason6 => 'Motivos personales';

  @override
  String get deleteReason7 => 'Otro no listado arriba';

  @override
  String get tellUsMore => 'Cuéntanos más...';

  @override
  String get deleteAccountBtn => 'Eliminar cuenta';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get deleteAccountWarning =>
      'al eliminar tu cuenta perderás lo siguiente';

  @override
  String get deleteLoss1 => '• Acceso a tus eventos activos';

  @override
  String get deleteLoss2 =>
      '• Acceso a los registros y credenciales de tu cuenta';

  @override
  String get deleteLoss3 => '• Datos de acceso';

  @override
  String get deleteLoss4 =>
      '• Todos los contactos de proveedores por mensaje y llamada';

  @override
  String get connecting => 'Conectando…';

  @override
  String get ringing => 'Llamando…';

  @override
  String get wrongAppTitle => 'App incorrecta';

  @override
  String get wrongAppMessage =>
      'Esta cuenta está registrada como proveedor. Usa la app Planovar Vendor para iniciar sesión.';

  @override
  String get ok => 'Aceptar';

  @override
  String get orderFeeBreakdown => 'Desglose de tarifas';

  @override
  String get orderSubtotal => 'Subtotal';

  @override
  String get orderDeliveryFee => 'Gastos de envío';

  @override
  String get orderDeposit => 'Depósito reembolsable';

  @override
  String get orderTotal => 'Total';

  @override
  String get orderPaymentHistory => 'Historial de pagos';

  @override
  String get orderPaid => 'Pagado';

  @override
  String get orderDue => 'Pendiente';

  @override
  String get orderPending => 'Pendiente';
}
