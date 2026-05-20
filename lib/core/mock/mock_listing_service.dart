import '../../shared/models/listing_model.dart';
import 'mock_data.dart';

class MockListingService {
  static const _delay = Duration(milliseconds: 400);

  Future<ListingModel?> getListing(String id) async {
    await Future.delayed(_delay);
    try {
      return MockData.listings.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ListingModel>> getVendorListings(String vendorId) async {
    await Future.delayed(_delay);
    return MockData.listings.where((l) => l.vendorId == vendorId).toList();
  }
}
