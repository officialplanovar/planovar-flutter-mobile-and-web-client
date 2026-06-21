import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/listing_model.dart';

/// Real replacement for MockListingService — identical method shapes.
/// Maps API listings (Decimal strings, media as objects) into the UI model.
class ListingService {
  final ApiClient _api;
  ListingService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<ListingModel?> getListing(String id) async {
    final res = await _api.dio.get('/listings/$id');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    return mapListing(Map<String, dynamic>.from(res.data));
  }

  Future<List<ListingModel>> getVendorListings(String vendorId) async {
    // Vendor public profile embeds its top active listings.
    final res = await _api.dio.get('/vendors/$vendorId');
    ensureOk(res);
    final listings = (res.data as Map)['listings'] as List? ?? const [];
    return listings
        .map((e) => mapListing(Map<String, dynamic>.from(e), vendorId: vendorId))
        .toList();
  }

  /// Browse/search listings through /search/listings (Typesense). The docs are
  /// flatter than the REST listing shape (coverImage instead of media[],
  /// priceMin instead of basePrice), so they get their own mapper.
  Future<List<ListingModel>> searchListings({
    String? query,
    String? categoryId,
    String? pricingType,
    bool? isRentable,
    String? city,
  }) async {
    final res = await _api.dio.get('/search/listings', queryParameters: {
      if (query != null && query.isNotEmpty) 'q': query,
      if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      if (pricingType != null && pricingType.isNotEmpty)
        'pricingType': pricingType,
      if (isRentable != null) 'isRentable': isRentable,
      if (city != null && city.isNotEmpty) 'city': city,
      'perPage': 30,
    });
    ensureOk(res);
    final hits = (res.data as Map)['hits'] as List? ?? const [];
    return hits
        .map((h) => _fromSearchDoc(Map<String, dynamic>.from(h)))
        .toList();
  }

  static ListingModel _fromSearchDoc(Map<String, dynamic> d) {
    final cover = d['coverImage'] as String?;
    return ListingModel(
      id: d['id'] as String,
      vendorId: d['vendorId'] as String? ?? '',
      categoryId: d['categoryId'] as String? ?? '',
      title: d['title'] as String? ?? 'Listing',
      description: d['description'] as String?,
      pricingType: d['pricingType'] as String? ?? 'FIXED',
      basePrice: _toD(d['priceMin']),
      isActive: d['isActive'] as bool? ?? true,
      isFeatured: false,
      isRentable: d['isRentable'] as bool? ?? false,
      perDayRate: null,
      depositAmount: null,
      reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
      media: cover != null && cover.isNotEmpty ? [cover] : const [],
      packages: const [],
    );
  }

  // ── mapping ────────────────────────────────────────────────────────────

  static double? _toD(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));

  static ListingModel mapListing(Map<String, dynamic> l, {String? vendorId}) {
    final media = (l['media'] as List? ?? const [])
        .map((m) => m is Map ? m['url'] as String? : m as String?)
        .whereType<String>()
        .toList();
    final category = l['category'] as Map?;
    return ListingModel(
      id: l['id'] as String,
      vendorId: l['vendorId'] as String? ?? vendorId ?? '',
      categoryId:
          l['categoryId'] as String? ?? category?['id'] as String? ?? '',
      title: l['title'] as String? ?? 'Listing',
      description: l['description'] as String?,
      pricingType: l['pricingType'] as String? ?? 'FIXED',
      basePrice: _toD(l['basePrice']),
      isActive: l['isActive'] as bool? ?? true,
      isFeatured: l['isFeatured'] as bool? ?? false,
      isRentable: l['isRentable'] as bool? ?? false,
      perDayRate: _toD(l['perDayRate']),
      depositAmount: _toD(l['depositAmount']),
      reviewCount: (l['reviewCount'] as num?)?.toInt() ?? 0,
      media: media,
      packages: const [],
    );
  }
}
