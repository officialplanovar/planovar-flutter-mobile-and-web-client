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
    final res = await _api.dio.get('/search/vendors', queryParameters: {
      if (query != null && query.isNotEmpty) 'q': query,
      if (city != null && city.isNotEmpty) 'city': city,
      'perPage': 20,
    });
    ensureOk(res);
    final hits = (res.data as Map)['hits'] as List? ?? const [];
    var vendors = hits
        .map((h) => _fromSearchDoc(Map<String, dynamic>.from(h)))
        .toList();
    // Category filter is tag-based client-side (search docs carry tags).
    if (category != null && category.isNotEmpty) {
      final c = category.toLowerCase();
      final filtered = hits
          .where((h) => ((h['tags'] as List?) ?? const [])
              .any((t) => t.toString().toLowerCase().contains(c)))
          .map((h) => _fromSearchDoc(Map<String, dynamic>.from(h)))
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

  Future<List<VendorModel>> getFavourites() async => const [];
  Future<bool> toggleFavourite(String vendorId) async {
    final res = await _api.dio.post('/users/me/favourites/$vendorId');
    return (res.statusCode ?? 500) < 300;
  }

  // ── mapping ────────────────────────────────────────────────────────────

  static double _toD(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0;

  /// From a Typesense vendor document ({name, slug, city, tags...}).
  VendorModel _fromSearchDoc(Map<String, dynamic> d) => VendorModel(
        id: d['id'] as String,
        businessName: d['name'] as String? ?? 'Vendor',
        slug: d['slug'] as String? ?? '',
        description: d['description'] as String?,
        location: [d['city'], d['country']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(', '),
        ratingAvg: _toD(d['ratingAvg']),
        reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
        subscriptionTier: d['subscriptionTier'] as String? ?? 'BASIC',
        isVerified: d['isVerified'] as bool? ?? false,
        categories: List<String>.from(d['tags'] as List? ?? const []),
      );

  /// From the public vendor profile (/vendors/:id JSON).
  static VendorModel fromProfile(Map<String, dynamic> v) {
    final loc = v['location'];
    return VendorModel(
      id: v['id'] as String,
      businessName: v['businessName'] as String? ?? 'Vendor',
      slug: v['slug'] as String? ?? '',
      description: v['description'] as String?,
      coverUrl: v['coverUrl'] as String?,
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
    );
  }
}
