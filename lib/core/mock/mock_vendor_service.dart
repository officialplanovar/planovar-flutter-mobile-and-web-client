import '../../shared/models/vendor_model.dart';
import 'mock_data.dart';

class MockVendorService {
  static const _delay = Duration(milliseconds: 400);
  final Set<String> _favouriteIds = {'vendor-02', 'vendor-03'};

  Future<List<VendorModel>> getVendors({
    String? categorySlug,
    String? city,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? query,
  }) async {
    await Future.delayed(_delay);
    var results = List<VendorModel>.from(MockData.vendors);

    if (categorySlug != null && categorySlug.isNotEmpty) {
      final catName = MockData.categories
          .firstWhere((c) => c.slug == categorySlug, orElse: () => MockData.categories.first)
          .name;
      results = results.where((v) => v.categories.contains(catName)).toList();
    }

    if (city != null && city.isNotEmpty) {
      results = results.where((v) => v.location?.contains(city) ?? false).toList();
    }

    if (minRating != null) {
      results = results.where((v) => v.ratingAvg >= minRating).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      results = results
          .where((v) =>
              v.businessName.toLowerCase().contains(q) ||
              (v.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return results;
  }

  Future<VendorModel?> getVendor(String id) async {
    await Future.delayed(_delay);
    try {
      return MockData.vendors.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<VendorModel>> getFavourites() async {
    await Future.delayed(_delay);
    return MockData.vendors.where((v) => _favouriteIds.contains(v.id)).toList();
  }

  Future<bool> toggleFavourite(String vendorId) async {
    await Future.delayed(_delay);
    if (_favouriteIds.contains(vendorId)) {
      _favouriteIds.remove(vendorId);
      return false;
    } else {
      _favouriteIds.add(vendorId);
      return true;
    }
  }

  bool isFavourite(String vendorId) => _favouriteIds.contains(vendorId);
}
