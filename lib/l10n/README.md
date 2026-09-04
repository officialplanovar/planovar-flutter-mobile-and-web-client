# Localization (i18n)

The app uses Flutter's built-in `gen-l10n`. Strings live in ARB files here and
are code-generated into `AppLocalizations`.

- Template / source of truth: `app_en.arb`
- Translations: `app_fr.arb` (French). Add `app_<code>.arb` for more locales and
  register the code in `lib/core/locale/locale_cubit.dart` (`LocaleCubit.supported`).
- Active runtime language is driven by `LocaleCubit` → `MaterialApp.locale`
  (see `lib/main.dart`). Users switch it in **Profile → Language**.

## Adding / localizing a string

1. Add the key to `app_en.arb` (and the same key to every other `app_*.arb`).
2. Run: `flutter gen-l10n` (also runs on `flutter pub get`/build).
3. In the widget: `final t = AppLocalizations.of(context);` then use `t.<key>`.
   - `t` is non-nullable here (`nullable-getter: false` in `l10n.yaml`).
   - You cannot use `t.<key>` inside a `const` — drop `const` on that widget.
   - For labels held in a `const` list (e.g. nav tabs), resolve by index at
     render time; see `_navLabel` in `lib/core/router/router.dart`.

## Migration status

Done: i18n foundation, live EN/FR switcher, Login screen, bottom-nav + side-rail
tab labels. Remaining screens still hold literal English strings and should be
migrated the same way, one surface at a time, expanding the ARBs as you go.
Next highest-visibility surfaces: Register, onboarding, Profile, home feed.
