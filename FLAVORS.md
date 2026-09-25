# Flavors & release builds — Planovar Client

Three build environments, installable side by side on one device:

| Flavor  | Android application ID                  | iOS bundle ID                       | App name              | API (`config/*.json`)          |
|---------|-----------------------------------------|-------------------------------------|-----------------------|--------------------------------|
| dev     | `com.planovar.planovar_client.dev`      | `com.planovar.planovarClient.dev`     | Planovar Client [DEV]     | `config/dev.json`     |
| staging | `com.planovar.planovar_client.staging`  | `com.planovar.planovarClient.staging` | Planovar Client [STAGING] | `config/staging.json` |
| prod    | `com.planovar.planovar_client`          | `com.planovar.planovarClient`         | Planovar Client         | `config/prod.json`    |

Per-environment config (API URL, Crisp ID, `ENV`, `OAUTH_SCHEME`) lives in **`config/<env>.json`** and is injected at build time via `--dart-define-from-file`. Read it in Dart with `AppConstants.environment` / `AppConstants.apiBaseUrl`, or `String.fromEnvironment('<KEY>')`.

**Google OAuth deep-link scheme** — each flavor uses its own custom URL scheme so side-by-side installs don't clash on the sign-in callback: `planovar` (prod), `planovardev`, `planovarstaging`. This is wired in four places that must stay in sync: `config/<env>.json` (`OAUTH_SCHEME`), `android/app/build.gradle.kts` (`manifestPlaceholders["oauthScheme"]`), `ios/Config/shared-<env>.xcconfig` (`OAUTH_SCHEME`, consumed by `Info.plist`), and the API's `MOBILE_SCHEMES` allowlist (`src/auth/oauth-relay.controller.ts`). Changing the API allowlist needs a **redeploy of that backend environment** before dev/staging sign-in works there.

> ⚠️ The API URLs in `config/*.json` are placeholders — set your real dev / staging / prod API hosts before shipping.

## Build commands (Makefile)

```bash
make aab-prod        # Android App Bundle for the Play Store (auto-bumps build number)
make aab-staging
make apk-dev         # APK for sideloading
make ipa-prod        # iOS IPA (after the one-time Xcode setup below)
make run-dev DEVICE="iPhone 15"   # run a flavor on a device
make android-local   # local dev loop against a localhost API
```

Every `aab-*` / `apk-*` / `ipa-*` build increments the `+N` build number in `pubspec.yaml`. Set a new version name with `make aab-prod VERSION=1.3.0`.

## Android release signing

`make aab-*` signs with the release keystore if `android/key.properties` exists, otherwise it falls back to the **debug** key (not shippable). To set up real signing, copy `android/key.properties.example` → `android/key.properties` (git-ignored) and follow the keystore steps in it.

## iOS — one-time Xcode setup (~5 min)

The xcconfig files are already created in `ios/Config/`. Wire them up once in Xcode:

1. `open ios/Runner.xcworkspace`.
2. **Build configurations** — select the **Runner project** → *Info* tab → *Configurations*. You have `Debug`, `Release`, `Profile`. Duplicate each so you end up with nine:
   `Debug-dev`, `Debug-staging`, `Debug-prod`, `Release-dev`, `Release-staging`, `Release-prod`, `Profile-dev`, `Profile-staging`, `Profile-prod`.
   (You can delete the original three afterwards, or leave them.)
3. **Point each config at its xcconfig** — still in *Configurations*, expand each config and set the **Runner** target's "Based on Configuration File" to the matching file in `ios/Config/` (e.g. `Release-prod` → `Release-prod.xcconfig`). Each xcconfig defines `BUNDLE_ID_SUFFIX`, `APP_DISPLAY_NAME`, and `FLUTTER_ENV`.
4. **Bundle ID** — select the **Runner target → Build Settings → Packaging → Product Bundle Identifier** and set it (for *All Configurations*) to `com.planovar.planovarClient$(BUNDLE_ID_SUFFIX)`. The suffix comes from each config's xcconfig, so dev→`.dev`, staging→`.staging`, prod→(none). (This one edit is needed because a target-level build setting overrides the xcconfig.)
5. **Schemes** — *Product → Scheme → Manage Schemes*. Duplicate `Runner` into three schemes named exactly **`dev`**, **`staging`**, **`prod`** (names must match the `--flavor` value). Mark them *Shared*. For each scheme (*Edit Scheme*), set the configuration per action:
   - `dev` → Run/Test/Analyze = `Debug-dev`, Profile = `Profile-dev`, Archive = `Release-dev`.
   - `staging` → the `*-staging` configs.
   - `prod` → the `*-prod` configs.
6. Verify: `flutter build ipa --flavor prod --dart-define-from-file=config/prod.json` (or `make ipa-prod`).

`Info.plist` already uses `$(APP_DISPLAY_NAME)` for the display name, so each flavor shows its own name.

> Side-by-side installs need the dev/staging bundle IDs registered wherever they matter — Apple Developer portal, Firebase, Google OAuth redirect URIs, and Paystack — or those integrations will only work for the IDs you've registered.
