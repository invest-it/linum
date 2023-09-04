import 'package:linum/screens/enter_screen/domain/enums/parsable_date.dart';

final parsableDateMap = <ParsableDate, String>{
  ParsableDate.sunday: "enter_screen.date.sunday",
  ParsableDate.monday: "enter_screen.date.monday",
  ParsableDate.tuesday: "enter_screen.date.tuesday",
  ParsableDate.wednesday: "enter_screen.date.wednesday",
  ParsableDate.thursday: "enter_screen.date.thursday",
  ParsableDate.friday: "enter_screen.date.friday",
  ParsableDate.saturday: "enter_screen.date.saturday",
  ParsableDate.yesterday: "enter_screen.special_date.yesterday",
  ParsableDate.tomorrow: "enter_screen.special_date.tomorrow",
  ParsableDate.today: "enter_screen.special_date.today"
};

final dateTimeWeekDayMap = <ParsableDate, int>{
  ParsableDate.sunday: DateTime.sunday,
  ParsableDate.monday: DateTime.monday,
  ParsableDate.tuesday: DateTime.tuesday,
  ParsableDate.wednesday: DateTime.wednesday,
  ParsableDate.thursday: DateTime.thursday,
  ParsableDate.friday: DateTime.friday,
  ParsableDate.saturday: DateTime.saturday,
};
