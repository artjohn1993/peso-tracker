import 'package:intl/intl.dart';
//reference
//https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html

class CalendarUtil {
  CalendarUtil._();

  static String getmonthDayYear(DateTime date) {
    return DateFormat.yMMMMd().format(date).toString();
  }

  static String getmonthYear(DateTime date) {
    return DateFormat.yMMMM().format(date).toString();
  }

  static String get month {
    var date = DateTime.now();
    return DateFormat.MMMM().format(date).toString();
  }

  static String getYearMonthDay(DateTime date) {
    return DateFormat.yMMMMd().format(date).toString();
  }

  static List<DateTime> get weekday {
    List<DateTime> list = [];
    var date = DateTime.now();

    // Get the starting day of the week (Sunday)
    var startOfWeek = date.subtract(Duration(days: date.weekday));

    for (var day = 0; day < 7; day++) {
      list.add(startOfWeek.add(Duration(days: day)));
    }

    return list;
  }
}
