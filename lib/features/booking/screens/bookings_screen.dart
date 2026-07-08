import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/utils/formatters.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  final _bookingService = BookingService();
  late TabController _tabController;
  List<BookingModel> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final bookings = await _bookingService.getBookings();
    setState(() {
      _bookings = bookings;
      _loading = false;
    });
  }

  List<BookingModel> get _activeBookings =>
      _bookings.where((b) => ['pending', 'confirmed', 'active'].contains(b.status)).toList();

  List<BookingModel> get _pastBookings =>
      _bookings.where((b) => ['completed', 'cancelled'].contains(b.status)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Past')],
          labelColor: AppColors.primary,
          unselectedLabelColor: context.c.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: _loading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: ShimmerList(itemCount: 3, itemHeight: 100),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _BookingList(bookings: _activeBookings, onTap: (id) => context.push(AppRoutes.bookingDetailPath(id))),
                _BookingList(bookings: _pastBookings, onTap: (id) => context.push(AppRoutes.bookingDetailPath(id))),
              ],
            ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final void Function(String id) onTap;

  const _BookingList({required this.bookings, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(
        icon: Icons.calendar_today_outlined,
        title: 'No bookings here',
        subtitle: 'When you book a vendor, it will appear here.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, i) {
        final booking = bookings[i];
        return GestureDetector(
          onTap: () => onTap(booking.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.c.border),
            ),
            child: Row(
              children: [
                AppNetworkImage(
                  url: booking.vendor?.coverUrl,
                  width: 72,
                  height: 72,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.vendor?.businessName ?? 'Vendor',
                        style: AppTextStyles.label(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.listing?.title ?? '',
                        style: AppTextStyles.caption(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 12, color: context.c.textSecondary),
                          const SizedBox(width: 4),
                          Text(Formatters.date(booking.eventDate), style: AppTextStyles.caption(context)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusChip(status: booking.status),
                    const SizedBox(height: 4),
                    Icon(Icons.chevron_right_rounded, color: context.c.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
