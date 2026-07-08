import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/event_service.dart';
import '../../core/state/overlay_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/event_model.dart';
import '../../shared/models/listing_model.dart';
import '../../shared/widgets/glossy_button.dart';

/// Shows the "Add to your Event" bottom sheet. Selecting an event and tapping
/// "Save & Continue" attaches the listing's vendor to that event.
void showAddToEventSheet(
  BuildContext context, {
  required ListingModel listing,
}) {
  bottomSheetCount.value++;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddToEventSheet(listing: listing),
  ).whenComplete(() => bottomSheetCount.value--);
}

/// Confirmation dialog used for add/remove actions on an event.
Future<bool> confirmEventAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.c.surface,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: ctx.c.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: ctx.c.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            'Cancel',
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w600,
              color: ctx.c.textSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            confirmLabel,
            style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              color: destructive ? const Color(0xFFDC2626) : AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );
  return ok == true;
}

/// Directly adds a listing to a known event (used when the user reached the
/// listing from *within* an event), confirming first, then returning to the
/// event detail. Skips the event-picker sheet entirely.
Future<void> confirmAddListingToEvent(
  BuildContext context, {
  required ListingModel listing,
  required String eventId,
  String? eventName,
}) async {
  final ok = await confirmEventAction(
    context,
    title: 'Add to this event?',
    message: 'Add "${listing.title}" to '
        '${(eventName != null && eventName.isNotEmpty) ? eventName : 'your event'}?',
    confirmLabel: 'Add',
  );
  if (!ok || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  try {
    await EventService().addListing(eventId, listing.id);
    notifyEventsChanged();
    messenger.showSnackBar(
      const SnackBar(content: Text('Added to your event 🎉')),
    );
    router.go(AppRoutes.eventDetail, extra: {'eventId': eventId});
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }
}

class AddToEventSheet extends StatefulWidget {
  final ListingModel listing;

  const AddToEventSheet({super.key, required this.listing});

  @override
  State<AddToEventSheet> createState() => _AddToEventSheetState();
}

class _AddToEventSheetState extends State<AddToEventSheet> {
  String? _selectedEventId;
  List<EventModel> _events = const [];
  bool _loading = true;
  bool _adding = false;

  Future<void> _addToSelectedEvent() async {
    if (_selectedEventId == null || _adding) return;
    final event = _events.firstWhere((e) => e.id == _selectedEventId);
    final ok = await confirmEventAction(
      context,
      title: 'Add to this event?',
      message: 'Add "${widget.listing.title}" to ${event.name}?',
      confirmLabel: 'Add',
    );
    if (!ok || !mounted) return;
    setState(() => _adding = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await EventService().addListing(_selectedEventId!, widget.listing.id);
      notifyEventsChanged();
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Added to your event 🎉')),
      );
    } catch (e) {
      if (mounted) setState(() => _adding = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final events = await EventService().getEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = _events;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: context.c.surface,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add to your Event',
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: context.c.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.listing.pricingType == 'fixed'
                          ? 'Select the events you need this product for'
                          : 'Link this service to an event',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (events.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "You don't have any events yet. Create one to add this to.",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: context.c.textSecondary,
                          ),
                        ),
                      )
                    else
                      ...events.map((event) {
                        final alreadyAdded =
                            event.listingIds.contains(widget.listing.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: EventCheckItem(
                            event: event,
                            selected: _selectedEventId == event.id,
                            alreadyAdded: alreadyAdded,
                            onTap: alreadyAdded
                                ? null
                                : () => setState(
                                    () => _selectedEventId = event.id),
                          ),
                        );
                      }),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Carry the listing so the new event adopts it and
                        // returns here (skipping vendor selection).
                        context.push(AppRoutes.createEventStep1, extra: {
                          'fromListingId': widget.listing.id,
                          'fromVendorId': widget.listing.vendorId,
                        });
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: context.c.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Create a New Event  +',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlossyButton(
                      label: _adding ? 'Adding…' : 'Save & Continue',
                      onPressed: (_selectedEventId != null && !_adding)
                          ? _addToSelectedEvent
                          : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventCheckItem extends StatelessWidget {
  final EventModel event;
  final bool selected;
  final bool alreadyAdded;
  final VoidCallback? onTap;

  const EventCheckItem({
    super.key,
    required this.event,
    required this.selected,
    required this.onTap,
    this.alreadyAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: alreadyAdded ? 0.55 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.c.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : context.c.border,
              width: selected ? 1.5 : 1,
            ),
          ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: event.coverUrl != null
                  ? Image.network(
                      event.coverUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(context),
                    )
                  : _placeholder(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (event.budgetRange.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.c.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.budgetRange,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (alreadyAdded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_rounded,
                        size: 12, color: Color(0xFF065F46)),
                    const SizedBox(width: 3),
                    Text(
                      'Added',
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              )
            else
              Radio<bool>(
                value: true,
                groupValue: selected,
                onChanged: onTap == null ? null : (_) => onTap!(),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        width: 60,
        height: 60,
        color: context.c.primaryLight,
        child: const Icon(Icons.event_rounded,
            color: AppColors.primary, size: 24),
      );
}
