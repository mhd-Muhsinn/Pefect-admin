import 'package:cloud_firestore/cloud_firestore.dart';

class MessageUtils {
  /// Converts firestore/string/datetime into DateTime
  static DateTime parseTimestamp(dynamic ts) {
    if (ts is Timestamp) return ts.toDate();
    if (ts is String) return DateTime.parse(ts);
    if (ts is DateTime) return ts;
    return DateTime.now();
  }

  static String formatTime(Timestamp timestamp) {
    try {
      DateTime dateTime;

        dateTime = timestamp.toDate();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } catch (e) {
      return '00:00';
    }
  }

  /// Return `yyyy-MM-dd` for comparing dates
  static String dateKey(dynamic ts) {
    final date = parseTimestamp(ts);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// Returns Today / Yesterday / Monday / 12 Jan 2025
  static String dateLabel(dynamic ts) {
    final date = parseTimestamp(ts);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDay = DateTime(date.year, date.month, date.day);

    if (messageDay == today) return "Today";
    if (messageDay == yesterday) return "Yesterday";

    final diff = now.difference(messageDay).inDays;
    if (diff < 7) {
      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return days[date.weekday - 1];
    }

    const months = [
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
      'Dec'
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  /// Determines if a date separator should appear
  /// Now checks if the NEXT message has a different date
  static bool shouldShowDateSeparator({
    required int currIndex,
    required List messages,
  }) {
    if (currIndex == messages.length - 1) return true;

    final current = dateKey(messages[currIndex]["timestamp"]);
    final next = dateKey(messages[currIndex + 1]["timestamp"]);

    // Show separator when the date changes from current to next (older) message
    return current != next;
  }
}