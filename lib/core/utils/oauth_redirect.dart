// Removes the one-time OAuth token from the browser URL after it's captured,
// so the session token isn't left in the address bar / history. No-op off web.
export 'oauth_redirect_stub.dart'
    if (dart.library.html) 'oauth_redirect_web.dart';
