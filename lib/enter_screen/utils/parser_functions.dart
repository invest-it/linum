import 'package:easy_localization/easy_localization.dart';
import 'package:linum/constants/standard_categories.dart';
import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:linum/enter_screen/enums/parsable_date.dart';
import 'package:linum/enter_screen/utils/date_parsing.dart';
import 'package:linum/enter_screen/utils/supported_dates.dart';
import 'package:linum/enter_screen/utils/supported_repeat_configs.dart';
import 'package:tuple/tuple.dart';

typedef ParserFunction = String? Function(String input);

String? _categoryParser(String input) {
  final lowercase = input.trim().toLowerCase();
  for (final entry in standardCategories.entries) {
    if (lowercase == entry.key) {
      return entry.key;
    }
    final label = entry.value.label.tr().toLowerCase(); // TODO: Translate first
    if (lowercase == label) {
      return entry.key;
    }
  }
  return null;
}

String? _repeatInfoParser(String input) {
  final lowercase = input.trim().toLowerCase();
  final repeatInterval = supportedRepeatIntervals[lowercase];

  return repeatInterval?.name;
}

String? _dateParser(String input) {
  final lowercase = input.trim().toLowerCase();
  final today = DateTime.now();

  final parsableDate = supportedDates[lowercase];

  switch (parsableDate) {
    case ParsableDate.today:
      return today.toIso8601String(); // TODO: Correct format?
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

Tuple2<InputFlag, String>? findFitting(String input) {
  var result = _categoryParser(input);
  if (result != null) {
    return Tuple2(InputFlag.category, result);
  }
  result = _repeatInfoParser(input);
  if (result != null) {
    return Tuple2(InputFlag.repeatInfo, result);
  }
  result = _dateParser(input);
  if (result != null) {
    return Tuple2(InputFlag.date, result);
  }
  return null;
}

const parserFunctions = <InputFlag, ParserFunction>{
  InputFlag.category: _categoryParser,
  InputFlag.date: _dateParser,
  InputFlag.repeatInfo: _repeatInfoParser,
};
