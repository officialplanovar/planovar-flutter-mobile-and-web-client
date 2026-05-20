import '../../shared/models/booking_model.dart';
import 'mock_data.dart';

class MockBookingService {
  static const _delay = Duration(milliseconds: 400);

  Future<List<BookingModel>> getBookings() async {
    await Future.delayed(_delay);
    return List.from(MockData.bookings);
  }

  Future<BookingModel?> getBooking(String id) async {
    await Future.delayed(_delay);
    try {
      return MockData.bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<BookingModel> createBooking({
    required String vendorId,
    required String listingId,
    required DateTime eventDate,
    required String eventLocation,
    required String requirements,
    String? packageId,
  }) async {
    await Future.delayed(_delay);
    final vendor = MockData.vendors.firstWhere((v) => v.id == vendorId);
    final listing = MockData.listings.firstWhere((l) => l.id == listingId);
    return BookingModel(
      id: 'booking-new-${DateTime.now().millisecondsSinceEpoch}',
      clientId: 'user-001',
      vendorId: vendorId,
      vendor: vendor,
      listingId: listingId,
      listing: listing,
      status: 'pending',
      eventDate: eventDate,
      eventLocation: eventLocation,
      requirements: requirements,
    );
  }

  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(_delay);
    return true;
  }
}
