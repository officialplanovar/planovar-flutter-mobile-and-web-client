import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/glossy_button.dart';
import 'create_event_step1_screen.dart' show EventStepHeader;

class CreateEventStep2Screen extends StatefulWidget {
  final String eventType;

  const CreateEventStep2Screen({super.key, required this.eventType});

  @override
  State<CreateEventStep2Screen> createState() => _CreateEventStep2ScreenState();
}

class _CreateEventStep2ScreenState extends State<CreateEventStep2Screen> {
  final _titleCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  DateTime? _date;
  TimeOfDay? _timeFrom;
  TimeOfDay? _timeTo;
  int _guests = 50;
  final _budgetMinCtrl = TextEditingController();
  final _budgetMaxCtrl = TextEditingController();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _venueCtrl.dispose();
    _budgetMinCtrl.dispose();
    _budgetMaxCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.day} ${_months[d.month - 1]}, ${d.year}';

  String _fmtTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (t != null) {
      setState(() {
        if (isFrom) _timeFrom = t;
        else _timeTo = t;
      });
    }
  }

  void _next() {
    context.push(AppRoutes.createEventStep3, extra: {
      'eventType': widget.eventType,
      'title': _titleCtrl.text.trim(),
      'venue': _venueCtrl.text.trim(),
      'date': _date,
      'guests': _guests,
      'budgetMin': double.tryParse(_budgetMinCtrl.text.replaceAll(',', '')),
      'budgetMax': double.tryParse(_budgetMaxCtrl.text.replaceAll(',', '')),
    });
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _titleCtrl.text.trim().isNotEmpty && _date != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          EventStepHeader(
            currentStep: 2,
            onBack: () => context.pop(),
            titlePrefix: 'Event ',
            titleHighlight: 'Details',
            subtitle: 'Step Two, Enter your Event Details',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('Event Title'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: _titleCtrl,
                    hint: 'e.g. My Wedding Reception',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 18),
                  // Date + guests row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Event Date'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _pickDate,
                              child: _ReadonlyField(
                                text: _date != null ? _fmtDate(_date!) : null,
                                hint: 'Select date',
                                icon: Icons.calendar_today_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Guest Count'),
                            const SizedBox(height: 8),
                            _GuestCounter(
                              value: _guests,
                              onChanged: (v) =>
                                  setState(() => _guests = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Time from/to row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Time From'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickTime(isFrom: true),
                              child: _ReadonlyField(
                                text: _timeFrom != null
                                    ? _fmtTime(_timeFrom!)
                                    : null,
                                hint: 'Start time',
                                icon: Icons.access_time_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Time To'),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _pickTime(isFrom: false),
                              child: _ReadonlyField(
                                text: _timeTo != null
                                    ? _fmtTime(_timeTo!)
                                    : null,
                                hint: 'End time',
                                icon: Icons.access_time_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _FieldLabel('Venue'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: _venueCtrl,
                    hint: 'Enter venue address',
                  ),
                  const SizedBox(height: 18),
                  // Budget row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Budget Min (₦)'),
                            const SizedBox(height: 8),
                            _TextField(
                              controller: _budgetMinCtrl,
                              hint: '50,000',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Budget Max (₦)'),
                            const SizedBox(height: 8),
                            _TextField(
                              controller: _budgetMaxCtrl,
                              hint: '500,000',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Thumbnail upload
                  _FieldLabel('Event Thumbnail'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            style: BorderStyle.solid),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_rounded,
                              color: AppColors.primary, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Upload thumbnail',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: GlossyButton(
              label: 'Next',
              onPressed: canProceed ? _next : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: GoogleFonts.urbanist(
            fontSize: 14, color: const Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.urbanist(
              fontSize: 13, color: const Color(0xFFD1D5DB)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  final String? text;
  final String hint;
  final IconData icon;

  const _ReadonlyField(
      {required this.hint, required this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text ?? hint,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: text != null
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFFD1D5DB),
              ),
            ),
          ),
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class _GuestCounter extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const _GuestCounter({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => onChanged(value > 1 ? value - 10 : value),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, size: 14, color: AppColors.primary),
            ),
          ),
          Text(
            '$value',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(value + 10),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 14, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
