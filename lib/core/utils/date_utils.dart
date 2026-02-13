class AppDateUtils {
  static DateTime now() => DateTime.now();
  
  static bool shouldUpdate(int lastUpdateTimestamp) {
    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateTimestamp);
    final difference = now().difference(lastUpdate);
    return difference.inHours >= 24;
  }
  
  static int getCurrentTimestamp() {
    return now().millisecondsSinceEpoch;
  }
  
  static DateTime getDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  static DateTime subtractDays(int days) {
    return now().subtract(Duration(days: days));
  }
  
  static List<DateTime> getDayRange(int days) {
    final List<DateTime> dates = [];
    for (int i = days - 1; i >= 0; i--) {
      dates.add(getDateOnly(subtractDays(i)));
    }
    return dates;
  }
}