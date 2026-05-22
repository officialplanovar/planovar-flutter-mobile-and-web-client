import 'package:equatable/equatable.dart';

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
  });

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
