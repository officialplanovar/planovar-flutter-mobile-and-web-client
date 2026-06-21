import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/models/listing_model.dart';
import '../../shared/models/vendor_model.dart';

/// Real replacement for MockBookingService — identical method shapes.
/// Maps API bookings (UPPERCASE statuses, Json eventLocation, Decimal strings,
/// partial nested objects) into the UI models.
class BookingService {
  final ApiClient _api;
  BookingService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<BookingModel>> getBookings() async {
    final res = await _api.dio.get('/bookings', queryParameters: {'take': 50});
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => mapBooking(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<BookingModel?> getBooking(String id) async {
    final res = await _api.dio.get('/bookings/$id');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    return mapBooking(Map<String, dynamic>.from(res.data));
  }

  Future<BookingModel> createBooking({
    required String vendorId,
    required String listingId,
    required DateTime eventDate,
    required String eventLocation,
    required String requirements,
    String? packageId,
  }) async {
    final res = await _api.dio.post('/bookings', data: {
      'vendorId': vendorId,
      'listingId': listingId,
      'eventDate': eventDate.toUtc().toIso8601String(),
      'location': eventLocation,
      'notes': requirements,
      if (packageId != null) 'packageId': packageId,
    });
    ensureOk(res);
    return mapBooking(Map<String, dynamic>.from(res.data));
  }

  Future<bool> cancelBooking(String bookingId) async {
    final res = await _api.dio.post('/bookings/$bookingId/cancel');
    ensureOk(res);
    return true;
  }

  // ── mapping ────────────────────────────────────────────────────────────

  static double? _toD(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));

  static BookingModel mapBooking(Map<String, dynamic> b) {
    final listing = b['listing'] as Map?;
    final vendor = b['vendor'] as Map?;
    final loc = b['eventLocation'];
    return BookingModel(
      id: b['id'] as String,
      clientId: b['clientId'] as String? ?? '',
      vendorId: b['vendorId'] as String? ?? '',
      vendor: vendor == null
          ? null
          : VendorModel(
              id: vendor['id'] as String? ?? '',
              businessName: vendor['businessName'] as String? ?? 'Vendor',
              slug: vendor['slug'] as String? ?? '',
              ratingAvg: _toD(vendor['ratingAvg']) ?? 0,
              reviewCount: (vendor['reviewCount'] as num?)?.toInt() ?? 0,
              subscriptionTier:
                  vendor['subscriptionTier'] as String? ?? 'BASIC',
              isVerified: vendor['isVerified'] as bool? ?? false,
              categories: const [],
            ),
      listingId: b['listingId'] as String? ?? '',
      listing: listing == null
          ? null
          : ListingModel(
              id: listing['id'] as String? ?? '',
              vendorId: b['vendorId'] as String? ?? '',
              categoryId: '',
              title: listing['title'] as String? ?? 'Listing',
              pricingType: listing['pricingType'] as String? ?? 'FIXED',
              basePrice: _toD(listing['basePrice']),
              isActive: true,
              isFeatured: false,
              media: const [],
              packages: const [],
            ),
      // UI compares lowercase statuses ('pending' | 'confirmed' | ...).
      status: (b['status'] as String? ?? 'PENDING').toLowerCase(),
      eventDate: DateTime.parse(b['eventDate'] as String),
      eventLocation:
          loc is Map ? loc['address'] as String? : loc as String?,
      requirements: b['requirements'] as String?,
      quoteAmount: _toD(b['quoteAmount']),
      finalAmount: _toD(b['finalAmount']),
    );
  }
}
