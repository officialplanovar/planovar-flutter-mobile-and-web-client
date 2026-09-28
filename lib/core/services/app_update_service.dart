import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:in_app_update/in_app_update.dart';

/// Google Play in-app update checker.
///
/// On Android, asks Play whether a newer version is available on the track the
/// app was installed from (production or a testing track) and runs the update
/// flow — a background download + install prompt (flexible), or a full-screen
/// blocking update (immediate) when that's the only option.
///
/// No-op on iOS/web, and safely ignored when the app wasn't installed from Play
/// (e.g. a locally sideloaded debug build), so it never disrupts normal use.
class AppUpdateService {
  static bool _checked = false;

  /// Checks once per app launch. Fire-and-forget from a screen's initState.
  static Future<void> checkForUpdate() async {
    if (_checked) return;
    _checked = true;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      if (info.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      } else if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (_) {
      // Not installed from Play / no Play services / user dismissed — ignore.
    }
  }
}
