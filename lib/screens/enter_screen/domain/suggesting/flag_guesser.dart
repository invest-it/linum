import 'package:linum/screens/enter_screen/domain/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';

class FlagGuesser {
  final Map<String, InputFlag> flagMap;

  FlagGuesser(this.flagMap);

  Map<String, Suggestion> guess(String text) {
    final Map<String, Suggestion> suggestions = {};
    final uppercase = text.toUpperCase();
    for (final entry in flagMap.entries) {
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

}
