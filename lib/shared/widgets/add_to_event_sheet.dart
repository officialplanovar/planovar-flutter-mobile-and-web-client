import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/mock/mock_data.dart';
import '../../core/state/overlay_state.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/event_model.dart';
import '../../shared/models/listing_model.dart';
import '../../shared/widgets/glossy_button.dart';

/// Shows the "Add to your Event" bottom sheet and calls [onConfirm] with
/// the list of selected event IDs when the user taps "Save & Continue".
void showAddToEventSheet(
  BuildContext context, {
  required ListingModel listing,
  required void Function(List<String> eventIds) onConfirm,
}) {
  bottomSheetCount.value++;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddToEventSheet(
      listing: listing,
      onConfirm: onConfirm,
    ),
  ).whenComplete(() => bottomSheetCount.value--);
}

class AddToEventSheet extends StatefulWidget {
  final ListingModel listing;
  final void Function(List<String> eventIds) onConfirm;

  const AddToEventSheet({
    super.key,
    required this.listing,
    required this.onConfirm,
  });

  @override
  State<AddToEventSheet> createState() => _AddToEventSheetState();
}

class _AddToEventSheetState extends State<AddToEventSheet> {
  String? _selectedEventId;

  @override
  Widget build(BuildContext context) {
    final events = MockData.events;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: Colors.white,
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
                            color: const Color(0xFF1A1A2E),
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
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...events.map(
                      (event) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: EventCheckItem(
                          event: event,
                          selected: _selectedEventId == event.id,
                          onTap: () => setState(() => _selectedEventId = event.id),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
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
                      label: 'Save & Continue',
                      onPressed: _selectedEventId != null
                          ? () {
                              Navigator.pop(context);
                              widget.onConfirm([_selectedEventId!]);
                            }
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
  final VoidCallback onTap;

  const EventCheckItem({
    super.key,
    required this.event,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E7EB),
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
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
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
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (event.budgetRange.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
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
            Radio<bool>(
              value: true,
              groupValue: selected,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 60,
        height: 60,
        color: AppColors.primaryLight,
        child: const Icon(Icons.event_rounded,
            color: AppColors.primary, size: 24),
      );
}
