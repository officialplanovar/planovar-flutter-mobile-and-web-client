import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/booking_service.dart';
import '../../../core/services/listing_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/listing_model.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/glossy_button.dart';

class NewBookingScreen extends StatefulWidget {
  final String listingId;

  const NewBookingScreen({super.key, required this.listingId});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  final _bookingService = BookingService();
  final _listingService = ListingService();
  final _locationCtrl = TextEditingController();
  final _requirementsCtrl = TextEditingController();

  ListingModel? _listing;
  DateTime? _eventDate;
  ListingPackageModel? _selectedPackage;
  bool _loading = false;
  bool _loadingListing = true;

  @override
  void initState() {
    super.initState();
    _loadListing();
  }

  Future<void> _loadListing() async {
    final listing = await _listingService.getListing(widget.listingId);
    setState(() {
      _listing = listing;
      _loadingListing = false;
    });
  }

  @override
  void dispose() {
    _locationCtrl.dispose();
    _requirementsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _eventDate = date);
  }

  Future<void> _submit() async {
    if (_eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date')),
      );
      return;
    }
    if (_locationCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the event location')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final booking = await _bookingService.createBooking(
        vendorId: _listing?.vendorId ?? '',
        listingId: widget.listingId,
        eventDate: _eventDate!,
        eventLocation: _locationCtrl.text.trim(),
        requirements: _requirementsCtrl.text.trim(),
        packageId: _selectedPackage?.id,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking request submitted!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppRoutes.bookingDetailPath(booking.id));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Quote'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: _loadingListing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_listing != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.list_alt_rounded, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(_listing!.title, style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text('Event Details', style: AppTextStyles.heading4),
                  const SizedBox(height: 16),
                  // Date picker
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Text(
                            _eventDate != null ? Formatters.date(_eventDate!) : 'Select event date',
                            style: AppTextStyles.body2.copyWith(
                              color: _eventDate != null ? AppColors.textPrimary : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Event Location',
                      hintText: 'e.g. Eko Hotel, Victoria Island, Lagos',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _requirementsCtrl,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Requirements',
                      hintText: 'Describe your event, guest count, special requests...',
                      alignLabelWithHint: true,
                    ),
                  ),
                  // Package selector
                  if (_listing != null && _listing!.packages.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Select Package', style: AppTextStyles.heading4),
                    const SizedBox(height: 12),
                    ..._listing!.packages.map((pkg) {
                      final isSelected = _selectedPackage?.id == pkg.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPackage = isSelected ? null : pkg),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(pkg.name, style: AppTextStyles.label),
                                    if (pkg.description != null)
                                      Text(pkg.description!, style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              Text(
                                Formatters.currency(pkg.price),
                                style: AppTextStyles.label.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 32),
                  GlossyButton(
                    label: 'Submit Request',
                    onPressed: _loading ? null : _submit,
                    isLoading: _loading,
                  ),
                ],
              ),
            ),
    );
  }
}
