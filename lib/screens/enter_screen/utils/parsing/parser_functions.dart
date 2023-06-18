import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/utils/parsing/date_parsing.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';

typedef ParserFunction = String? Function(String input);

String? _categoryParser(String input) {
  final lowercase = input.trim().toLowerCase();
  for (final entry in standardCategories.entries) {
    if (lowercase == entry.key) {
      return entry.key;
    }
    final label = entry.value.label.tr().toLowerCase();
    if (lowercase == label) {
      return entry.key;
    }
  }
  return null;
}

String? _repeatInfoParser(String input) {
  final lowercase = input.trim().toLowerCase();
  final repeatInterval = SupportedValues.repeatIntervals[lowercase];

  return repeatInterval?.name;
}

String? _dateParser(String input) {
  final lowercase = input.trim().toLowerCase();
  final today = DateTime.now();

  final parsableDate = SupportedValues.dates[lowercase];

  switch (parsableDate) {
    case ParsableDate.today:
      return today.toIso8601String();
    case ParsableDate.tomorrow:
      return DateTime(today.year, today.month, today.day + 1).toIso8601String();
    case ParsableDate.yesterday:
      return DateTime(today.year, today.month, today.day - 1).toIso8601String();
    default:
      if (parsableDate != null) {
        return getLastWeekdayDate(parsableDate);
      }
      return tryDateFormats(input, "d/m/y"); // TODO: Depend on localization
  }
}

({InputFlag flag, String value})? findFitting(String text) {
  var result = _categoryParser(text);
  if (result != null) {
    return (
      flag: InputFlag.category,
      value: result,
    );
  }
  result = _repeatInfoParser(text);
  if (result != null) {
    return (
      flag: InputFlag.repeatInfo,
      value: result,
    );
  }
  result = _dateParser(text);
  if (result != null) {
    return (
      flag: InputFlag.date,
      value: result,
    );
  }
  return null;
}

const parserFunctions = <InputFlag, ParserFunction>{
  InputFlag.category: _categoryParser,
  InputFlag.date: _dateParser,
  InputFlag.repeatInfo: _repeatInfoParser,
};
