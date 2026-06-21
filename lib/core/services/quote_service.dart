import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/quote_model.dart';

/// Real replacement for MockQuoteService — identical method shapes.
class QuoteService {
  final ApiClient _api;
  QuoteService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<QuoteModel?> getQuote(String id) async {
    final res = await _api.dio.get('/quotes/$id');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    return _map(Map<String, dynamic>.from(res.data));
  }

  /// Latest quote on a booking (the API embeds quotes in booking detail).
  Future<QuoteModel?> getQuoteForBooking(String bookingId) async {
    final res = await _api.dio.get('/bookings/$bookingId');
    if (res.statusCode == 404) return null;
    ensureOk(res);
    final quotes = (res.data as Map)['quotes'] as List? ?? const [];
    if (quotes.isEmpty) return null;
    final sorted = List<Map<String, dynamic>>.from(
        quotes.map((e) => Map<String, dynamic>.from(e)))
      ..sort((a, b) => (b['createdAt'] as String? ?? '')
          .compareTo(a['createdAt'] as String? ?? ''));
    return _map(sorted.first, bookingId: bookingId);
  }

  /// Accept = "Accept & Book": locks terms and confirms the inquiry.
  Future<bool> acceptQuote(String id) async {
    final res = await _api.dio.post('/quotes/$id/accept');
    ensureOk(res);
    return true;
  }

  Future<bool> rejectQuote(String id) async {
    final res = await _api.dio.post('/quotes/$id/reject');
    ensureOk(res);
    return true;
  }

  // ── mapping ────────────────────────────────────────────────────────────

  static double _toD(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('$v') ?? 0;

  QuoteModel _map(Map<String, dynamic> q, {String? bookingId}) {
    final items = (q['lineItems'] as List? ?? const [])
        .map((e) => QuoteLineItem(
              label: e['label'] as String? ?? '',
              amount: _toD(e['amount']),
            ))
        .toList();
    return QuoteModel(
      id: q['id'] as String,
      bookingId: q['bookingId'] as String? ?? bookingId ?? '',
      vendorId: q['vendorId'] as String? ?? '',
      amount: _toD(q['amount']),
      description: q['description'] as String? ?? q['notes'] as String?,
      lineItems: items,
      validUntil: q['validUntil'] != null
          ? DateTime.parse(q['validUntil'] as String)
          : DateTime.now().add(const Duration(days: 7)),
      // UI compares lowercase ('pending' | 'accepted' | 'rejected' | 'expired').
      status: (q['status'] as String? ?? 'PENDING').toLowerCase(),
    );
  }
}
