import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/glossy_button.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int _tabIndex = 0;
  final List<String> _tabs = ['Vendors', 'Recommended', 'Timeline', 'Products'];
  final List<String> _selectedCategories = [];
  final _searchCtrl = TextEditingController();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]}, ${d.year}';

  String _fmtBudget(double? val) {
    if (val == null) return '—';
    final s = val.toInt().toString();
    final buf = StringBuffer('₦');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final event = MockData.events
        .where((e) => e.id == widget.eventId)
        .firstOrNull;

    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Event Not Found', style: GoogleFonts.urbanist()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Event not found')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: Column(
        children: [
          // ── Cover + Header ─────────────────────────────────────────────
          _buildCoverHeader(context, event),
          // ── Scrollable Body ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventInfo(event),
                  _buildPlanningProgress(event),
                  _buildTabBar(),
                  _buildTabContent(event),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverHeader(BuildContext context, EventModel event) {
    return Stack(
      children: [
        // Cover image
        SizedBox(
          height: 200,
          width: double.infinity,
          child: event.coverUrl != null
              ? Image.network(
                  event.coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, e, st) => Container(
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.event, size: 64, color: AppColors.primary),
                  ),
                )
              : Container(
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.event, size: 64, color: AppColors.primary),
                ),
        ),
        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo(EventModel event) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 12, color: AppColors.starColor),
                const SizedBox(width: 4),
                Text(
                  'Event',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Event name
          Text(
            event.name,
            style: GoogleFonts.urbanist(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          // Date · Location · Guests
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _infoChip(Icons.calendar_today_rounded, _fmtDate(event.date)),
              if (event.location != null)
                _infoChip(Icons.location_on_rounded, event.location!),
              if (event.guestCount != null)
                _infoChip(Icons.group_rounded, '${event.guestCount} guests'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanningProgress(EventModel event) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Planning progress',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const Spacer(),
              Text(
                'Budget: ${_fmtBudget(event.budgetMin)} – ${_fmtBudget(event.budgetMax)}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.9,
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '2 of 3 Vendors sourced',
                style: GoogleFonts.urbanist(fontSize: 12, color: AppColors.primary),
              ),
              const Spacer(),
              Text(
                '90%',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final active = _tabIndex == i;
            return GestureDetector(
              onTap: () => setState(() => _tabIndex = i),
              child: Container(
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active ? AppColors.primary : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? const Color(0xFF1A1A2E) : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabContent(EventModel event) {
    switch (_tabIndex) {
      case 0:
        return _buildVendorsTab(event);
      case 1:
        return _buildRecommendedTab();
      case 2:
        return _buildTimelineTab();
      case 3:
        return _buildProductsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Vendors Tab ────────────────────────────────────────────────────────────

  Widget _buildVendorsTab(EventModel event) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confirmed vendor card
          _vendorBookingCard(
            vendorName: 'Lumière Photography',
            service: 'Photography',
            priceLabel: 'Lumière Photography · ₦20,000',
            status: 'Confirmed',
            imageUrl: 'https://images.unsplash.com/photo-1554048612-b6a482bc67e5?w=400',
          ),
          const SizedBox(height: 12),
          // Pending vendor card
          _vendorBookingCard(
            vendorName: 'Sugared Dreams Cakery',
            service: 'Confectionery',
            priceLabel: 'Sugared Dreams Cakery · ₦15,000',
            status: 'Pending',
            imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400',
            showAwaitingBanner: true,
          ),
          const SizedBox(height: 12),
          // Unassigned vendor card
          _vendorUnassignedCard(service: 'Catering'),
          const SizedBox(height: 20),
          // Bottom actions
          GlossyButton(
            label: '💬 View Group Chat',
            height: 50,
            onPressed: () => context.push(AppRoutes.eventGroupChat,
                extra: {'eventId': event.id, 'eventName': event.name}),
          ),
          const SizedBox(height: 12),
          _outlineButton(
            label: '+ Add a new Vendor',
            color: AppColors.primary,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _outlineButton(
            label: '⚠ Cancel Event',
            color: AppColors.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _vendorBookingCard({
    required String vendorName,
    required String service,
    required String priceLabel,
    required String status,
    required String imageUrl,
    bool showAwaitingBanner = false,
  }) {
    final isConfirmed = status == 'Confirmed';
    final statusBg = isConfirmed ? const Color(0xFFD1FAE5) : const Color(0xFFFFF3CD);
    final statusText = isConfirmed ? const Color(0xFF065F46) : const Color(0xFFB45309);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          if (showAwaitingBanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 14, color: Color(0xFFD97706)),
                  const SizedBox(width: 6),
                  Text(
                    'Awaiting Quote from vendor',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, e, st) => Container(
                          width: 60,
                          height: 60,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.store,
                              color: AppColors.primary, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            priceLabel,
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _outlineButton(
                        label: 'View Details',
                        color: AppColors.primary,
                        onTap: () => context.push(
                          AppRoutes.eventBookingDetail,
                          extra: {
                            'vendorName': vendorName,
                            'bookingStatus': isConfirmed ? 'quote_sent' : 'awaiting',
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorUnassignedCard({required String service}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_add_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'No vendor assigned',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          _outlineButton(
            label: 'Source Vendor',
            color: AppColors.primary,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Recommended Tab ────────────────────────────────────────────────────────

  Widget _buildRecommendedTab() {
    final categories = MockData.categories.take(6).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vendors available for your event',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final selected = _selectedCategories.contains(cat.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedCategories.remove(cat.id);
                      } else {
                        _selectedCategories.add(cat.id);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selected) ...[
                          const Icon(Icons.check_rounded,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          cat.name,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Search bar
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _searchCtrl,
                    style: GoogleFonts.urbanist(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search vendors...',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search_rounded,
                          color: Color(0xFF9CA3AF), size: 20),
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: AppColors.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 2-column vendor grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: MockData.vendors.length,
            itemBuilder: (ctx, i) {
              final vendor = MockData.vendors[i];
              return _vendorGridCard(vendor);
            },
          ),
        ],
      ),
    );
  }

  Widget _vendorGridCard(VendorModel vendor) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: vendor.coverUrl != null
                        ? Image.network(
                            vendor.coverUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, e, st) => Container(
                              color: AppColors.primaryLight,
                              child: const Icon(Icons.store,
                                  color: AppColors.primary, size: 32),
                            ),
                          )
                        : Container(
                            color: AppColors.primaryLight,
                            child: const Icon(Icons.store,
                                color: AppColors.primary, size: 32),
                          ),
                  ),
                  // Category chip
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        vendor.categories.isNotEmpty
                            ? vendor.categories.first
                            : 'Vendor',
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Rating
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 10, color: AppColors.starColor),
                          const SizedBox(width: 2),
                          Text(
                            vendor.ratingAvg.toStringAsFixed(1),
                            style: GoogleFonts.urbanist(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                vendor.businessName,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Timeline Tab ───────────────────────────────────────────────────────────

  Widget _buildTimelineTab() {
    final steps = [
      _TimelineStep(number: 1, title: 'Event Created', status: 'Complete'),
      _TimelineStep(number: 2, title: '1 of 3 Vendors Sourced', status: 'Pending'),
      _TimelineStep(number: 3, title: '1 of 3 Payments Made', status: 'Pending'),
      _TimelineStep(number: 4, title: 'Event Day', status: 'Pending'),
      _TimelineStep(number: 5, title: '0 of 3 Reviews made', status: 'Pending'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Text(
              'Event Timeline',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 20),
            ...steps.asMap().entries.map((entry) {
              final i = entry.key;
              final step = entry.value;
              final isLast = i == steps.length - 1;
              return _buildTimelineStep(step, isLast);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(_TimelineStep step, bool isLast) {
    final isComplete = step.status == 'Complete';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line + circle column
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isComplete ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: isComplete
                    ? null
                    : Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  '${step.number}',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isComplete ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: CustomPaint(
                  painter: _DashedLinePainter(color: AppColors.primary),
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 32, top: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    step.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? const Color(0xFFD1FAE5)
                        : const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    step.status,
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isComplete
                          ? const Color(0xFF065F46)
                          : const Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Products Tab ───────────────────────────────────────────────────────────

  Widget _buildProductsTab() {
    final products = MockData.listings.take(4).toList();
    final statuses = [
      'Order placed',
      'Order Confirmed',
      'Out for Delivery',
      'In Production',
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: products.asMap().entries.map((entry) {
          final i = entry.key;
          final listing = entry.value;
          return _productOrderCard(listing, statuses[i % statuses.length]);
        }).toList(),
      ),
    );
  }

  Widget _productOrderCard(ListingModel listing, String status) {
    Color statusBg;
    Color statusTextColor;
    bool isOutline = false;

    switch (status) {
      case 'Order placed':
      case 'Order Confirmed':
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF065F46);
        break;
      case 'Out for Delivery':
        statusBg = Colors.transparent;
        statusTextColor = AppColors.primary;
        isOutline = true;
        break;
      case 'In Production':
        statusBg = const Color(0xFFFFF3CD);
        statusTextColor = const Color(0xFFB45309);
        break;
      default:
        statusBg = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF065F46);
    }

    final price = listing.basePrice ?? listing.packages.firstOrNull?.price ?? 0.0;
    final priceStr = '₦${price.toInt()}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: listing.media.isNotEmpty
                ? Image.network(
                    listing.media.first,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, st) => _productPlaceholder(),
                  )
                : _productPlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '14 Feb 2026',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        priceStr,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isOutline ? Colors.transparent : statusBg,
                        borderRadius: BorderRadius.circular(20),
                        border: isOutline
                            ? Border.all(color: AppColors.primary)
                            : null,
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.north_east_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productPlaceholder() => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.shopping_bag_rounded,
            color: AppColors.primary, size: 28),
      );

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _outlineButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    double height = 44,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Data classes ──────────────────────────────────────────────────────────────

class _TimelineStep {
  final int number;
  final String title;
  final String status;

  const _TimelineStep({
    required this.number,
    required this.title,
    required this.status,
  });
}

// ─── Dashed line painter ───────────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;
    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
