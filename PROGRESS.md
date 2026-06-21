# planovar-client (Flutter) — Progress Log

Living log. Newest entries on top. Full plan: repo-root `PLANOVAR_BUILD_PLAN.md`.

## Status snapshot — ✅ PHASE 4 COMPLETE (chat + notifications + voice)

### 2026-06-16 — Phase 4c: LiveKit voice wired ✅
- New `core/services/call_service.dart` (mic permission → `POST /calls/token` → `Room().connect(url,
  token)` → mic on) + `features/calls/call_screen.dart` (ringing→connected status, timer, mute, end →
  `room.disconnect()`); `EventsListener<RoomEvent>` drives participant-connected/disconnected/room-
  disconnected UI.
- Chat thread: call button → `chat_socket.inviteCall` + opens CallScreen; `onCallIncoming` auto-opens
  CallScreen on the peer. Signaling relayed by the gateway (`call:invite`→`call:incoming`); media via
  LiveKit. Mic perms added (iOS NSMicrophoneUsageDescription + Android RECORD_AUDIO/INTERNET).
- Server-side **Gold-gated**: `POST /calls/token` 403s non-Gold vendors (verified BASIC→403, GOLD→token).
- Limitations: needs real LIVEKIT_URL/API_KEY/API_SECRET + two devices for a live call; incoming call
  auto-joins (no accept/decline UI yet). `flutter analyze` → 0 errors.

### 2026-06-16 — Phase 4b: notifications wired ✅
- New `core/services/notification_service.dart` (GET /notifications, unreadCount, mark-read, mark-all);
  notifications screen swapped off mock → live data.

### 2026-06-16 — Phase 4a: client real-time chat wired ✅
- Added `socket_io_client`; new `core/services/chat_socket.dart` (Socket.io `/chat`, bearer via
  `auth.token`) + `core/services/messaging_service.dart` (REST: conversations/messages/start, maps the
  participant-based API conv → vendor-centric ConversationModel via clientId).
- `messages_screen` + `chat_screen` swapped off MockMessagingService → real service; chat thread loads
  history (REST) and sends/receives **live over the socket** (server persists + broadcasts; dedupe by id);
  `_currentUserId` now from AuthBloc.
- Backend: gateway now accepts the bearer token via `handshake.auth.token` (works on web + mobile).
- Verified REST contract on :3011 — start conversation → send → list (last message) → thread → vendor
  sees it. `flutter analyze` (messaging) → 0 errors/0 warnings.
- ⏭️ Remaining Phase 4: vendor app chat (its screens are MockData-coupled — needs the same service swap),
  notifications screens → GET /notifications, LiveKit voice (Gold-gated). Socket live-path needs a
  two-app runtime test.

## Status snapshot — ✅ PHASE 3 COMPLETE

### 2026-06-16 — Kill dummy data on home + profile; fix nav overlap ✅
- Root cause of "still dummy after login": screens fell back to `MockData` when live lists were
  **empty** (fresh user). Removed mock fallbacks — empty now shows empty/empty-state, never mock.
- **Home**: greeting name + avatar from the real AuthBloc user (was MockData.currentUser); categories,
  recommended vendors, upcoming events all live; **products** now wired (was always mock) — sourced
  from the top recommended vendors' active listings (real Prisma shape, avoids Typesense mapping).
- **Profile**: header name/email/avatar from real user; dropped hardcoded "Lagos, Nigeria"; stats
  Events/Orders are live counts (EventService/BookingService); Saved via favourites (stub → 0 for now);
  "Rating"→"Reviews" shows '—' (no client review-count source yet).
- **Bottom-nav overlap**: profile trailing spacer now `110 + safe-area` so the Sign-out button clears
  the shell nav bar.
- `flutter analyze` (home+profile) → 0 errors / 0 warnings.
- Remaining minor dummy: home header location still hardcoded ("Abuja, Nig"); favourites/Saved count
  + client review count need real wiring.

### 2026-06-11 — Phase 3 tail: reviews, events, explore, disclaimer ✅
- **Client review submission wired**: new `core/services/review_service.dart`; `LeaveReviewScreen`
  takes optional `bookingId` and POSTs `/reviews` (star-tap validation, loading state, API errors
  surfaced); routed with bookingId extra. Booking detail now shows **⭐ Leave a Review** when
  status == completed.
- **Dead transactional CTA removed**: booking detail's "Proceed to Payment" replaced with the
  **off-platform "at your own risk" disclaimer** (MoM #6) on confirmed bookings.
- **Events workspace wired**: new `core/services/event_service.dart` (maps API `name`/Json
  location/`budgetMin` Decimal strings); create-event wizard **persists the event** on reaching
  step 4 (`POST /events` from accumulated wizard data); My Events lists live events (mock fallback).
- **Explore**: category grid now live from `/categories` (search filter unchanged).
- `flutter analyze` → 0 errors.

## (previous) Status snapshot — Phase 3 core loop wired ✅
- **Wired to the real API:** auth (sign-in/up/OTP via bearer token) + full onboarding chain
  (phone → location prefs → password → category prefs), home feed (categories/vendors/upcoming
  bookings), vendor profile, listing detail, bookings (list/create/cancel/detail), quotes
  (view/accept/reject — accept = "Accept & Book").
- **Still mock:** explore screen browse, products section on home feed, events workspace, messaging
  (Phase 4), notifications, payments screens (legacy — off-platform model), i18n pending.
- `flutter analyze` → 0 errors. API base: `--dart-define=API_BASE_URL` (default `http://localhost:3000`).

## Log

### 2026-06-11 — Phase 3: client core loop wired to API ✅
- **Foundation:** `core/api/` (token_store [client-keyed], api_client, api_utils — same pattern as
  the vendor app).
- **Auth:** `features/auth/data/` remote data source + repository; AuthBloc swapped off the mock
  (screens already dispatched to the bloc, unlike the vendor app).
  Signup-order quirk solved: the design collects the password AFTER OTP, so `signUp` uses a strong
  generated temp password and the create-password screen swaps it via `/api/auth/change-password`
  (recovery path = forgot-password OTP reset).
- **Onboarding chain wired:** phone → `PATCH /users/me` (dial code + number); location prefs →
  real countries/cities (`/locations/...`, IDs persisted via PATCH); category prefs → real
  `/categories` grid → `POST /users/me/preferences`. CityModel fixed for Decimal-string lat/lng.
- **Real services (mock-identical shapes, drop-in):** `core/services/` —
  `reference_data_service` (LocationService/CategoryService), `booking_service` (statuses
  normalized to the UI's lowercase; eventLocation Json→address; Decimal strings parsed; partial
  nested vendor/listing synthesized), `quote_service` (incl. `getQuoteForBooking` via the booking's
  embedded quotes), `listing_service`, `vendor_service` (browse via `/search/vendors` Typesense
  docs; detail via `/vendors/:id`).
- **Screens swapped to real services:** bookings list, booking detail, new booking (creates a real
  inquiry), quote detail (accept/reject), listing detail + vendor profile (async load + loader +
  mock fallback for demo ids), home feed (live categories/vendors/bookings + pull-to-refresh).
- Verified Typesense live-indexed (vendors=4, listings=3 from earlier backend E2E).

### 2026-06-09 — Phase 0 touch-points
- No code changes this phase. Noted: API base URL must point at port **3000**.
- Design audit confirmed scope: discovery + AI matching, Event Workspace, vendor/listing detail,
  **payment-free inquiry/appointment** (drop cart/checkout/pay), chat, receive quotes → accept,
  reviews (gated to completed booking), report/flag (not refund disputes), "at your own risk" disclaimers,
  i18n EN/FR/ES. Client designs still show cart→checkout→payment — dropped under subscription-only mode.

## Remaining (Phase 3 tail / later phases)
- Explore screen + home products section → live search; events workspace; client review submission
  screen; messaging (Phase 4); i18n EN/FR/ES; remove/disable legacy checkout-payment screens.
