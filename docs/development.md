# Development guide

## Prerequisites

| Tool | Version | Install |
|---|---|---|
| Flutter | 3.x | [flutter.dev/install](https://flutter.dev/docs/get-started/install) |
| Dart | 3.x | Bundled with Flutter |
| Xcode | 15+ | Mac App Store (iOS builds) |
| Android Studio | latest | [developer.android.com](https://developer.android.com/studio) |
| CocoaPods | latest | `sudo gem install cocoapods` (iOS) |
| Chrome | any | Required for web target |

Verify your setup:

```bash
flutter doctor
```

All items should show a green tick. Fix any reported issues before continuing.

---

## First-time setup

```bash
cd planovar-flutter-mobile-and-web-client
flutter pub get
```

For iOS, install native dependencies:

```bash
cd ios && pod install && cd ..
```

---

## Running the app

### In the browser (fastest for UI development)

```bash
flutter run -d web-server --web-port 3001
# or from the monorepo root:
make client-web
```

Opens at `http://localhost:3001`. Hot reload works — press `r` in the terminal.

> Port `3001` is used for the client app. The vendor app uses `3002` and the admin console uses `3003`.

### On iOS simulator

```bash
flutter run -d ios
# or:
make client-ios
```

### On Android emulator

```bash
flutter run -d android
# or:
make client-android
```

Start an AVD in Android Studio first if no device appears.

### On a physical device

```bash
flutter devices          # confirm your device is listed
flutter run -d <device-id>
```

---

## Hot reload vs hot restart

| Command | Key | Effect |
|---|---|---|
| Hot reload | `r` | Injects updated code, preserves app state |
| Hot restart | `R` | Full restart, clears state |
| Quit | `q` | Stops the runner |

Use hot reload for UI tweaks. Use hot restart after changing BLoC logic, route guards, or app initialisation.

---

## Environment / API configuration

The API base URL is defined in `lib/core/constants/app_constants.dart` (to be created):

```dart
class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
```

Pass a different URL at build time without changing source code:

```bash
# Development (uses defaultValue)
flutter run

# Staging
flutter run --dart-define=API_BASE_URL=https://api.staging.planovar.ng

# Production
flutter build apk --dart-define=API_BASE_URL=https://api.planovar.ng
```

---

## Adding a new feature

1. **Create the feature folder:**
   ```
   lib/features/<name>/
   ├── bloc/
   │   ├── <name>_bloc.dart
   │   ├── <name>_event.dart
   │   └── <name>_state.dart
   ├── data/
   │   ├── <name>_repository.dart
   │   └── <name>_remote_data_source.dart
   └── ui/
       ├── <name>_screen.dart
       └── widgets/
   ```

2. **Define events and states first** — model what the user can do and what the UI needs to show before writing any logic.

3. **Write the repository** — calls the remote data source, returns typed data or a failure.

4. **Write the BLoC** — maps events to state transitions, calls the repository.

5. **Build the UI** — wrap screens in `BlocProvider`, use `BlocBuilder` for display and `BlocListener` for side effects (navigation, snackbars).

6. **Register the route** in `lib/core/router/router.dart`.

7. **Add navigation** from wherever the feature is entered (bottom nav, button, deep link).

---

## BLoC boilerplate example

```dart
// booking_event.dart
abstract class BookingEvent extends Equatable {
  const BookingEvent();
}

class LoadBookings extends BookingEvent {
  const LoadBookings();
  @override List<Object> get props => [];
}

class RequestBooking extends BookingEvent {
  final String listingId;
  final DateTime eventDate;
  final String requirements;
  const RequestBooking({
    required this.listingId,
    required this.eventDate,
    required this.requirements,
  });
  @override List<Object> get props => [listingId, eventDate, requirements];
}

// booking_state.dart
abstract class BookingState extends Equatable {
  const BookingState();
}

class BookingInitial extends BookingState {
  @override List<Object> get props => [];
}

class BookingLoading extends BookingState {
  @override List<Object> get props => [];
}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;
  const BookingsLoaded(this.bookings);
  @override List<Object> get props => [bookings];
}

class BookingRequested extends BookingState {
  final Booking booking;
  const BookingRequested(this.booking);
  @override List<Object> get props => [booking];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override List<Object> get props => [message];
}

// booking_bloc.dart
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc({required this.repository}) : super(const BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<RequestBooking>(_onRequestBooking);
  }

  Future<void> _onLoadBookings(
    LoadBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final bookings = await repository.getMyBookings();
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onRequestBooking(
    RequestBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final booking = await repository.createBooking(
        listingId: event.listingId,
        eventDate: event.eventDate,
        requirements: event.requirements,
      );
      emit(BookingRequested(booking));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
```

---

## Building for release

### Android APK

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make client-build-apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS archive (for App Store)

```bash
flutter build ios --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make client-build-ios
```

Then open Xcode → Product → Archive to submit to App Store Connect.

### Web bundle

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.planovar.ng
# or:
make client-build-web
```

Output: `build/web/` — deploy as a static site (Cloudflare Pages, S3, Netlify, etc.).

---

## Code quality

```bash
# Analyse for warnings and errors
flutter analyze

# Run widget and unit tests
flutter test

# Format all Dart files
dart format lib/
```

Fix all `flutter analyze` warnings before opening a PR. The rules are defined in `analysis_options.yaml`.

---

## Troubleshooting

**`flutter pub get` fails with dependency conflicts**
Run `flutter pub upgrade` to resolve to the latest compatible versions. Check `pubspec.lock` to identify the conflicting package.

**iOS build fails with CocoaPods error**
```bash
cd ios
pod deintegrate
pod install
```

**Web app shows blank screen after `flutter run -d web-server`**
Open browser DevTools → Console for Dart exceptions. Ensure the build completed cleanly. Try a hot restart (`R`) first.

**API calls fail with CORS errors in the browser**
The API's CORS config in `main.ts` must include `http://localhost:3001` in the allowed origins list, and `http://localhost:3001` must also be in Better Auth's `trustedOrigins`. Restart the API after any change.

**`INVALID_ORIGIN` response from the API**
The HTTP request is missing an `Origin` header. In the Flutter web app this is sent automatically by the browser. If you're testing via a REST client (Postman, `.http` file), add `Origin: http://localhost:3001` manually.

**App crashes on startup after adding a new package**
```bash
flutter clean
flutter pub get
flutter run
```

**Hot reload not reflecting BLoC changes**
BLoC initialisation runs once. Changes to event handlers or initial state require a full hot restart (`R`).
