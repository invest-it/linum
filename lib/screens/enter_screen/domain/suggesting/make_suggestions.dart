import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/screens/enter_screen/domain/constants/input_flag_map.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/domain/enums/parsable_date.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';
import 'package:linum/screens/enter_screen/domain/parsing/tag_parser.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/category_guesser.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/date_guesser.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/flag_guesser.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/repeat_config_guesser.dart';

Map<String, Suggestion> makeSuggestions({
  required String text,
  required int cursor,
  required ITranslator translator,
  required CategoryMapIterable categoriesToSuggest,
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
    categoriesToSuggest: categoriesToSuggest,
  );
  final dateGuesser = DateGuesser(filter: dateFilter);
  final flagGuesser = FlagGuesser(getInputFlagMap(translator));
  final repeatGuesser = RepeatConfigGuesser(filter: repeatFilter);

  final parsed = TagParser(getInputFlagMap(translator)).parse(preCursorText);
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
