import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../api/api_client.dart';

// Web-safe platform detection (no `dart:io`, which breaks `flutter build web`).
bool _isIOS() => defaultTargetPlatform == TargetPlatform.iOS;
bool _isMobile() =>
    defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Background/terminated-state message handler.
///
/// Must be a top-level (or static) function annotated with `vm:entry-point` so
/// it survives tree-shaking and can run in its own isolate. For notification
/// messages the OS draws the system-tray notification itself; this hook only
/// exists for any data-only side effects, so it stays intentionally minimal.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: notification payloads are rendered by the OS. If data-only pushes
  // ever need background work (e.g. badge sync), initialise Firebase and do it
  // here.
}

/// Firebase Cloud Messaging integration for the mobile builds.
///
/// Responsibilities:
///  * request notification permission (iOS + Android 13+),
///  * fetch the FCM registration token and register it with the backend
///    (`POST /users/me/device-token`), re-registering on refresh,
///  * route foreground / tapped notifications through optional callbacks,
///  * deregister the token on sign-out (`DELETE /users/me/device-token/:token`).
///
/// This is a scaffold that **activates automatically** once the Firebase config
/// files exist (Android `google-services.json`, iOS `GoogleService-Info.plist`)
/// and `Firebase.initializeApp()` has succeeded in `main()`. Until then every
/// method is a safe no-op, so the app — including `flutter build web` — keeps
/// building and running. Web push is intentionally out of scope for now (it
/// needs a service worker + VAPID key); only iOS/Android are handled.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final ApiClient _api = ApiClient();

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  bool _listenersStarted = false;
  String? _lastToken;

  /// Called when a notification is received while the app is foregrounded.
  /// The OS does **not** show a banner in this case, so the app should surface
  /// it in-app (e.g. a snackbar or refreshing a list). Wire from the UI layer.
  void Function(RemoteMessage message)? onForegroundMessage;

  /// Called when the user taps a notification that opened/resumed the app
  /// (both warm resume and cold start). Use `message.data` to deep-link.
  void Function(RemoteMessage message)? onNotificationTap;

  /// True only on iOS/Android once Firebase has been initialised. Guards every
  /// store/messaging call so web & desktop and un-configured builds no-op.
  bool get _supported => !kIsWeb && _isMobile() && Firebase.apps.isNotEmpty;

  /// One-time setup: registers the background handler and starts the foreground
  /// / tap listeners. Safe to call from `main()`; no-op if unsupported.
  Future<void> init() async {
    if (!_supported) return;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // Let iOS show heads-up notifications while the app is foregrounded.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _startListeners();
  }

  /// Requests permission, obtains the FCM token and registers it with the
  /// backend. Call right after the user becomes authenticated. No-op if
  /// unsupported or if permission is denied.
  Future<void> registerForUser() async {
    if (!_supported) return;
    final messaging = FirebaseMessaging.instance;
    try {
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final token = await messaging.getToken();
      if (token != null && token.isNotEmpty) await _sendToken(token);

      _tokenRefreshSub ??= messaging.onTokenRefresh.listen(_sendToken);
      _startListeners();
    } catch (_) {
      // APNs token not yet available / no Play services / offline — ignore;
      // a later launch or token refresh will retry.
    }
  }

  /// Deregisters the current token (server + locally). Call on sign-out,
  /// **before** the bearer token is cleared, so the DELETE is authenticated.
  Future<void> unregister() async {
    if (!_supported) return;
    final messaging = FirebaseMessaging.instance;
    try {
      final token = _lastToken ?? await messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _api.dio.delete('/users/me/device-token/$token');
      }
    } catch (_) {
      // Best-effort — still drop the token locally below.
    }
    try {
      await messaging.deleteToken();
    } catch (_) {}
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    _lastToken = null;
  }

  Future<void> _sendToken(String token) async {
    if (token == _lastToken) return;
    final platform = _isIOS() ? 'IOS' : 'ANDROID';
    try {
      await _api.dio.post(
        '/users/me/device-token',
        data: {'token': token, 'platform': platform},
      );
      _lastToken = token;
    } catch (_) {
      // Network/auth hiccup — onTokenRefresh or the next launch will retry.
    }
  }

  void _startListeners() {
    if (_listenersStarted) return;
    _listenersStarted = true;

    _foregroundSub = FirebaseMessaging.onMessage.listen((message) {
      onForegroundMessage?.call(message);
    });

    _openedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTap?.call(message);
    });

    // Cold start from a tapped notification (app was terminated).
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) onNotificationTap?.call(message);
    });
  }

  /// Tears down listeners (rarely needed; the singleton usually lives for the
  /// whole app session).
  Future<void> dispose() async {
    await _foregroundSub?.cancel();
    await _openedSub?.cancel();
    await _tokenRefreshSub?.cancel();
    _foregroundSub = null;
    _openedSub = null;
    _tokenRefreshSub = null;
    _listenersStarted = false;
  }
}
