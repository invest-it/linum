import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/parsing/tag_parser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/suggestion_functions.dart';

Map<String, Suggestion> makeSuggestions(String text, int cursor, {
  bool Function(Category category)? categoryFilter,
  bool Function(ParsableDate date)? dateFilter,
  bool Function(RepeatInterval repeatInterval)? repeatFilter,
}) {
  if (cursor < 0) {
    return {};
  }
  final textBefore = text.substring(0, cursor).split('#');
  // final textAfter = text.substring(cursor, text.length).split('#');
  if (textBefore.length == 1) {
    print("WTF");
    return {};
  }
  final preCursorText = textBefore[textBefore.length - 1];
  // final cursorText = preCursorText + textAfter[0];

  final parsed = TagParser().parse(preCursorText);
  if (parsed.flag == null) {
    final suggestions = suggestFlags(parsed.text);
    if (suggestions.isNotEmpty) {
      return suggestions;
    }

    final categorySuggestions = suggestCategory(
      parsed.text,
      filter: categoryFilter,
    );
    if (categorySuggestions.isNotEmpty) {
      return categorySuggestions;
    }
    final dateSuggestions = suggestDate(
      parsed.text,
      filter: dateFilter,
    );
    if (dateSuggestions.isNotEmpty) {
      return dateSuggestions;
    }
    final repeatSuggestions = suggestRepeatInfo(
      parsed.text,
      filter: repeatFilter,
    );
    if (repeatSuggestions.isNotEmpty) {
      return repeatSuggestions;
    }
    return {};
  }

  switch (parsed.flag) {
    case InputFlag.category:
      return suggestCategory(parsed.text, filter: categoryFilter);
    case InputFlag.date:


      return suggestDate(parsed.text, filter: dateFilter);
    case InputFlag.repeatInfo:
      return suggestRepeatInfo(parsed.text, filter: repeatFilter);
    default:
      return suggestCategory(parsed.text, filter: categoryFilter);
  }
}
