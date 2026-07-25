import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/event_service.dart';
import '../../../core/state/overlay_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final _pageController = PageController();
  int _tabIndex = 0;
  int _subTabIndex = 0; // 0=Upcoming, 1=Past, 2=Cancelled

  /// Live events from the API (mock fallback while loading / on error).
  List<EventModel> _liveEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    // Refetch whenever events change (created / vendor added elsewhere) so the
    // list is fresh when this tab regains focus.
    eventsChanged.addListener(_loadEvents);
  }

  Future<void> _loadEvents() async {
    try {
      final events = await EventService().getEvents();
      if (mounted) setState(() => _liveEvents = events);
    } catch (_) {}
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    eventsChanged.removeListener(_loadEvents);
    _pageController.dispose();
    super.dispose();
  }

  void _switchTab(int i) {
    setState(() => _tabIndex = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]}, ${d.year}';

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.c.surface,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Header ────────────────────────────────────────────────
              Container(
                color: context.c.surface,
                padding: EdgeInsets.only(
                  top: topPadding + 8,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 40),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'My Events & ',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: context.c.textPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Orders',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.c.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.filter_list_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ── Segmented control ─────────────────────────────
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.c.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _SegTab(
                            label: 'My Events',
                            active: _tabIndex == 0,
                            onTap: () => _switchTab(0),
                          ),
                          _SegTab(
                            label: 'Order Tracking',
                            active: _tabIndex == 1,
                            onTap: () => _switchTab(1),
                          ),
                        ],
                      ),
                    ),
                    // ── Sub-tabs (only on My Events) ──────────────────
                    if (_tabIndex == 0) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _SubTab(
                            label: 'Upcoming',
                            active: _subTabIndex == 0,
                            onTap: () => setState(() => _subTabIndex = 0),
                          ),
                          const SizedBox(width: 8),
                          _SubTab(
                            label: 'Past',
                            active: _subTabIndex == 1,
                            onTap: () => setState(() => _subTabIndex = 1),
                          ),
                          const SizedBox(width: 8),
                          _SubTab(
                            label: 'Cancelled',
                            active: _subTabIndex == 2,
                            onTap: () => setState(() => _subTabIndex = 2),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // ── Tab content ───────────────────────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _tabIndex = i),
                  children: [
                    _EventsTab(
                      events: _liveEvents,
                      fmtDate: _fmtDate,
                      subTabIndex: _subTabIndex,
                      onRefresh: _loadEvents,
                    ),
                    const _OrderTrackingTab(),
                  ],
                ),
              ),
            ],
          ),
          // ── FAB ───────────────────────────────────────────────────────
          if (_tabIndex == 0)
            Positioned(
              right: 20,
              bottom: 90,
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.createEventStep1),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFAB52F5), Color(0xFF7420D0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x559139E6),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Seg Tab ──────────────────────────────────────────────────────────────────

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? context.c.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.primary : context.c.textHint,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub Tab ──────────────────────────────────────────────────────────────────

class _SubTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SubTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : context.c.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ─── Service Chip ─────────────────────────────────────────────────────────────

class _ServiceChip extends StatelessWidget {
  final String label;

  const _ServiceChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─── Events Tab ───────────────────────────────────────────────────────────────

class _EventsTab extends StatelessWidget {
  final List<EventModel> events;
  final String Function(DateTime) fmtDate;
  final int subTabIndex;
  final Future<void> Function() onRefresh;

  const _EventsTab({
    required this.events,
    required this.fmtDate,
    required this.subTabIndex,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Filter by real status: Upcoming = active, Past = completed, Cancelled.
    final filtered = events.where((e) {
      final s = e.status.toUpperCase();
      switch (subTabIndex) {
        case 1:
          return s == 'COMPLETED';
        case 2:
          return s == 'CANCELLED';
        default:
          return s != 'COMPLETED' && s != 'CANCELLED';
      }
    }).toList();

    final label = subTabIndex == 1
        ? 'past'
        : subTabIndex == 2
            ? 'cancelled'
            : 'upcoming';

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: filtered.isEmpty
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 80, 16, 120),
              children: [
                Center(
                  child: Text(
                    'No $label events',
                    style: GoogleFonts.urbanist(color: context.c.textHint),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16 + ((context.screenWidth - 760) / 2).clamp(0.0, 400.0),
                16,
                16 + ((context.screenWidth - 760) / 2).clamp(0.0, 400.0),
                120,
              ),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) => subTabIndex == 0
                  ? _EventCard(event: filtered[i], fmtDate: fmtDate)
                  : _PastEventCard(
                      event: filtered[i],
                      fmtDate: fmtDate,
                      isCancelled: subTabIndex == 2,
                    ),
            ),
    );
  }
}

// ─── Event Card (Upcoming) ────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  final EventModel event;
  final String Function(DateTime) fmtDate;

  const _EventCard({
    required this.event,
    required this.fmtDate,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = event.statusLabel;
    // Confirmed = green; everything else (Draft/Planning) = amber.
    final isConfirmed = event.status.toUpperCase() == 'CONFIRMED';
    final statusBg =
        isConfirmed ? const Color(0xFFD1FAE5) : const Color(0xFFFFF3CD);
    final statusText =
        isConfirmed ? const Color(0xFF065F46) : const Color(0xFFB45309);

    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.eventDetail,
        extra: {'eventId': event.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: event.coverUrl != null
                        ? Image.network(
                            event.coverUrl!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, e, st) => _placeholder(context),
                          )
                        : _placeholder(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event chip + status badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.primary, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 10, color: AppColors.starColor),
                                  const SizedBox(width: 3),
                                  Text(
                                    'Event',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: GoogleFonts.urbanist(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: statusText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Event name
                        Text(
                          event.name,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Date · Venue
                        Text(
                          '${fmtDate(event.date)}${event.location != null ? ' · ${event.location}' : ''}',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: context.c.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── Vendors sourced (real count) ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.storefront_outlined,
                      size: 14, color: context.c.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    event.vendorsSourced == 0
                        ? 'No vendors sourced yet'
                        : '${event.vendorsSourced} '
                            '${event.vendorsSourced == 1 ? 'vendor' : 'vendors'} sourced',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: context.c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // ── Action row ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: GlossyButton(
                      label: 'View Details',
                      height: 40,
                      radius: 12,
                      onPressed: () => context.push(
                        AppRoutes.eventDetail,
                        extra: {'eventId': event.id},
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.c.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.event_rounded, color: AppColors.primary, size: 32),
      );
}

// ─── Past / Cancelled Event Card ──────────────────────────────────────────────

class _PastEventCard extends StatelessWidget {
  final EventModel event;
  final String Function(DateTime) fmtDate;
  final bool isCancelled;

  const _PastEventCard({
    required this.event,
    required this.fmtDate,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final badgeBg = isCancelled ? const Color(0xFFFFE4E6) : const Color(0xFFD1FAE5);
    final badgeText = isCancelled ? const Color(0xFFEF4444) : const Color(0xFF065F46);
    final badgeLabel = isCancelled ? 'Cancelled' : 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + Info Row ─────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: event.coverUrl != null
                    ? Image.network(
                        event.coverUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, st) => _placeholder(context),
                      )
                    : _placeholder(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const _ServiceChip(label: 'Single'),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badgeLabel,
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.name,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${event.location ?? 'Venue'} · ₦280,000',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: context.c.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Info Box ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.c.surfaceElevated,
              border: Border.all(color: context.c.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: context.c.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Friday, 13 March 2026 · 11:00 AM – 12:00 PM',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14, color: context.c.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lagos Island studio',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GlossyButton(
            label: 'View Details',
            height: 42,
            radius: 12,
            onPressed: () => context.push(
              AppRoutes.eventBookingDetail,
              extra: {'vendorName': event.name, 'bookingStatus': 'completed'},
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.event_rounded, color: AppColors.primary, size: 28),
      );
}

// ─── Order Tracking Tab ───────────────────────────────────────────────────────

class _OrderTrackingTab extends StatefulWidget {
  const _OrderTrackingTab();

  @override
  State<_OrderTrackingTab> createState() => _OrderTrackingTabState();
}

class _OrderTrackingTabState extends State<_OrderTrackingTab> {
  int _orderSubTab = 0;

  static const _subTabs = ['Purchase', 'Rentals', 'Completed', 'Cancelled'];

  static const _purchaseStatuses = ['Order placed', 'Order Confirmed', 'Out for Delivery', 'In Production'];
  static const _rentalStatuses = ['Returned', 'Picked up', 'Requested', 'Returned'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Sub-tab row ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_subTabs.length, (i) {
                final active = _orderSubTab == i;
                return Padding(
                  padding: EdgeInsets.only(right: i < _subTabs.length - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _orderSubTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : context.c.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _subTabs[i],
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        // ── Content ───────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: _getListings().length,
            itemBuilder: (ctx, i) {
              final listing = _getListings()[i];
              final status = _getStatus(i);
              return _OrderCard(
                listing: listing,
                status: status,
                subTab: _orderSubTab,
                onTap: () => _onCardTap(ctx, listing.id, status),
              );
            },
          ),
        ),
      ],
    );
  }

  List<ListingModel> _getListings() {
    switch (_orderSubTab) {
      case 0:
        return MockData.listings.take(4).toList();
      case 1:
        return MockData.listings.skip(1).take(3).toList();
      case 2:
        return MockData.listings.take(3).toList();
      case 3:
        return MockData.listings.take(3).toList();
      default:
        return MockData.listings.take(4).toList();
    }
  }

  String _getStatus(int i) {
    switch (_orderSubTab) {
      case 0:
        return _purchaseStatuses[i % _purchaseStatuses.length];
      case 1:
        return _rentalStatuses[i % _rentalStatuses.length];
      case 2:
        return 'Completed';
      case 3:
        return 'Cancelled';
      default:
        return 'Order placed';
    }
  }

  void _onCardTap(BuildContext ctx, String listingId, String status) {
    if (_orderSubTab == 1) {
      ctx.push(AppRoutes.rentalDetail, extra: {'listingId': listingId});
    } else {
      ctx.push(AppRoutes.orderDetail,
          extra: {'listingId': listingId, 'status': status});
    }
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final ListingModel listing;
  final String status;
  final int subTab;
  final VoidCallback onTap;

  const _OrderCard({
    required this.listing,
    required this.status,
    required this.subTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (badgeBg, badgeFg, isBorderBadge) = _badgeColors(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: listing.media.isNotEmpty
                ? Image.network(
                    listing.media.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => _imgPlaceholder(context),
                  )
                : _imgPlaceholder(context),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.c.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '13 Mar 2026',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: context.c.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.c.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    listing.basePrice != null
                        ? '₦${listing.basePrice!.toStringAsFixed(0)}'
                        : 'Quote',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right side: arrow button + status badge
          Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isBorderBadge ? Colors.transparent : badgeBg,
                  borderRadius: BorderRadius.circular(20),
                  border: isBorderBadge
                      ? Border.all(color: badgeFg)
                      : null,
                ),
                child: Text(
                  status,
                  style: GoogleFonts.urbanist(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgeFg,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  (Color, Color, bool) _badgeColors(String s) {
    switch (s) {
      case 'Order placed':
      case 'Order Confirmed':
      case 'Completed':
      case 'Returned':
        return (const Color(0xFFD1FAE5), const Color(0xFF065F46), false);
      case 'Out for Delivery':
      case 'Picked up':
        return (Colors.transparent, AppColors.primary, true);
      case 'In Production':
      case 'Requested':
        return (const Color(0xFFFEF3C7), const Color(0xFFB45309), false);
      case 'Cancelled':
        return (const Color(0xFFFFE4E6), const Color(0xFFEF4444), false);
      default:
        return (const Color(0xFFD1FAE5), const Color(0xFF065F46), false);
    }
  }

  Widget _imgPlaceholder(BuildContext context) => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.shopping_bag_outlined,
            color: AppColors.primary, size: 28),
      );
}
