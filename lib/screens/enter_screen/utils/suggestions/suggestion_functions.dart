import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/screens/enter_screen/constants/input_flag_map.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/supported_dates.dart';
import 'package:linum/screens/enter_screen/utils/supported_repeat_configs.dart';

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

Map<String, Suggestion> suggestCategory(String text) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();
  for (final entry in standardCategories.entries) {
    String? valueSubstr;
    final translatedLabel = entry.value.label.tr().toLowerCase();
    if (translatedLabel.length > text.length) {
      valueSubstr = translatedLabel.substring(0, text.length);
    }

    String? keySubstr;
    if (entry.key.length > text.length) {
      keySubstr = entry.key.substring(0, text.length);
    }

    if (keySubstr == lowercase || valueSubstr == lowercase) {
      suggestions[entry.key] = Suggestion(
        label: entry.value.label,
      );
    }
  }

  return suggestions;
}

Map<String, Suggestion> suggestDate(String text) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();

  for (final entry in supportedDates.entries) {
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

Map<String, Suggestion> suggestRepeatInfo(String text) {
  final Map<String, Suggestion> suggestions = {};
  final lowercase = text.toLowerCase();

  for (final entry in supportedRepeatIntervals.entries) {
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
