import 'package:easy_localization/easy_localization.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/utils/date_utils.dart';

class DateFormatter {
  final String pattern;
  const DateFormatter({this.pattern = "dd.MM.yyyy"});

  String? format(String isoStr) {
    final date = DateTime.parse(isoStr);

    if (date.isYesterday()) {
      return parsableDateMap[ParsableDate.yesterday];
    }

    if (date.isToday()) {
      return parsableDateMap[ParsableDate.today];
    }

    if (date.isTomorrow()) {
      return parsableDateMap[ParsableDate.tomorrow];
    }

    final DateFormat formatter = DateFormat(pattern);
    return formatter.format(date);
  }
}
