import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/vendor_model.dart';
import '../../shared/models/listing_model.dart';
import 'listing_service.dart';

/// Real replacement for MockVendorService — identical method shapes.
/// Browse/search goes through /search/vendors (Typesense); detail through
/// /vendors/:id (embeds top active listings).
class VendorService {
  final ApiClient _api;
  VendorService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<VendorModel>> getVendors({
    String? query,
    String? category,
    String? city,
  }) async {
    // DB-backed browse (not search) — reliable regardless of Typesense, and
    // returns coverUrl straight from Postgres so tiles show images.
    final res = await _api.dio.get('/vendors/browse', queryParameters: {
      'take': 60,
    });
    ensureOk(res);
    final items = (res.data as List? ?? const [])
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    var vendors = items.map(fromProfile).toList();
    // Optional text filter on business name.
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      vendors = vendors
          .where((v) => v.businessName.toLowerCase().contains(q))
          .toList();
    }
    // Category filter is tag-based client-side (profiles carry tags).
    if (category != null && category.isNotEmpty) {
      final c = category.toLowerCase();
      final filtered = items
          .where((v) => ((v['tags'] as List?) ?? const [])
              .any((t) => t.toString().toLowerCase().contains(c)))
          .map(fromProfile)
          .toList();
      if (filtered.isNotEmpty) vendors = filtered;
    }
    return vendors;
  }

  Future<VendorModel?> getVendor(String id) async {
    final res = await _api.dio.get('/vendors/$id');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    return fromProfile(Map<String, dynamic>.from(res.data));
  }

  /// Listings embedded in the public vendor profile.
  Future<List<ListingModel>> getVendorListings(String vendorId) =>
      ListingService(api: _api).getVendorListings(vendorId);

  /// The user's saved (favourited) vendors.
  Future<List<VendorModel>> getFavourites() async {
    final res = await _api.dio.get('/users/me/favourites/vendors');
    ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => fromProfile(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Set of favourited vendor ids — for initialising heart state.
  Future<Set<String>> favouriteIds() async {
    final vendors = await getFavourites();
    return vendors.map((v) => v.id).toSet();
  }

  Future<void> addFavourite(String vendorId) async {
    final res = await _api.dio.post('/users/me/favourites/vendors/$vendorId');
    ensureOk(res);
  }

  Future<void> removeFavourite(String vendorId) async {
    final res = await _api.dio.delete('/users/me/favourites/vendors/$vendorId');
    ensureOk(res);
  }

  /// Toggles and returns the new state (true = now saved).
  Future<bool> toggleFavourite(String vendorId, bool currentlyFav) async {
    if (currentlyFav) {
      await removeFavourite(vendorId);
      return false;
    }
    await addFavourite(vendorId);
    return true;
  }

  // ── mapping ────────────────────────────────────────────────────────────

  static double _toD(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0;

  /// From the public vendor profile (/vendors/:id JSON).
  static VendorModel fromProfile(Map<String, dynamic> v) {
    final loc = v['location'];
    return VendorModel(
      id: v['id'] as String,
      businessName: v['businessName'] as String? ?? 'Vendor',
      slug: v['slug'] as String? ?? '',
      description: v['description'] as String?,
      // Fall back to the logo so cards aren't blank when there's no cover.
      coverUrl: (v['coverUrl'] as String?) ?? (v['logoUrl'] as String?),
      location: loc is Map
          ? [loc['city'], loc['state'], loc['country']]
              .whereType<String>()
              .where((s) => s.isNotEmpty)
              .join(', ')
          : null,
      ratingAvg: _toD(v['ratingAvg']),
      reviewCount: (v['reviewCount'] as num?)?.toInt() ?? 0,
      subscriptionTier: v['subscriptionTier'] as String? ?? 'BASIC',
      isVerified: v['isVerified'] as bool? ?? false,
      categories: List<String>.from(v['tags'] as List? ?? const []),
      portfolioUrls:
          List<String>.from(v['portfolioUrls'] as List? ?? const []),
    );
  }
}
