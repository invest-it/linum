import 'package:easy_localization/easy_localization.dart';
import 'package:linum/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/enter_screen/enums/parsable_date.dart';

class DateFormatter {
  final String pattern;
  const DateFormatter({this.pattern = "dd.MM.yyyy"});

  String? format(String isoStr) {
    final date = DateTime.parse(isoStr);

    final now = DateTime.now();

    final yesterdayStart = DateTime(now.year, now.month, now.day - 1, 0, 0, -1);
    final yesterdayEnd = DateTime(now.year, now.month, now.day, 0, 0, -1);

    if (date.isBefore(yesterdayEnd) && date.isAfter(yesterdayStart)) {
      return parsableDateMap[ParsableDate.yesterday];
    }

    final todayEnd = DateTime(now.year, now.month, now.day + 1, 0, 0, -1);

    if (date.isBefore(todayEnd) && date.isAfter(yesterdayEnd)) {
      return parsableDateMap[ParsableDate.today];
    }

    final tomorrowEnd = DateTime(now.year, now.month, now.day + 2, 0, 0, -1);

    if (date.isBefore(tomorrowEnd) && date.isAfter(todayEnd)) {
      return parsableDateMap[ParsableDate.tomorrow];
    }

    final DateFormat formatter = DateFormat(pattern);
    return formatter.format(date);
  }
}
