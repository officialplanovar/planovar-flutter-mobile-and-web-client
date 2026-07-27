import 'package:app_links/app_links.dart';

/// Captures the bearer token the OAuth token relay hands back to the native app
/// via the `planovar://auth?planovar_token=...` deep link.
class DeepLinkAuth {
  final _appLinks = AppLinks();

  /// Cold start: token if the app was launched from the auth deep link.
  Future<String?> initialToken() async {
    try {
      return _tokenFrom(await _appLinks.getInitialLink());
    } catch (_) {
      return null;
    }
  }

  /// Warm links: fires [onToken] whenever an auth deep link arrives while the
  /// app is already running.
  void listen(void Function(String token) onToken) {
    _appLinks.uriLinkStream.listen(
      (uri) {
        final t = _tokenFrom(uri);
        if (t != null) onToken(t);
      },
      onError: (_) {},
    );
  }

  String? _tokenFrom(Uri? uri) {
    final t = uri?.queryParameters['planovar_token'];
    return (t != null && t.isNotEmpty) ? t : null;
  }
}
