import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Formatting Extensions
  String get toDateString => DateFormat('dd/MM/yyyy').format(this);
  String get toTimeString => DateFormat('HH:mm').format(this);
  String get toDateTimeString => DateFormat('dd/MM/yyyy HH:mm').format(this);
  String get toIsoString => toIso8601String();

  // Custom Formats
  String toCustomFormat(String pattern) => DateFormat(pattern).format(this);
  String get toMonthYear => DateFormat('MMMM yyyy').format(this);
  String get toDayMonth => DateFormat('dd MMMM').format(this);
  String get toShortDate => DateFormat('dd/MM/yy').format(this);

  // Relative Time
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // Date Calculations
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);
  DateTime get startOfYear => DateTime(year, 1, 1);
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  // Week calculations
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday)).endOfDay;
  }

  // Comparisons
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  bool get isToday => isSameDay(DateTime.now());
  bool get isYesterday =>
      isSameDay(DateTime.now().subtract(const Duration(days: 1)));
  bool get isTomorrow => isSameDay(DateTime.now().add(const Duration(days: 1)));

  // Age calculation
  int ageFrom(DateTime birthDate) {
    int age = year - birthDate.year;
    if (month < birthDate.month ||
        (month == birthDate.month && day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
