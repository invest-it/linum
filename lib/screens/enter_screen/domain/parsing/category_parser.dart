import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/common/types/filter_function.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/screens/enter_screen/domain/parsing/parser.dart';

class CategoryParser implements IParser<Category> {
  final ITranslator translator;
  final Filter<Category>? filter;

  CategoryParser({
    required this.translator,
    required this.filter,
  });

  @override
  Category? parse(String input) {
    final lowercase = input.trim().toLowerCase();
    final filteredCategories = standardCategories.entries
        .where((element) => filter == null || filter!(element.value));


    for (final entry in filteredCategories) {
      if (lowercase == entry.key) {
        return getCategory(entry.key);
      }
      final label = translator.translate(entry.value.label).toLowerCase();
      if (lowercase == label) {
        return getCategory(entry.key);
      }
    }
    return null;
  }
}
