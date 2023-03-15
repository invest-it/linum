import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:linum/enter_screen/models/suggestion.dart';
import 'package:linum/enter_screen/utils/input_parser.dart';
import 'package:linum/enter_screen/utils/suggestions/suggestion_functions.dart';

Map<String, Suggestion> makeSuggestions(String text, int cursor) {
  final textBefore = text.substring(0, cursor).split('#');
  final textAfter = text.substring(cursor, text.length).split('#');
  if (textBefore.length == 1) {
    return {};
  }
  final preCursorText = textBefore[textBefore.length - 1];
  final cursorText = preCursorText + textAfter[0];

  final parsed = parseTag(preCursorText);
  if (parsed.item1 == null) {
    final suggestions = suggestFlags(parsed.item2);
    if (suggestions.isNotEmpty) {
      return suggestions;
    } else {
      return suggestCategory(parsed.item2);
    }
  }

  switch (parsed.item1) {
    case InputFlag.category:
      return suggestCategory(parsed.item2);
    case InputFlag.date:
      return suggestDate(parsed.item2);
    case InputFlag.repeatInfo:
      return suggestRepeatInfo(parsed.item2);
    default:
      return suggestCategory(parsed.item2);
  }
}
