import 'package:linum/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/enter_screen/enums/parsable_date.dart';

final _dateRegExps = <String, RegExp>{
  "d/m/y": RegExp(
      r'^(0?[1-9]|[1-2][0-9]|30|31)[,.|/-](1[0-2]|0?[1-9])[,.|/-]?(20[1-9][0-9]|[1-9][0-9])? ?$'),
  "m/d/y": RegExp(
      r'^(1[0-2]|0?[1-9])[,.|/-](0?[1-9]|[1-2][0-9]|30|31)[,.|/-]?(20[1-9][0-9]|[1-9][0-9])? ?$')
};

String? tryDateFormats(String input, String format) {
  input = input.trim();
  var result = DateTime.tryParse(input);
  if (result != null) {
    return result.toIso8601String();
  }
  final regex = _dateRegExps[format]!;
  final match = regex.firstMatch(input);
  if (match == null) {
    return null;
  }

  final yearNow = DateTime.now().year;
  switch (format) {
    case "d/m/y":
      return DateTime(
              int.tryParse(match.group(3) ?? "f") ?? yearNow,
              int.tryParse(match.group(2) ?? "f") ?? 1,
              int.tryParse(match.group(1) ?? "f") ?? 1)
          .toIso8601String();
    case "m/d/y":
      return DateTime(
              int.tryParse(match.group(3) ?? "f") ?? yearNow,
              int.tryParse(match.group(1) ?? "f") ?? 1,
              int.tryParse(match.group(2) ?? "f") ?? 1)
          .toIso8601String();
  }
  return null;
}

String? getLastWeekdayDate(ParsableDate weekday) {
  final weekdayNumber = dateTimeWeekDayMap[weekday];
  if (weekdayNumber == null) {
    return null;
  }
  final now = DateTime.now();
  final diff = now.weekday - weekdayNumber;

  return DateTime(
    now.year,
    now.month,
    diff > 0 ? now.day - diff : now.day - 7 - diff,
  ).toIso8601String();
}
