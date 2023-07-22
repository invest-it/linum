import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/constants/input_flag_map.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';

Map<String, Suggestion> suggestFlags(String text) {
  final Map<String, Suggestion> suggestions = {};
  final uppercase = text.toUpperCase();
  for (final entry in inputFlagMap.entries) {
    String? keySubstr;
    if (entry.key.length > text.length) {
      keySubstr = entry.key.substring(0, text.length);
    }
    if (keySubstr == uppercase) {
      suggestions[entry.value.name] = Suggestion(
        label: flagSuggestionDefaults[entry.value],
        flag: entry.value,
      );
    }
  }
  return suggestions;
}

Map<String, Suggestion> suggestCategory(String text, {
  bool Function(Category category)? filter,
}) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();

  for (final entry in standardCategories.entries) {
    if (filter != null && !filter(entry.value)) {
      continue;
    }
    String? valueSubstring;
    final translatedLabel = entry.value.label.tr().toLowerCase();
    if (translatedLabel.length > text.length) {
      valueSubstring = translatedLabel.substring(0, text.length);
    }

    String? keySubstring;
    if (entry.key.length > text.length) {
      keySubstring = entry.key.substring(0, text.length);
    }

    if (keySubstring == lowercase || valueSubstring == lowercase) {
      suggestions[entry.key] = Suggestion(
        label: entry.value.label,
      );
    }
  }

  return suggestions;
}

Map<String, Suggestion> suggestDate(String text, {
  bool Function(ParsableDate date)? filter,
}) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();

  for (final entry in SupportedValues.dates.entries) {
    if (filter != null && !filter(entry.value)) {
      continue;
    }

    String? substr;
    if (entry.key.length > text.length) {
      substr = entry.key.substring(0, text.length);
    }

    if (substr == lowercase && parsableDateMap[entry.value] != null) {
      suggestions[entry.value.name] = Suggestion(
        label: parsableDateMap[entry.value],
      );
    }
  }

  return suggestions;
}

Map<String, Suggestion> suggestRepeatInfo(String text, {
  bool Function(RepeatInterval repeatInterval)? filter,
}) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();

  for (final entry in SupportedValues.repeatIntervals.entries) {
    if (filter != null && !filter(entry.value)) {
      continue;
    }

    String? substr;
    if (entry.key.length > text.length) {
      substr = entry.key.substring(0, text.length);
    }

    if (substr == lowercase && repeatConfigurations[entry.value] != null) {
      suggestions[entry.value.name] = Suggestion(
        label: repeatConfigurations[entry.value]?.label,
      );
    }
  }

  return suggestions;
}

/*bool suggestionIsFlag(String suggestion) {
  final flag = flagSuggestionDefaults.keys
      .firstWhereOrNull((key) => key.name == suggestion);
  return flag != null;
}*/
