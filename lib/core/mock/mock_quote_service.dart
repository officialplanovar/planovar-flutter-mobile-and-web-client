import '../../shared/models/quote_model.dart';
import 'mock_data.dart';

class MockQuoteService {
  static const _delay = Duration(milliseconds: 400);

  Future<QuoteModel?> getQuote(String id) async {
    await Future.delayed(_delay);
    try {
      return MockData.quotes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<QuoteModel?> getQuoteForBooking(String bookingId) async {
    await Future.delayed(_delay);
    try {
      return MockData.quotes.firstWhere((q) => q.bookingId == bookingId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> acceptQuote(String id) async {
    await Future.delayed(_delay);
    return true;
  }

  Future<bool> rejectQuote(String id) async {
    await Future.delayed(_delay);
    return true;
  }
}
