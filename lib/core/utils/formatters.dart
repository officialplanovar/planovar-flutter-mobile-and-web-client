import 'package:intl/intl.dart';

class Formatters {
  static final _currencyFormat = NumberFormat('#,###', 'en_NG');
  static final _dateFormat = DateFormat('d MMM yyyy');
  static final _shortDateFormat = DateFormat('d MMM');
  static final _timeFormat = DateFormat('h:mm a');
  static final _monthYearFormat = DateFormat('MMM yyyy');

  static String currency(double amount) {
    return '₦${_currencyFormat.format(amount.toInt())}';
  }

  static String date(DateTime date) {
    return _dateFormat.format(date);
  }

  static String shortDate(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String time(DateTime time) {
    return _timeFormat.format(time);
  }

  static String monthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return _shortDateFormat.format(dateTime);
  }

  static String messageTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) return _timeFormat.format(dateTime);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return DateFormat('EEEE').format(dateTime);
    return _shortDateFormat.format(dateTime);
  }
}
