import 'package:intl/intl.dart';

class DatePickerHelper {
  static DateTime fetchNextMonday() {
    final currentDate = DateTime.now();
    int daysToNextMonday = (DateTime.monday - currentDate.weekday + 7) % 7;
    return currentDate
        .add(Duration(days: daysToNextMonday == 0 ? 7 : daysToNextMonday));
  }

  static DateTime fetchNextTuesday() {
    final today = DateTime.now();
    int daysToNextTuesday = (DateTime.tuesday - today.weekday + 7) % 7;
    return today
        .add(Duration(days: daysToNextTuesday == 0 ? 7 : daysToNextTuesday));
  }

  static DateTime getWeekAheadDate() {
    return DateTime.now().add(const Duration(days: 7));
  }

  static String formatDate(DateTime? date) {
    final currentDay = DateTime.now();
    if (date == null) return 'No Date';

    final isToday = date.year == currentDay.year &&
        date.month == currentDay.month &&
        date.day == currentDay.day;

    return isToday ? 'Today' : DateFormat('dd MMM yyyy').format(date);
  }
}
