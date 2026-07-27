import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/event_service.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/reference_data_service.dart';
import '../../../core/services/vendor_service.dart';
import '../../../core/state/overlay_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/vendor_model.dart';
import '../../../shared/widgets/add_to_event_sheet.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../../../shared/widgets/request_order_sheet.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int _tabIndex = 0;
  final List<String> _tabs = ['Vendors', 'Recommended', 'Timeline', 'Items'];
  final List<String> _selectedCategories = [];
  final _searchCtrl = TextEditingController();

  EventModel? _event;
  bool _loading = true;

  // Recommendation data (real) for the Recommended tab.
  List<VendorModel> _recVendors = const [];
  List<CategoryModel> _recCategories = const [];
  bool _recLoading = true;

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    EventModel? e;
    try {
      e = await EventService().getEvent(widget.eventId);
      if (mounted) {
        setState(() {
          _event = e;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final results = await Future.wait([
        VendorService().getVendors(),
        CategoryService().getCategories(),
      ]);
      if (mounted) {
        setState(() {
          _recVendors = results[0] as List<VendorModel>;
          _recCategories = (results[1] as List<CategoryModel>)
              .where((c) => c.slug != 'products')
              .toList();
          _recLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _recLoading = false);
    }
  }

  /// Confirms before sourcing a recommended vendor into this event.
  Future<void> _confirmSourceVendor(VendorModel vendor) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.c.surface,
        title: Text('Add vendor?', style: GoogleFonts.urbanist()),
        content: Text(
          'Add ${vendor.businessName} to "${_event?.name ?? 'this event'}"?',
          style: GoogleFonts.urbanist(color: ctx.c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (ok == true) await _sourceVendor(vendor);
  }

  /// Sources a recommended vendor into this event.
  Future<void> _sourceVendor(VendorModel vendor) async {
    try {
      await EventService().addVendor(widget.eventId, vendor.id);
      notifyEventsChanged();
      await _load(); // refresh sourced vendors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${vendor.businessName} added to your event')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

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
    if (_loading) {
      return Scaffold(
        backgroundColor: context.c.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final event = _event;
    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: context.c.surface,
          title: Text('Event Not Found', style: GoogleFonts.urbanist()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _goBack,
          ),
        ),
        body: const Center(child: Text('Event not found')),
      );
    }

    return Scaffold(
      backgroundColor: context.c.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
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
        ),
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
                    color: context.c.primaryLight,
                    child: const Icon(Icons.event, size: 64, color: AppColors.primary),
                  ),
                )
              : Container(
                  color: context.c.primaryLight,
                  child: const Icon(Icons.event, size: 64, color: AppColors.primary),
                ),
        ),
        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: _goBack,
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
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: context.c.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo(EventModel event) {
    return Container(
      color: context.c.surface,
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
              color: context.c.textPrimary,
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
            color: context.c.textSecondary,
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
        color: context.c.primaryLight,
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
                  color: context.c.textPrimary,
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
          Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                event.vendorsSourced == 0
                    ? 'No vendors sourced yet'
                    : '${event.vendorsSourced} '
                        '${event.vendorsSourced == 1 ? 'vendor' : 'vendors'} sourced',
                style:
                    GoogleFonts.urbanist(fontSize: 12, color: AppColors.primary),
              ),
              const Spacer(),
              Text(
                event.statusLabel,
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
      color: context.c.surface,
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
                    color: active ? context.c.textPrimary : context.c.textHint,
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
        return _buildTimelineTab(event);
      case 3:
        return _buildProductsTab(event);
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Vendors Tab ────────────────────────────────────────────────────────────

  Widget _buildVendorsTab(EventModel event) {
    final vendors = event.sourcedVendors;
    final isCancelled = event.status.toUpperCase() == 'CANCELLED';
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vendors.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.c.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.storefront_outlined,
                      size: 36, color: context.c.textHint),
                  const SizedBox(height: 10),
                  Text(
                    'No vendors sourced yet',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Browse the Recommended tab to add vendors to this event.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                        fontSize: 12, color: context.c.textSecondary),
                  ),
                ],
              ),
            )
          else
            ...vendors.map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _sourcedVendorCard(v),
                )),
          const SizedBox(height: 20),
          // Bottom actions
          GlossyButton(
            label: event.hasGroupChat ? '💬 View Group Chat' : '💬 Create Group Chat',
            height: 50,
            onPressed: () => _openGroupChat(event),
          ),
          const SizedBox(height: 12),
          _outlineButton(
            label: '+ Add a new Vendor',
            color: AppColors.primary,
            onTap: () => setState(() => _tabIndex = 1),
          ),
          if (!isCancelled) ...[
            const SizedBox(height: 12),
            _outlineButton(
              label: '⚠ Cancel Event',
              color: AppColors.error,
              onTap: () => _confirmCancel(event),
            ),
          ],
        ],
      ),
    );
  }

  Widget _vendorAvatarFallback() => Container(
        width: 44,
        height: 44,
        color: context.c.primaryLight,
        child: const Icon(Icons.storefront_rounded,
            color: AppColors.primary, size: 22),
      );

  Widget _sourcedVendorCard(EventVendorRef v) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.vendorProfilePath(v.id),
        extra: {'eventId': widget.eventId, 'eventName': _event?.name},
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: v.coverUrl != null
                  ? Image.network(
                      v.coverUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _vendorAvatarFallback(),
                    )
                  : _vendorAvatarFallback(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                v.businessName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.c.textHint),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(EventModel event) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.c.surface,
        title: Text('Cancel event?', style: GoogleFonts.urbanist()),
        content: Text(
          'This cancels "${event.name}". This cannot be undone.',
          style: GoogleFonts.urbanist(color: ctx.c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel event',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await EventService().cancel(event.id);
      notifyEventsChanged();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Event cancelled')));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  // ── Recommended Tab ────────────────────────────────────────────────────────

  Widget _buildRecommendedTab() {
    final categories = _recCategories;

    // Selected category names, then vendors whose tags match any of them.
    final selectedNames = _recCategories
        .where((c) => _selectedCategories.contains(c.id))
        .map((c) => c.name.toLowerCase())
        .toList();
    final visibleVendors = selectedNames.isEmpty
        ? _recVendors
        : _recVendors
            .where((v) => v.categories.any((t) =>
                selectedNames.any((n) => t.toLowerCase().contains(n))))
            .toList();

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
              color: context.c.textPrimary,
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
                      color: selected ? AppColors.primary : context.c.primaryLight,
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
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.c.border),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _searchCtrl,
                    style: GoogleFonts.urbanist(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search vendors...',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: context.c.textHint,
                      ),
                      border: InputBorder.none,
                      icon: Icon(Icons.search_rounded,
                          color: context.c.textHint, size: 20),
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
                  color: context.c.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune_rounded,
                    color: AppColors.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 2-column vendor grid (real, verified vendors)
          if (_recLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (visibleVendors.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                    selectedNames.isEmpty
                        ? 'No vendors available yet'
                        : 'No vendors in the selected categories',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(color: context.c.textHint)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: visibleVendors.length,
              itemBuilder: (ctx, i) => _vendorGridCard(visibleVendors[i]),
            ),
        ],
      ),
    );
  }

  Widget _vendorGridCard(VendorModel vendor) {
    final alreadyAdded =
        _event?.sourcedVendors.any((v) => v.id == vendor.id) ?? false;
    return GestureDetector(
      onTap: alreadyAdded ? null : () => _confirmSourceVendor(vendor),
      child: Container(
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
                              color: context.c.primaryLight,
                              child: const Icon(Icons.store,
                                  color: AppColors.primary, size: 32),
                            ),
                          )
                        : Container(
                            color: context.c.primaryLight,
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
                  color: context.c.textPrimary,
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

  Widget _buildTimelineTab(EventModel event) {
    final s = event.status.toUpperCase();
    final now = DateTime.now();
    final dayReached = !event.date.isAfter(DateTime(now.year, now.month, now.day));
    String done(bool v) => v ? 'Complete' : 'Pending';

    final steps = [
      _TimelineStep(number: 1, title: 'Event created', status: 'Complete'),
      _TimelineStep(
        number: 2,
        title: event.vendorsSourced == 0
            ? 'Source your vendors'
            : '${event.vendorsSourced} '
                '${event.vendorsSourced == 1 ? 'vendor' : 'vendors'} sourced',
        status: done(event.vendorsSourced > 0),
      ),
      _TimelineStep(
        number: 3,
        title: 'Event confirmed',
        status: done(s == 'CONFIRMED' || s == 'ACTIVE' || s == 'COMPLETED'),
      ),
      _TimelineStep(
        number: 4,
        title: 'Event day (${_fmtDate(event.date)})',
        status: done(dayReached || s == 'COMPLETED'),
      ),
      _TimelineStep(
        number: 5,
        title: 'Event completed',
        status: done(s == 'COMPLETED'),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Timeline',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
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
                      color: context.c.textPrimary,
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

  Widget _buildProductsTab(EventModel event) {
    final items = event.addedListings;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Center(
          child: Text(
            'Nothing added to this event yet.\nOpen a product or service and tap '
            '"Add to Event" to see it here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(color: context.c.textHint, height: 1.5),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Added to this event',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _productBrowseCard(p, event: event),
              )),
        ],
      ),
    );
  }

  Widget _productBrowseCard(ListingModel p, {EventModel? event}) {
    final price = p.basePrice != null
        ? '₦${p.basePrice!.toInt()}'
        : 'Contact for price';
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.listingDetailPath(p.id),
        extra: {'eventId': widget.eventId, 'eventName': event?.name},
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: p.media.isNotEmpty
                      ? Image.network(p.media.first,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: context.c.primaryLight))
                      : Container(
                          width: 56, height: 56, color: context.c.primaryLight),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (event != null)
                  GestureDetector(
                    onTap: () => _removeListing(event, p),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(Icons.close_rounded,
                          size: 20, color: context.c.textHint),
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: context.c.textHint),
              ],
            ),
            if (event != null) ...[
              const SizedBox(height: 10),
              _itemActionButton(event, p),
            ],
          ],
        ),
      ),
    );
  }

  /// Per-item primary action on the event Items tab: services request a quote,
  /// products/rentals open the order sheet.
  Widget _itemActionButton(EventModel event, ListingModel p) {
    final isRental = p.isRentable;
    final isProduct = p.pricingType == 'fixed';
    final label = isRental
        ? 'Rent now'
        : isProduct
            ? 'Order now'
            : 'Request Quote';
    final icon = isRental
        ? Icons.event_available_rounded
        : isProduct
            ? Icons.shopping_bag_rounded
            : Icons.request_quote_rounded;
    return SizedBox(
      height: 40,
      child: OutlinedButton.icon(
        onPressed: () {
          if (isRental || isProduct) {
            showRequestOrderSheet(context, listing: p, eventId: event.id);
          } else {
            _requestQuote(event, p);
          }
        },
        icon: Icon(icon, size: 16, color: AppColors.primary),
        label: Text(label,
            style: GoogleFonts.urbanist(
                fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  /// Opens/creates the DM with the item's vendor, sends an inquiry, and lands
  /// the client in the chat. The vendor then sends a quote.
  Future<void> _requestQuote(EventModel event, ListingModel p) async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final conv = await MessagingService().startWithVendor(p.vendorId);
      final d = event.date;
      await MessagingService().sendMessage(
        conversationId: conv.id,
        content:
            'Hi! I\'d like a quote for "${p.title}" for my event "${event.name}" '
            'on ${d.day}/${d.month}/${d.year}.',
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Inquiry sent — the vendor will send you a quote')),
      );
      router.push(AppRoutes.conversationDetailPath(conv.id));
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  /// Pops back, or falls back to the events list when the stack is empty
  /// (e.g. this screen was reached fresh via a redirect after adding an item).
  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.events);
    }
  }

  Future<void> _openGroupChat(EventModel event) async {
    if (!event.hasGroupChat) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Create group chat?',
              style: GoogleFonts.urbanist(
                  fontSize: 17, fontWeight: FontWeight.w800, color: ctx.c.textPrimary)),
          content: Text(
            'All vendors attached to this event will automatically join — including any you add later. '
            'Quotes and invoices stay private in your direct chats.',
            style: GoogleFonts.urbanist(fontSize: 14, color: ctx.c.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w600, color: ctx.c.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Create',
                  style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }
    await context.push(AppRoutes.eventGroupChat,
        extra: {'eventId': event.id, 'eventName': event.name});
    if (mounted) _load(); // refresh hasGroupChat after returning
  }

  Future<void> _removeListing(EventModel event, ListingModel listing) async {
    final ok = await confirmEventAction(
      context,
      title: 'Remove from event?',
      message: 'Remove "${listing.title}" from ${event.name}?',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (!ok || !mounted) return;
    try {
      await EventService().removeListing(event.id, listing.id);
      notifyEventsChanged();
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${listing.title} removed')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

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
