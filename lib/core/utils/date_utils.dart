import '../constants/app_constants.dart';

class AppDateUtils {
  static DateTime now() {
    return DateTime.now();
  }
  
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
  
  static DateTime getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static List<DateTime> getDayRange(DateTime start, DateTime end) {
    List<DateTime> days = [];
    DateTime current = getDateOnly(start);
    DateTime endDate = getDateOnly(end);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    
    return days;
  }
  
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  static bool shouldUpdate(int? lastUpdateTimestamp) {
    if (lastUpdateTimestamp == null) return true;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final difference = now - lastUpdateTimestamp;
    
    return difference >= AppConstants.updateIntervalMilliseconds;
  }

  static String getLastUpdateText(int? timestamp) {
    if (timestamp == null) return 'Never updated';
    
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  

  static String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static List<DateTime> getLast7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));
  }

  static List<DateTime> getLast30Days() {
    final now = DateTime.now();
    return List.generate(30, (index) => now.subtract(Duration(days: 29 - index)));
  }

  static List<DateTime> getLast90Days() {
    final now = DateTime.now();
    return List.generate(90, (index) => now.subtract(Duration(days: 89 - index)));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static int getDaysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}