import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';
import 'package:linum/screens/enter_screen/domain/parsing/parser.dart';

// Testable
class CategoryParser implements IParser<Category> {
  final ITranslator translator;
  final Filter<Category>? filter;
  final CategoryMap categories;

  CategoryParser({
    required this.translator,
    required this.filter,
    required this.categories,
  });

  @override
  Category? parse(String input) {

    final lowercase = input.trim().toLowerCase();
    final filteredCategories = categories.entries
        .where((element) => filter == null || filter!(element.value));

    for (final entry in filteredCategories) {
      if (lowercase == entry.key) {
        return categories.getCategory(entry.key);
      }
      final label = translator.translate(entry.value.label).toLowerCase();
      if (lowercase == label) {
        return categories.getCategory(entry.key);
      }
    }
    return null;
  }
}
