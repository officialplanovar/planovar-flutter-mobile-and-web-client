import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/event_model.dart';
import 'listing_service.dart';

/// Event Workspace backed by the API (/events).
class EventService {
  final ApiClient _api;
  EventService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<EventModel>> getEvents() async {
    final res = await _api.dio.get('/events');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => _map(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// A single event by id (404 → null).
  Future<EventModel?> getEvent(String id) async {
    final res = await _api.dio.get('/events/$id');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    return _map(Map<String, dynamic>.from(res.data));
  }

  /// Creates an event from the create-wizard's accumulated data
  /// ({eventType, title, venue, date, guests, budgetMin, budgetMax, categories}).
  Future<EventModel> createFromWizard(Map<String, dynamic> d) async {
    final date = d['date'];
    final categories = (d['categories'] as List?)?.cast<String>() ?? const [];
    final res = await _api.dio.post('/events', data: {
      'title': (d['title'] as String?)?.trim().isNotEmpty == true
          ? d['title']
          : 'My ${d['eventType'] ?? 'Event'}',
      if (d['eventType'] != null)
        'description':
            '${d['eventType']}${categories.isNotEmpty ? ' — needs: ${categories.join(', ')}' : ''}',
      'eventDate': (date is DateTime ? date : DateTime.now())
          .toUtc()
          .toIso8601String(),
      if ((d['venue'] as String?)?.isNotEmpty == true) 'location': d['venue'],
      if (d['guests'] != null) 'guestCount': d['guests'],
      if (d['budgetMax'] != null)
        'budget': d['budgetMax']
      else if (d['budgetMin'] != null)
        'budget': d['budgetMin'],
      if ((d['coverUrl'] as String?)?.isNotEmpty == true)
        'coverUrl': d['coverUrl'],
    });
    ensureOk(res);
    return _map(Map<String, dynamic>.from(res.data));
  }

  /// Cancels an event.
  Future<void> cancel(String eventId) async {
    final res = await _api.dio.delete('/events/$eventId');
    ensureOk(res);
  }

  /// Adds a specific product/service to an event (also sources its vendor).
  Future<void> addListing(String eventId, String listingId) async {
    final res = await _api.dio.post(
      '/events/$eventId/listings',
      data: {'listingId': listingId},
    );
    ensureOk(res);
  }

  Future<void> removeListing(String eventId, String listingId) async {
    final res = await _api.dio.delete('/events/$eventId/listings/$listingId');
    ensureOk(res);
  }

  /// Adds a vendor to an event's sourced vendors.
  Future<void> addVendor(String eventId, String vendorId) async {
    final res = await _api.dio.post(
      '/events/$eventId/vendors',
      data: {'vendorId': vendorId},
    );
    ensureOk(res);
  }

  // ── mapping (API event → UI model) ───────────────────────────────────────

  static double? _toD(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));

  static EventModel _map(Map<String, dynamic> e) {
    final loc = e['location'];
    return EventModel(
      id: e['id'] as String,
      clientId: e['clientId'] as String? ?? '',
      name: e['name'] as String? ?? 'Event',
      date: e['eventDate'] != null
          ? DateTime.parse(e['eventDate'] as String)
          : DateTime.now(),
      location: loc is Map ? loc['address'] as String? : loc as String?,
      guestCount: (e['guestCount'] as num?)?.toInt(),
      budgetMin: _toD(e['budgetMin']),
      budgetMax: _toD(e['budgetMax']),
      coverUrl: e['coverUrl'] as String?,
      status: e['status'] as String? ?? 'DRAFT',
      // List responses carry _count.eventVendors; the detail carries the array.
      vendorsSourced: (e['_count'] as Map?)?['eventVendors'] as int? ??
          (e['eventVendors'] as List?)?.length ??
          0,
      sourcedVendors: ((e['eventVendors'] as List?) ?? const [])
          .map((ev) => (ev as Map)['vendor'])
          .whereType<Map>()
          .map((v) => EventVendorRef(
                id: v['id'] as String? ?? '',
                businessName: v['businessName'] as String? ?? 'Vendor',
                slug: v['slug'] as String? ?? '',
                coverUrl:
                    (v['coverUrl'] as String?) ?? (v['logoUrl'] as String?),
              ))
          .toList(),
      // List responses give {listingId}; the detail gives {listing:{...}}.
      listingIds: ((e['eventListings'] as List?) ?? const [])
          .map((el) => (el as Map)['listingId'] as String? ??
              ((el['listing'] as Map?)?['id'] as String?))
          .whereType<String>()
          .toList(),
      addedListings: ((e['eventListings'] as List?) ?? const [])
          .map((el) => (el as Map)['listing'])
          .whereType<Map>()
          .map((l) => ListingService.mapListing(Map<String, dynamic>.from(l)))
          .toList(),
      hasGroupChat: e['groupConversation'] != null,
    );
  }
}
