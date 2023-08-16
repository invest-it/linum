import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/models/suggestion.dart';
import 'package:linum/screens/enter_screen/utils/parsing/tag_parser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/category_guesser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/date_guesser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/flag_guesser.dart';
import 'package:linum/screens/enter_screen/utils/suggestions/repeat_config_guesser.dart';

Map<String, Suggestion> makeSuggestions({
  required String text,
  required int cursor,
  required ITranslator translator,
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
    return {};
  }
  final preCursorText = textBefore[textBefore.length - 1];
  // final cursorText = preCursorText + textAfter[0];

  final categoryGuesser = CategoryGuesser(
    translator: translator,
    filter: categoryFilter,
  );
  final dateGuesser = DateGuesser(filter: dateFilter);
  final flagGuesser = FlagGuesser();
  final repeatGuesser = RepeatConfigGuesser(filter: repeatFilter);


  final parsed = TagParser().parse(preCursorText);
  if (parsed.flag == null) {
    final suggestions = flagGuesser.guess(parsed.text);
    if (suggestions.isNotEmpty) {
      return suggestions;
    }

    final categorySuggestions = categoryGuesser.suggest(parsed.text);

    if (categorySuggestions.isNotEmpty) {
      return categorySuggestions;
    }

    final dateSuggestions = dateGuesser.suggest(parsed.text);

    if (dateSuggestions.isNotEmpty) {
      return dateSuggestions;
    }

    final repeatSuggestions = repeatGuesser.suggest(parsed.text);

    if (repeatSuggestions.isNotEmpty) {
      return repeatSuggestions;
    }
    return {};
  }

  switch (parsed.flag) {
    case InputFlag.category:
      return categoryGuesser.suggest(parsed.text);
    case InputFlag.date:
      return dateGuesser.suggest(parsed.text);
    case InputFlag.repeatInfo:
      return repeatGuesser.suggest(parsed.text);
    default:
      return categoryGuesser.suggest(parsed.text);
  }
}
