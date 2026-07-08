import 'package:equatable/equatable.dart';
import 'listing_model.dart';

/// A vendor sourced for an event (from the event's eventVendors).
class EventVendorRef {
  final String id;
  final String businessName;
  final String slug;
  final String? coverUrl;
  const EventVendorRef({
    required this.id,
    required this.businessName,
    required this.slug,
    this.coverUrl,
  });
}

class EventModel extends Equatable {
  final String id;
  final String clientId;
  final String name;
  final DateTime date;
  final String? location;
  final int? guestCount;
  final int? durationHours;
  final double? budgetMin;
  final double? budgetMax;
  final String? coverUrl;
  /// API EventStatus: DRAFT, PLANNING, CONFIRMED, COMPLETED, CANCELLED.
  final String status;
  final int vendorsSourced;
  final List<EventVendorRef> sourcedVendors;
  /// Ids of listings added to the event (from list responses too).
  final List<String> listingIds;
  /// The added products/services with details (from the detail response).
  final List<ListingModel> addedListings;
  /// Whether the event group chat has been created yet (detail response).
  final bool hasGroupChat;

  const EventModel({
    required this.id,
    required this.clientId,
    required this.name,
    required this.date,
    this.location,
    this.guestCount,
    this.durationHours,
    this.budgetMin,
    this.budgetMax,
    this.coverUrl,
    this.status = 'DRAFT',
    this.vendorsSourced = 0,
    this.sourcedVendors = const [],
    this.listingIds = const [],
    this.addedListings = const [],
    this.hasGroupChat = false,
  });

  /// Title-case status for display (e.g. "Confirmed").
  String get statusLabel => status.isEmpty
      ? 'Draft'
      : status[0].toUpperCase() + status.substring(1).toLowerCase();

  String get budgetRange {
    if (budgetMin == null && budgetMax == null) return '';
    final fmt = _fmt;
    if (budgetMax == null) return '${fmt(budgetMin!)}+';
    return '${fmt(budgetMin!)} - ${fmt(budgetMax!)}';
  }

  static String _fmt(double n) {
    final s = n.toInt().toString();
    final buf = StringBuffer('₦ ');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  List<Object?> get props => [id, clientId, name, date];
}
