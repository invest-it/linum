import 'package:easy_localization/easy_localization.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/utils/parsing/date_parsing.dart';
import 'package:linum/screens/enter_screen/utils/special_dates.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';


Category? parsedCategory(String input, {Filter<Category>? filter}) {
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

RepeatConfiguration? parseRepeatConfiguration(String input, {Filter<RepeatInterval>? filter}) {
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

String? parsedDate(String input, {Filter<ParsableDate>? filter}) {
  final lowercase = input.trim().toLowerCase();

  // TODO: Implement date filters
  if (filter != null) {
    throw Exception("Filters not implemented for dates yet!");
  }

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
