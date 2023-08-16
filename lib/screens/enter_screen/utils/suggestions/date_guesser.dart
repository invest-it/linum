import 'package:linum/common/types/filter_function.dart';
import 'package:linum/screens/enter_screen/constants/parsable_date_map.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/guesser.dart';
import 'package:linum/screens/enter_screen/utils/supported_values.dart';

class DateGuesser implements IGuesser {
  final Filter<ParsableDate>? filter;

  DateGuesser({
    required this.filter,
  });

  @override
  Map<String, Suggestion> suggest(String text) {
    final Map<String, Suggestion> suggestions = {};
    final lowercase = text.toLowerCase();

    for (final entry in SupportedValues.dates.entries) {
      if (filter != null && filter!(entry.value)) {
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

}