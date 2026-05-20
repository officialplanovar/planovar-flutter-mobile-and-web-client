import '../../shared/models/transaction_model.dart';
import 'mock_data.dart';

class MockPaymentService {
  static const _delay = Duration(milliseconds: 400);

  Future<List<TransactionModel>> getTransactions() async {
    await Future.delayed(_delay);
    return List.from(MockData.transactions);
  }

  Future<TransactionModel> initiatePayment({
    required String bookingId,
    required double amount,
  }) async {
    await Future.delayed(_delay);
    return TransactionModel(
      id: 'txn-${DateTime.now().millisecondsSinceEpoch}',
      bookingId: bookingId,
      type: 'payment',
      amount: amount,
      currency: 'NGN',
      status: 'completed',
      createdAt: DateTime.now(),
    );
  }
}
