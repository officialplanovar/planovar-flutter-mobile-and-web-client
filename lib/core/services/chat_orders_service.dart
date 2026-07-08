import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/invoice_model.dart';

/// Result of starting a milestone payment — the client opens [authorizationUrl]
/// (Paystack checkout), then verifies with [reference].
class MilestoneCheckout {
  final String authorizationUrl;
  final String reference;
  final double netAmount;
  final double feeAmount;
  final double chargeAmount;

  const MilestoneCheckout({
    required this.authorizationUrl,
    required this.reference,
    required this.netAmount,
    required this.feeAmount,
    required this.chargeAmount,
  });

  factory MilestoneCheckout.fromJson(Map<String, dynamic> j) => MilestoneCheckout(
        authorizationUrl: j['authorizationUrl'] as String,
        reference: j['reference'] as String,
        netAmount: (j['netAmount'] as num?)?.toDouble() ?? 0,
        feeAmount: (j['feeAmount'] as num?)?.toDouble() ?? 0,
        chargeAmount: (j['chargeAmount'] as num?)?.toDouble() ?? 0,
      );
}

/// Client-side actions on the chat-order flow (/chat-orders). Vendor-only
/// actions (send/revise quote, accept/decline order) live in the vendor app.
class ChatOrdersService {
  final ApiClient _api;
  ChatOrdersService({ApiClient? api}) : _api = api ?? ApiClient();

  // ── Quotes ────────────────────────────────────────────────────────────────

  /// Accept a quote → the API creates the invoice + booking and returns it.
  Future<InvoiceModel> acceptQuote(String quoteId) async {
    final res = await _api.dio.post('/chat-orders/quotes/$quoteId/accept');
    ensureOk(res);
    return InvoiceModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> declineQuote(String quoteId) async {
    final res = await _api.dio.post('/chat-orders/quotes/$quoteId/decline');
    ensureOk(res);
  }

  // ── Milestone payments (direct client→vendor via Paystack) ────────────────

  Future<MilestoneCheckout> payMilestone(String milestoneId) async {
    final res = await _api.dio.post('/chat-orders/milestones/$milestoneId/pay');
    ensureOk(res);
    return MilestoneCheckout.fromJson(Map<String, dynamic>.from(res.data));
  }

  /// Confirm a payment after the Paystack checkout returns (idempotent).
  Future<bool> verifyPayment(String reference) async {
    final res = await _api.dio.post('/chat-orders/payments/$reference/verify');
    ensureOk(res);
    return (res.data as Map?)?['confirmed'] as bool? ?? false;
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
