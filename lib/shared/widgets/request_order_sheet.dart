import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/router/app_routes.dart';
import '../../core/services/chat_orders_service.dart';
import '../../core/state/overlay_state.dart';
import '../../core/theme/app_colors.dart';
import '../models/listing_model.dart';
import 'glossy_button.dart';

/// Bottom sheet to send a direct product/rental order request to a vendor.
/// On success it opens the DM chat where the ORDER_REQUEST card appears.
void showRequestOrderSheet(
  BuildContext context, {
  required ListingModel listing,
  String? eventId,
}) {
  bottomSheetCount.value++;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => RequestOrderSheet(listing: listing, eventId: eventId),
  ).whenComplete(() => bottomSheetCount.value--);
}

class RequestOrderSheet extends StatefulWidget {
  final ListingModel listing;
  final String? eventId;
  const RequestOrderSheet({super.key, required this.listing, this.eventId});

  @override
  State<RequestOrderSheet> createState() => _RequestOrderSheetState();
}

class _RequestOrderSheetState extends State<RequestOrderSheet> {
  bool _delivery = true;
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTime? _pickup;
  DateTime? _return;
  bool _submitting = false;

  bool get _isRental => widget.listing.isRentable;

  int get _days => (_pickup != null && _return != null)
      ? _return!.difference(_pickup!).inDays.clamp(1, 3650)
      : 1;

  double get _itemAmount {
    if (_isRental) {
      final rate = widget.listing.perDayRate ?? widget.listing.basePrice ?? 0;
      return rate * _days;
    }
    return widget.listing.basePrice ?? 0;
  }

  double get _deposit => _isRental ? (widget.listing.depositAmount ?? 0) : 0;
  double get _total => _itemAmount + _deposit;

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool pickup}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: pickup ? now : (_pickup ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (pickup) {
        _pickup = picked;
        if (_return != null && !_return!.isAfter(picked)) _return = null;
      } else {
        _return = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (_delivery && _addressCtrl.text.trim().isEmpty) {
      _snack('Enter a delivery address');
      return;
    }
    if (_isRental && (_pickup == null || _return == null)) {
      _snack('Choose pickup and return dates');
      return;
    }
    setState(() => _submitting = true);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final navigator = Navigator.of(context);
    try {
      final convId = await ChatOrdersService().createOrder(
        listingId: widget.listing.id,
        fulfilmentType: _isRental ? 'RENTAL' : 'PURCHASE',
        deliveryMethod: _delivery ? 'DELIVERY' : 'PICKUP',
        amount: _itemAmount,
        depositAmount: _isRental && _deposit > 0 ? _deposit : null,
        pickupAt: _pickup?.toIso8601String(),
        returnAt: _return?.toIso8601String(),
        eventId: widget.eventId,
        address: _delivery ? _addressCtrl.text.trim() : null,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Request sent to the vendor 🎉')),
      );
      if (convId != null) router.push(AppRoutes.conversationDetailPath(convId));
    } catch (e) {
      if (mounted) setState(() => _submitting = false);
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: context.c.surface,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _isRental ? 'Request rental' : 'Order this product',
                  style: GoogleFonts.urbanist(
                      fontSize: 18, fontWeight: FontWeight.w800, color: context.c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.listing.title,
                  style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary),
                ),
                const SizedBox(height: 16),
                // Delivery method
                Row(
                  children: [
                    _methodChip('Delivery', _delivery, () => setState(() => _delivery = true)),
                    const SizedBox(width: 10),
                    _methodChip('Pickup', !_delivery, () => setState(() => _delivery = false)),
                  ],
                ),
                if (_delivery) ...[
                  const SizedBox(height: 12),
                  _field(_addressCtrl, 'Delivery address'),
                ],
                if (_isRental) ...[
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _dateTile('Pickup', _pickup, () => _pickDate(pickup: true))),
                    const SizedBox(width: 10),
                    Expanded(child: _dateTile('Return', _return, () => _pickDate(pickup: false))),
                  ]),
                ],
                const SizedBox(height: 12),
                _field(_notesCtrl, 'Notes (optional)', maxLines: 2),
                const SizedBox(height: 16),
                _summaryRow('${_isRental ? 'Rental' : 'Item'}${_isRental ? ' ($_days day${_days == 1 ? '' : 's'})' : ''}', _itemAmount),
                if (_deposit > 0) _summaryRow('Refundable deposit', _deposit),
                const Divider(height: 20),
                _summaryRow('Total', _total, bold: true),
                const SizedBox(height: 16),
                GlossyButton(
                  label: _submitting ? 'Sending…' : 'Send request',
                  onPressed: _submitting ? null : _submit,
                ),
                const SizedBox(height: 4),
                Text(
                  'The vendor reviews your request, then sends an invoice you can pay directly.',
                  style: GoogleFonts.urbanist(fontSize: 11.5, color: context.c.textHint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _methodChip(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? context.c.primaryLight : context.c.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? AppColors.primary : context.c.border),
          ),
          child: Text(label,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  color: active ? AppColors.primary : context.c.textSecondary)),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, {int maxLines = 1}) {
    return TextField(
      controller: c,
      maxLines: maxLines,
      style: GoogleFonts.urbanist(color: context.c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(color: context.c.textHint),
        filled: true,
        fillColor: context.c.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.c.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _dateTile(String label, DateTime? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.c.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.c.border),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 15, color: context.c.textHint),
            const SizedBox(width: 8),
            Text(
              value != null ? '${value.day}/${value.month}/${value.year}' : label,
              style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: value != null ? context.c.textPrimary : context.c.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label,
              style: GoogleFonts.urbanist(
                  fontSize: bold ? 15 : 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  color: bold ? context.c.textPrimary : context.c.textSecondary)),
          const Spacer(),
          Text('₦${amount.toInt()}',
              style: GoogleFonts.urbanist(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: bold ? AppColors.primary : context.c.textPrimary)),
        ],
      ),
    );
  }
}
