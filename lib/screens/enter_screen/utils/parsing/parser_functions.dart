import 'package:easy_localization/easy_localization.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/utils/parsing/date_parsing.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';


String? categoryParser(String input, {Filter<Category>? filter}) {
  final lowercase = input.trim().toLowerCase();
  final filteredCategories = standardCategories.entries
      .where((element) => filter == null || filter(element.value));


  for (final entry in filteredCategories) {
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

String? repeatInfoParser(String input, {Filter<RepeatInterval>? filter}) {
  final lowercase = input.trim().toLowerCase();
  final repeatInterval = SupportedValues.repeatIntervals[lowercase];
  if (repeatInterval == null) {
    return null;
  }

  if (filter == null || filter(repeatInterval)) {
    return repeatInterval.name;
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

({InputFlag flag, String value})? findFitting(String text, {
  Filter<Category>? categoryFilter,
  Filter<RepeatInterval>? repeatFilter,
  Filter<ParsableDate>? dateFilter,
}) {
  var result = categoryParser(text, filter: categoryFilter);
  if (result != null) {
    return (
      flag: InputFlag.category,
      value: result,
    );
  }
  result = repeatInfoParser(text, filter: repeatFilter);
  if (result != null) {
    return (
      flag: InputFlag.repeatInfo,
      value: result,
    );
  }
  result = dateParser(text, filter: dateFilter);
  if (result != null) {
    return (
      flag: InputFlag.date,
      value: result,
    );
  }
  return null;
}
