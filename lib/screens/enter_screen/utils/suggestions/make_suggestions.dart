import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/input_parser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/suggestion_functions.dart';

Map<String, Suggestion> makeSuggestions(String text, int cursor, {
  bool Function(Category category)? categoryFilter,
  bool Function(ParsableDate date)? dateFilter,
  bool Function(RepeatInterval repeatInterval)? repeatFilter,
}) {
  final textBefore = text.substring(0, cursor).split('#');
  // final textAfter = text.substring(cursor, text.length).split('#');
  if (textBefore.length == 1) {
    return {};
  }
  final preCursorText = textBefore[textBefore.length - 1];
  // final cursorText = preCursorText + textAfter[0];

  final parsed = parseTag(preCursorText);
  if (parsed.item1 == null) {
    final suggestions = suggestFlags(parsed.item2);
    if (suggestions.isNotEmpty) {
      return suggestions;
    }

    final categorySuggestions = suggestCategory(
      parsed.item2,
      filter: categoryFilter,
    );
    if (categorySuggestions.isNotEmpty) {
      return categorySuggestions;
    }
    final dateSuggestions = suggestDate(
      parsed.item2,
      filter: dateFilter,
    );
    if (dateSuggestions.isNotEmpty) {
      return dateSuggestions;
    }
    final repeatSuggestions = suggestRepeatInfo(
      parsed.item2,
      filter: repeatFilter,
    );
    if (repeatSuggestions.isNotEmpty) {
      return repeatSuggestions;
    }
    return {};
  }

  switch (parsed.item1) {
    case InputFlag.category:
      return suggestCategory(parsed.item2, filter: categoryFilter);
    case InputFlag.date:
      return suggestDate(parsed.item2, filter: dateFilter);
    case InputFlag.repeatInfo:
      return suggestRepeatInfo(parsed.item2, filter: repeatFilter);
    default:
      return suggestCategory(parsed.item2, filter: categoryFilter);
  }
}
