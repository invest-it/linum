import 'package:easy_localization/easy_localization.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/utils/parsing/date_parsing.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';


Category? categoryParser(String input, {Filter<Category>? filter}) {
  final lowercase = input.trim().toLowerCase();
  final filteredCategories = standardCategories.entries
      .where((element) => filter == null || filter(element.value));


  for (final entry in filteredCategories) {
    if (lowercase == entry.key) {
      return getCategory(entry.key);
    }
    final label = entry.value.label.tr().toLowerCase();
    if (lowercase == label) {
      return getCategory(entry.key);
    }
  }
  return null;
}

RepeatConfiguration? repeatInfoParser(String input, {Filter<RepeatInterval>? filter}) {
  final lowercase = input.trim().toLowerCase();
  final repeatInterval = SupportedValues.repeatIntervals[lowercase];
  if (repeatInterval == null) {
    return null;
  }

  if (filter == null || filter(repeatInterval)) {
    return repeatConfigurations[repeatInterval];
  }

  return null;
}

String? dateParser(String input, {Filter<ParsableDate>? filter}) {
  final lowercase = input.trim().toLowerCase();
  final today = DateTime.now();

  // TODO: Implement date filters
  if (filter != null) {
    throw Exception("Filters not implemented for dates yet!");
  }

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


