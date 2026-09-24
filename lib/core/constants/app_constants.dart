class AppConstants {
  /// Active build environment: 'dev' | 'staging' | 'prod'.
  /// Injected at build time via `--dart-define-from-file=config/<env>.json`
  /// (see the app's Makefile / FLAVORS.md). Defaults to 'dev' for safety when
  /// no config is supplied.
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static bool get isProd => environment == 'prod';
  static bool get isStaging => environment == 'staging';
  static bool get isDev => environment == 'dev';

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Custom URL scheme for the Google OAuth token-relay deep link
  /// (`<scheme>://auth?planovar_token=...`). Per-flavor so side-by-side installs
  /// don't collide; must match the Android manifestPlaceholder, the iOS
  /// CFBundleURLSchemes, and the API's MOBILE_SCHEMES allowlist.
  static const String oauthScheme = String.fromEnvironment(
    'OAUTH_SCHEME',
    defaultValue: 'planovar',
  );
}
