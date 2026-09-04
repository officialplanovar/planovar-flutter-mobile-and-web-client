import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/reference_data_service.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/country_model.dart';
import '../../../shared/models/city_model.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';
import '../data/auth_remote_data_source.dart';
import '../../../core/api/api_client.dart';

class LocationPreferenceScreen extends StatefulWidget {
  const LocationPreferenceScreen({super.key});

  @override
  State<LocationPreferenceScreen> createState() =>
      _LocationPreferenceScreenState();
}

class _LocationPreferenceScreenState extends State<LocationPreferenceScreen> {
  final _locationService = LocationService();
  List<CountryModel> _countries = [];
  List<CityModel> _cities = [];
  CountryModel? _selectedCountry;
  CityModel? _selectedCity;
  bool _loading = true;
  bool _saving = false;

  Future<void> _saveAndProceed() async {
    setState(() => _saving = true);
    try {
      // Best-effort: a prefs hiccup shouldn't block onboarding.
      await AuthRemoteDataSource(ApiClient()).updateProfile({
        if (_selectedCountry != null)
          'preferredCountryId': _selectedCountry!.id,
        if (_selectedCity != null) 'preferredCityId': _selectedCity!.id,
      });
    } catch (e) {
      // Surface the failure — a swallowed error here left users unable to
      // complete onboarding (location never persisted).
      debugPrint('[onboarding] location save failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save location: $e')),
        );
      }
    }
    if (mounted) context.go(AppRoutes.createPassword);
  }

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countries = await _locationService.getCountries();
    setState(() {
      _countries = countries;
      _selectedCountry = countries.firstWhere(
        (c) => c.code == 'NG',
        orElse: () => countries.first,
      );
      _loading = false;
    });
    if (_selectedCountry != null) await _loadCities(_selectedCountry!.id);
  }

  Future<void> _loadCities(String countryId) async {
    final cities = await _locationService.getCities(countryId);
    setState(() {
      _cities = cities;
      _selectedCity = cities.isNotEmpty ? cities.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const AuthStepBar(step: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: pagePadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Center(
                            child: AuthIllustration(
                              pngPath: 'assets/icons/auth_location.png',
                              fallbackIcon: Icons.location_on_rounded,
                              bgColor: const Color(0xFFFFEBEB),
                              iconColor: const Color(0xFFEF5350),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Select your Preferred Location',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: context.c.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          _FieldLabel('Country'),
                          DropdownButtonFormField<CountryModel>(
                            value: _selectedCountry,
                            hint: Text(
                              'Select Country',
                              style: GoogleFonts.urbanist(
                                  fontSize: 15, color: context.c.textHint),
                            ),
                            items: _countries
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        '${c.flagEmoji} ${c.name}',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: context.c.textPrimary),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (c) {
                              setState(() {
                                _selectedCountry = c;
                                _selectedCity = null;
                                _cities = [];
                              });
                              if (c != null) _loadCities(c.id);
                            },
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: context.c.textSecondary),
                            decoration: const InputDecoration(),
                          ),
                          const SizedBox(height: 20),
                          _FieldLabel('City'),
                          DropdownButtonFormField<CityModel>(
                            value: _selectedCity,
                            hint: Text(
                              'Select your city',
                              style: GoogleFonts.urbanist(
                                  fontSize: 15, color: context.c.textHint),
                            ),
                            items: _cities
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        '${c.name}, ${c.state}',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: context.c.textPrimary),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (c) => setState(() => _selectedCity = c),
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: context.c.textSecondary),
                            decoration: const InputDecoration(),
                          ),
                          // "Use my current location" was a no-op button;
                          // removed until geolocation + reverse-geocoding is
                          // implemented. Users pick country/city above.
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: pagePadding(context)
                        .add(const EdgeInsets.only(bottom: 28)),
                    child: GlossyButton(
                      label: _saving ? 'Saving…' : 'Proceed',
                      onPressed: _saving ? null : _saveAndProceed,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: context.c.textPrimary,
        ),
      ),
    );
  }
}
