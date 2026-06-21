import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/event_model.dart';

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
    });
    ensureOk(res);
    return _map(Map<String, dynamic>.from(res.data));
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
    );
  }
}
