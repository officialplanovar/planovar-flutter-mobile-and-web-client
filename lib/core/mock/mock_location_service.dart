import '../../shared/models/country_model.dart';
import '../../shared/models/city_model.dart';
import 'mock_data.dart';

class MockLocationService {
  static const _delay = Duration(milliseconds: 400);

  Future<List<CountryModel>> getCountries() async {
    await Future.delayed(_delay);
    return List.from(MockData.countries);
  }

  Future<List<CityModel>> getCities(String countryId) async {
    await Future.delayed(_delay);
    return List.from(MockData.citiesByCountry[countryId] ?? []);
  }
}
