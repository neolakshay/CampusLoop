/// Helper utilities for formatting activity dates and times on CampusLoop.
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  /// Formats date and time into e.g. "Mon, Oct 28 • 2:30 PM"
  static String formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final weekday = _weekdays[local.weekday - 1];
    final month = _months[local.month - 1];
    final day = local.day;
    final time = formatTime(local);
    return '$weekday, $month $day • $time';
  }

  /// Formats time in 12-hour format e.g. "2:30 PM"
  static String formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$formattedHour:$minute $period';
  }

  /// Relative friendly format e.g. "Today at 2:30 PM", "Tomorrow at 10:00 AM",
  /// or "Mon, Oct 28 at 2:30 PM"
  static String formatRelative(DateTime dateTime) {
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(local.year, local.month, local.day);
    final diffDays = targetDate.difference(today).inDays;

    final time = formatTime(local);
    if (diffDays == 0) {
      return 'Today at $time';
    } else if (diffDays == 1) {
      return 'Tomorrow at $time';
    } else if (diffDays == -1) {
      return 'Yesterday at $time';
    } else if (diffDays > 1 && diffDays < 7) {
      final weekday = _weekdays[local.weekday - 1];
      return '$weekday at $time';
    } else {
      final month = _months[local.month - 1];
      return '$month ${local.day} at $time';
    }
  }

  /// Formats a time range e.g. "2:30 PM - 4:00 PM" or "Oct 28, 2:30 PM - 4:00 PM"
  static String formatTimeRange(DateTime start, DateTime? end) {
    final startStr = formatDateTime(start);
    if (end == null) {
      return startStr;
    }
    final endLocal = end.toLocal();
    final startLocal = start.toLocal();
    final sameDay =
        startLocal.year == endLocal.year &&
        startLocal.month == endLocal.month &&
        startLocal.day == endLocal.day;

    if (sameDay) {
      return '$startStr - ${formatTime(endLocal)}';
    } else {
      return '$startStr to ${formatDateTime(endLocal)}';
    }
  }

  /// Returns readable duration string e.g. "1 hr", "1 hr 30 mins", "45 mins"
  static String? formatDuration(DateTime start, DateTime? end) {
    if (end == null) return null;
    final diff = end.difference(start);
    if (diff.isNegative) return null;
    final minutes = diff.inMinutes;
    if (minutes < 60) {
      return '$minutes min${minutes == 1 ? '' : 's'}';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr${hours == 1 ? '' : 's'}';
    }
    return '$hours hr${hours == 1 ? '' : 's'} $remainingMinutes min${remainingMinutes == 1 ? '' : 's'}';
  }
}
