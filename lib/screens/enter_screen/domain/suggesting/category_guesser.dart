import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion.dart';
import 'package:linum/screens/enter_screen/domain/suggesting/guesser.dart';

class CategoryGuesser implements IGuesser {
  final ITranslator translator;
  final Filter<Category>? filter;

  CategoryGuesser({
    required this.translator,
    required this.filter,
  });

  @override
  Map<String, Suggestion> suggest(String text) {
    final Map<String, Suggestion> suggestions = {};
    final lowercase = text.toLowerCase();

    for (final entry in standardCategories.entries) {
      if (filter != null && filter!(entry.value)) {
        continue;
      }
      String? valueSubstring;
      final translatedLabel = translator
          .translate(entry.value.label)
          .toLowerCase();

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

}
