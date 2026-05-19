# Architecture

## Role in the Planovar system

The client app is one of four surfaces that talk to the shared `planovar-api` backend:

```
┌───────────────────────────────────────────────────────────┐
│                     Client surfaces                       │
│                                                           │
│  Flutter Client   Flutter Vendor   Next.js Admin          │
│  (iOS/Android/    (iOS/Android/    (Web only)             │
│   Web)  ◄──── you are here         )                      │
└──────────────────────────┬────────────────────────────────┘
                           │ HTTPS + WebSocket
                           ▼
                   ┌───────────────┐
                   │ Planovar API  │
                   │ (NestJS :3000)│
                   └───────────────┘
```

All user accounts with `role = CLIENT` use this app. It is entirely separate from the vendor app — different codebase, different App Store listing, different UX focus. The client app is discovery and booking focused; the vendor app is supply and fulfilment focused.

---

## Platform strategy

One Flutter codebase compiles to three targets:

| Target | Distribution | Notes |
|---|---|---|
| **iOS** | App Store | Native performance, push via APNs |
| **Android** | Google Play | Native performance, push via FCM |
| **Web** | Browser (URL) | Clients who prefer planning on desktop |

Platform-specific code (camera, file picker, push registration) is isolated behind abstraction layers so the business logic and UI remain fully shared.

---

## State management — BLoC pattern

The app uses `flutter_bloc` throughout. Every feature follows the same three-layer structure:

```
feature/
├── bloc/
│   ├── feature_bloc.dart       # Business logic, calls repository
│   ├── feature_event.dart      # User actions (SearchVendors, RequestBooking…)
│   └── feature_state.dart      # UI states (Initial, Loading, Loaded, Error)
├── data/
│   ├── feature_repository.dart            # Abstracts data source
│   └── feature_remote_data_source.dart    # Dio API calls
└── ui/
    ├── feature_screen.dart      # BlocBuilder / BlocListener wrappers
    └── widgets/                 # Screen-specific widgets
```

**Data flow:**

```
UI Event (e.g. user taps "Search")
  │
  ▼
BLoC (processes event, calls repository)
  │
  ▼
Repository (decides local cache vs remote API)
  │
  ▼
RemoteDataSource (Dio → Planovar API)
  │
  ▼
BLoC emits new State (e.g. SearchLoaded with results)
  │
  ▼
UI rebuilds via BlocBuilder
```

---

## Navigation — go_router

All routes are defined in `lib/core/router/`. The router uses `redirect` guards to enforce authentication state:

- Unauthenticated users → redirected to `/login`
- Authenticated users → land on `/home`

```
/
├── /login
├── /register
├── /verify-otp
└── /home
    ├── /search
    │   └── /search?query=&category=&location=
    ├── /vendors/:vendorId
    ├── /listings/:listingId
    ├── /bookings
    │   ├── /bookings/new?listingId=
    │   └── /bookings/:bookingId
    ├── /quotes/:quoteId
    ├── /messages
    │   └── /messages/:conversationId
    ├── /payments
    │   └── /payments/:transactionId
    ├── /reviews/new?bookingId=
    └── /profile
```

---

## HTTP client — Dio

The Dio instance lives in `lib/core/api/`. It is configured with:

- `BaseOptions.baseUrl` pointing to the API (`http://localhost:3000` in dev)
- A **cookie interceptor** that attaches the Better Auth session cookie to every request
- A **401 interceptor** that routes to `/login` when the session expires
- A **logging interceptor** (debug builds only) that prints request/response detail

---

## Authentication

The client app registers and signs in via the Planovar API (`/api/auth/*`), handled by Better Auth. The app always sends `role: "CLIENT"` during registration — the role is implicit from which app the user is in, never a UI choice.

**Auth flow:**

```
1. User enters name, email, password
2. App calls POST /api/auth/sign-up/email  { role: "CLIENT", ... }
3. API sends OTP to email
4. User enters OTP → POST /api/auth/email-otp/verify-email
5. User signs in → POST /api/auth/sign-in/email
6. Session cookie stored securely via flutter_secure_storage
7. All subsequent API calls include the cookie
```

For Google sign-in, the native `google_sign_in` package handles the OAuth flow and returns an ID token, which is passed to `POST /api/auth/sign-in/id-token`.

---

## Client-specific features

These features exist in the client app but not the vendor app:

| Feature | Description |
|---|---|
| **Vendor discovery** | Browse and filter vendors by category, location, price range, rating |
| **Search** | Full-text and geo-aware search powered by Typesense via the API |
| **Listing detail** | View listing media gallery, packages, pricing, vendor profile |
| **Booking request** | Submit an event date, location, and requirements to a vendor |
| **Quote review** | View and accept or reject quotes sent by the vendor |
| **Paystack checkout** | In-app payment flow for confirmed bookings |
| **Payment history** | View past transactions and receipts |
| **Review submission** | Leave a star rating and written review after a completed booking |
| **Saved vendors** | Bookmark vendors for later (planned feature) |

---

## Folder depth rule

Keep feature folders flat. If a widget is used in only one screen it lives in `features/<name>/ui/widgets/`. If it is used across two or more features it moves to `shared/widgets/`.

---

## Web-specific considerations

When running as a Flutter web app:

- `flutter_secure_storage` falls back to encrypted `localStorage` on web — acceptable for session tokens
- File attachments in messaging use `file_picker` (web-compatible) rather than the camera
- Deep links use standard URL paths — go_router handles these natively on web
- The Paystack checkout on web can use the Paystack Popup JS SDK embedded via a `HtmlElementView`, or redirect to the Paystack hosted page
- The web build is served as a static bundle; all data comes from the API
