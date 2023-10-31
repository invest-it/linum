import 'package:linum/screens/enter_screen/domain/formatting/special_dates.dart';

extension DateUtils on DateTime {
  bool isYesterday() {
    return isBefore(SpecialDates.today())
        && !isBefore(SpecialDates.yesterday());
  }

  bool isToday() {
    return isBefore(SpecialDates.tomorrow())
        && !isBefore(SpecialDates.today());
  }

  bool isTomorrow() {
    return isBefore(SpecialDates.dayAfterTomorrow())
        && !isBefore(SpecialDates.tomorrow());
  }
}
