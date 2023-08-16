import 'package:linum/common/types/filter_function.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/utils/parsing/parser.dart';
import 'package:linum/screens/enter_screen/utils/special_dates.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';

final _dateRegExps = <String, RegExp>{
  "d/m/y": RegExp(
    r'^(0?[1-9]|[1-2][0-9]|30|31)[,.|/-](1[0-2]|0?[1-9])[,.|/-]?(20[1-9][0-9]|[1-9][0-9])? ?$',),
  "m/d/y": RegExp(
    r'^(1[0-2]|0?[1-9])[,.|/-](0?[1-9]|[1-2][0-9]|30|31)[,.|/-]?(20[1-9][0-9]|[1-9][0-9])? ?$',)
};


class DateParser implements IParser<String> {
  final Filter<ParsableDate>? filter;

  DateParser({
    this.filter,
  });

  @override
  String? parse(String input) {
    final lowercase = input.trim().toLowerCase();

    // TODO: Implement date filters
    if (filter != null) {
      throw Exception("Filters not implemented for dates yet!");
    }

    // TODO: UNDO THIS
    final parsableDate = SupportedValues.dates[lowercase];

    switch (parsableDate) {
      case ParsableDate.today:
        return SpecialDates.today().toIso8601String();
      case ParsableDate.tomorrow:
        return SpecialDates.tomorrow().toIso8601String();
      case ParsableDate.yesterday:
        return SpecialDates.yesterday().toIso8601String();
      default:
        if (parsableDate != null) {
          return getLastWeekdayDate(parsableDate);
        }
        return tryDateFormats(input, "d/m/y"); // TODO: Depend on localization
    }
  }


  String? tryDateFormats(String input, String format) {
    final trimmed = input.trim();
    final result = DateTime.tryParse(trimmed);
    if (result != null) {
      return result.toIso8601String();
    }
    final regex = _dateRegExps[format]!;
    final match = regex.firstMatch(trimmed);
    if (match == null) {
      return null;
    }

    final yearNow = DateTime.now().year;
    switch (format) {
      case "d/m/y":
        return DateTime(
          int.tryParse(match.group(3) ?? "f") ?? yearNow,
          int.tryParse(match.group(2) ?? "f") ?? 1,
          int.tryParse(match.group(1) ?? "f") ?? 1,
        ).toIso8601String();
      case "m/d/y":
        return DateTime(
          int.tryParse(match.group(3) ?? "f") ?? yearNow,
          int.tryParse(match.group(1) ?? "f") ?? 1,
          int.tryParse(match.group(2) ?? "f") ?? 1,
        ).toIso8601String();
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

}
