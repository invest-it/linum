import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/guesser.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';

class RepeatConfigGuesser implements IGuesser {
  final Filter<RepeatInterval>? filter;

  RepeatConfigGuesser({
    required this.filter,
  });


  @override
  Map<String, Suggestion> suggest(String text) {
    final Map<String, Suggestion> suggestions = {};
    final lowercase = text.toLowerCase();

    for (final entry in SupportedValues.repeatIntervals.entries) {
      if (filter != null && filter!(entry.value)) {
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

}