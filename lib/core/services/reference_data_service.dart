import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/country_model.dart';
import '../../shared/models/city_model.dart';
import '../../shared/models/category_model.dart';

/// Real replacements for MockLocationService / MockCategoryService —
/// identical method shapes so screens can swap them in directly.
class LocationService {
  final ApiClient _api;
  LocationService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<CountryModel>> getCountries() async {
    final res = await _api.dio.get('/locations/countries');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<CityModel>> getCities(String countryId) async {
    final res = await _api.dio.get('/locations/countries/$countryId/cities');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => CityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class CategoryService {
  final ApiClient _api;
  CategoryService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    final res = await _api.dio.get('/categories');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
