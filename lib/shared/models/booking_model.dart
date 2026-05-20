import 'package:equatable/equatable.dart';
import 'vendor_model.dart';
import 'listing_model.dart';

class BookingModel extends Equatable {
  final String id;
  final String clientId;
  final String vendorId;
  final VendorModel? vendor;
  final String listingId;
  final ListingModel? listing;
  final String status;
  final DateTime eventDate;
  final String? eventLocation;
  final String? requirements;
  final double? quoteAmount;
  final double? finalAmount;

  const BookingModel({
    required this.id,
    required this.clientId,
    required this.vendorId,
    this.vendor,
    required this.listingId,
    this.listing,
    required this.status,
    required this.eventDate,
    this.eventLocation,
    this.requirements,
    this.quoteAmount,
    this.finalAmount,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      vendorId: json['vendorId'] as String,
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor'] as Map<String, dynamic>) : null,
      listingId: json['listingId'] as String,
      listing: json['listing'] != null ? ListingModel.fromJson(json['listing'] as Map<String, dynamic>) : null,
      status: json['status'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventLocation: json['eventLocation'] as String?,
      requirements: json['requirements'] as String?,
      quoteAmount: json['quoteAmount'] != null ? (json['quoteAmount'] as num).toDouble() : null,
      finalAmount: json['finalAmount'] != null ? (json['finalAmount'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'vendorId': vendorId,
        'vendor': vendor?.toJson(),
        'listingId': listingId,
        'listing': listing?.toJson(),
        'status': status,
        'eventDate': eventDate.toIso8601String(),
        'eventLocation': eventLocation,
        'requirements': requirements,
        'quoteAmount': quoteAmount,
        'finalAmount': finalAmount,
      };

  @override
  List<Object?> get props => [id, clientId, vendorId, listingId, status, eventDate];
}
