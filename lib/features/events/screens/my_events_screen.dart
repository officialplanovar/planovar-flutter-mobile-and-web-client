import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planovar_client/shared/widgets/components.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/event_model.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final _pageController = PageController();
  int _index = 0;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _switchTo(int i) {
    setState(() => _index = i);
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
    // final events = MockData.events;
    final events = <EventModel>[];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: AppColors.primaryLight,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20,
              right: 20,
              bottom: 16,
            ),
            child: Column(
              children: [
                Text(
                  'My Events',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 16),
                // ── Segmented tab control ──────────────────────────────────
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                        label: 'My Bookings & Events',
                        active: _index == 0,
                        onTap: () => _switchTo(0),
                      ),
                      _SegTab(
                        label: 'Order Tracking',
                        active: _index == 1,
                        onTap: () => _switchTo(1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Tab content ─────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _BookingsTab(events: events, fmtDate: _fmtDate),
                _OrderTrackingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegTab(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryLight : Colors.transparent,
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
              color: active ? AppColors.primary : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── My Bookings & Events Tab ─────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  final List<EventModel> events;
  final String Function(DateTime) fmtDate;

  const _BookingsTab({required this.events, required this.fmtDate});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _EmptyState();
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: events.length,
          itemBuilder: (context, i) => _EventCard(
            event: events[i],
            fmtDate: fmtDate,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: _CreateEventButton(),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // 3D calendar illustration
          Image.asset(
            'assets/images/calendar_3d.png',
            width: 220,
            errorBuilder: (_, __, ___) => Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month_rounded,
                  color: AppColors.primary, size: 72),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Upcoming Events',
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'You have no upcoming event or booking, click the button below to book an event',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.65,
            ),
          ),
          const SizedBox(height: 24),
          _CreateEventButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _CreateEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlossyButton(label: '+ Create an Event', onPressed: () { context.push(AppRoutes.createEventStep1); },)
    /*GestureDetector(
      onTap: () => context.push(AppRoutes.createEventStep1),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B59F5), Color(0xFF7B2FBE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '+ Create an Event',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    )*/;
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  final String Function(DateTime) fmtDate;

  const _EventCard({required this.event, required this.fmtDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
            child: event.coverUrl != null
                ? Image.network(
                    event.coverUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        fmtDate(event.date),
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      if (event.guestCount != null) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.group_outlined,
                            size: 12, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${event.guestCount} guests',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (event.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12,
                            color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD1D5DB), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 90,
        height: 90,
        color: AppColors.primaryLight,
        child: const Icon(Icons.event_rounded,
            color: AppColors.primary, size: 32),
      );
}

// ─── Order Tracking Tab ───────────────────────────────────────────────────────

class _OrderTrackingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_shipping_outlined,
              size: 64, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          Text(
            'No active orders',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Orders from your events will appear here',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: const Color(0xFFD1D5DB),
            ),
          ),
        ],
      ),
    );
  }
}
