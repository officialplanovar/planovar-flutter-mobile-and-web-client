# Planovar Client App

The client-facing Flutter application for **Planovar** — used by event planners to discover vendors, request bookings, send messages, make payments, and leave reviews.

Runs on **iOS, Android, and browser (web)** from a single codebase.

---

## Quick start

```bash
# Install dependencies
flutter pub get

# Run on a connected device or simulator
flutter run

# Run in browser (dev server on port 3001)
flutter run -d web-server --web-port 3001

# Or from the monorepo root
make client-get
make client-web
make client-ios
make client-android
```

> The Planovar API must be running at `http://localhost:3000`.
> Start it with `make api-dev` from the monorepo root.

---

## Documentation

| Document | Description |
|---|---|
| [Architecture](./docs/architecture.md) | App structure, BLoC pattern, platform targets |
| [Development](./docs/development.md) | Setup, running on each platform, adding features |

---

## Project structure

```
lib/
├── core/
│   ├── api/            # Dio HTTP client, interceptors, API service base
│   ├── router/         # go_router route definitions and guards
│   ├── theme/          # Colours, typography, spacing tokens
│   ├── utils/          # Formatters, validators, extensions
│   └── constants/      # API URLs, app-wide constants
├── features/
│   ├── auth/
│   │   ├── bloc/       # AuthBloc, AuthEvent, AuthState
│   │   ├── data/       # AuthRepository, AuthRemoteDataSource
│   │   └── ui/         # Login, register, OTP verify screens
│   ├── home/
│   │   ├── bloc/
│   │   └── ui/         # Home feed, category browsing
│   ├── search/         # Vendor and listing discovery
│   ├── listings/       # Listing detail, packages, media gallery
│   ├── bookings/       # Booking request, status tracking
│   ├── quotes/         # Received quotes, accept/reject flow
│   ├── messaging/      # Vendor conversations
│   ├── payments/       # Paystack checkout, payment history
│   ├── reviews/        # Leave reviews after completed bookings
│   ├── notifications/
│   │   ├── bloc/
│   │   └── ui/
│   └── profile/        # Client profile and account settings
└── shared/
    ├── widgets/        # Reusable UI components
    └── models/         # Shared data models and DTOs
```

---

## Tech stack

| Layer | Package |
|---|---|
| State management | `flutter_bloc` + `bloc` |
| HTTP client | `dio` |
| Navigation | `go_router` |
| Secure storage | `flutter_secure_storage` |
| Persistent storage | `shared_preferences` |
| Image loading | `cached_network_image` |
| Internationalisation | `intl` |
| Value equality | `equatable` |

---

## Platform targets

| Platform | Command |
|---|---|
| iOS simulator | `flutter run -d ios` |
| Android emulator | `flutter run -d android` |
| Web browser | `flutter run -d web-server --web-port 3001` |
| All connected devices | `flutter run -d all` |
