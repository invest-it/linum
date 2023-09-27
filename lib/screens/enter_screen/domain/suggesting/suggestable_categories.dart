import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';

Iterable<MapEntry<String, Category>> getSuggestableCategories() {
  return standardCategories.entries.where((element) => element.value.suggestable);
}
