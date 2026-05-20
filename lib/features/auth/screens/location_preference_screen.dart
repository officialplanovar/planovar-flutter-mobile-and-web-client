import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/mock/mock_location_service.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/country_model.dart';
import '../../../shared/models/city_model.dart';
import '../../../shared/widgets/auth_illustration.dart';
import '../../../shared/widgets/auth_step_bar.dart';
import '../../../shared/widgets/glossy_button.dart';

class LocationPreferenceScreen extends StatefulWidget {
  const LocationPreferenceScreen({super.key});

  @override
  State<LocationPreferenceScreen> createState() =>
      _LocationPreferenceScreenState();
}

class _LocationPreferenceScreenState extends State<LocationPreferenceScreen> {
  final _locationService = MockLocationService();
  List<CountryModel> _countries = [];
  List<CityModel> _cities = [];
  CountryModel? _selectedCountry;
  CityModel? _selectedCity;
  bool _loading = true;

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const AuthStepBar(step: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Center(
                            child: AuthIllustration(
                              svgPath: 'assets/icons/auth_location.svg',
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
                                color: const Color(0xFF1A1A1A),
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
                                  fontSize: 15, color: const Color(0xFF9CA3AF)),
                            ),
                            items: _countries
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        '${c.flagEmoji} ${c.name}',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: const Color(0xFF1A1A1A)),
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
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF6B7280)),
                            decoration: const InputDecoration(),
                          ),
                          const SizedBox(height: 20),
                          _FieldLabel('City'),
                          DropdownButtonFormField<CityModel>(
                            value: _selectedCity,
                            hint: Text(
                              'Select your city',
                              style: GoogleFonts.urbanist(
                                  fontSize: 15, color: const Color(0xFF9CA3AF)),
                            ),
                            items: _cities
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        '${c.name}, ${c.state}',
                                        style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: const Color(0xFF1A1A1A)),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (c) => setState(() => _selectedCity = c),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF6B7280)),
                            decoration: const InputDecoration(),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'or',
                                  style: GoogleFonts.urbanist(
                                      fontSize: 13,
                                      color: const Color(0xFF9CA3AF)),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.my_location_rounded,
                                    size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'Use my current location',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                    child: GlossyButton(
                      label: 'Proceed',
                      onPressed: () => context.go(AppRoutes.createPassword),
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
          color: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
