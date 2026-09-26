import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/invoice_model.dart';

/// Client-side actions on the chat-order flow (/chat-orders). Vendor-only
/// actions (send/revise quote, accept/decline order) live in the vendor app.
class ChatOrdersService {
  final ApiClient _api;
  ChatOrdersService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Quotes ────────────────────────────────────────────────────────────────

  /// Accept a quote → the API records the agreement and returns the resulting
  /// invoice as a DISPLAY-ONLY record. Payment is arranged directly with the
  /// vendor, off-platform.
  Future<InvoiceModel> acceptQuote(String quoteId) async {
    final res = await _api.dio.post('/chat-orders/quotes/$quoteId/accept');
    ensureOk(res);
    return InvoiceModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> declineQuote(String quoteId) async {
    final res = await _api.dio.post('/chat-orders/quotes/$quoteId/decline');
    ensureOk(res);
  }

  // ── Direct orders (product / rental) ──────────────────────────────────────

  /// Sends a direct product/rental order request. Returns the DM conversation
  /// id (so the caller can open the chat where the ORDER_REQUEST card appears).
  Future<String?> createOrder({
    required String listingId,
    required String fulfilmentType, // PURCHASE | RENTAL
    required String deliveryMethod, // DELIVERY | PICKUP
    required double amount,
    double? deliveryFee,
    double? depositAmount,
    double? lateFeePerDay,
    String? pickupAt,
    String? returnAt,
    String? eventId,
    String? address,
    String? notes,
  }) async {
    final res = await _api.dio.post('/chat-orders/orders', data: {
      'listingId': listingId,
      'fulfilmentType': fulfilmentType,
      'deliveryMethod': deliveryMethod,
      'amount': amount,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (depositAmount != null) 'depositAmount': depositAmount,
      if (lateFeePerDay != null) 'lateFeePerDay': lateFeePerDay,
      if (pickupAt != null) 'pickupAt': pickupAt,
      if (returnAt != null) 'returnAt': returnAt,
      if (eventId != null) 'eventId': eventId,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
    });
    ensureOk(res);
    return (res.data as Map?)?['message']?['conversationId'] as String?;
  }

  // ── Group-chat to-dos ─────────────────────────────────────────────────────

  Future<void> createTodo({
    required String conversationId,
    required String title,
    required List<String> assigneeIds,
    String? description,
    String? dueAt,
  }) async {
    final res = await _api.dio.post('/chat-orders/todos', data: {
      'conversationId': conversationId,
      'title': title,
      'assigneeIds': assigneeIds,
      if (description != null) 'description': description,
      if (dueAt != null) 'dueAt': dueAt,
    });
    ensureOk(res);
  }

  /// Tick/untick the current user's own task on a to-do.
  Future<void> toggleTodo(String todoId) async {
    final res = await _api.dio.post('/chat-orders/todos/$todoId/toggle');
    ensureOk(res);
  }

  /// Client reviews a completed booking.
  Future<void> submitReview(
    String bookingId, {
    required int rating,
    required String body,
    String? title,
  }) async {
    final res = await _api.dio.post('/chat-orders/bookings/$bookingId/review', data: {
      'rating': rating,
      'body': body,
      if (title != null && title.isNotEmpty) 'title': title,
    });
    ensureOk(res);
  }
}
