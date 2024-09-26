import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';

abstract class ICategoryService extends IProvidableService  {
  CategoryMap getAllCategories();
  CategoryMap getIncomeCategories();
  CategoryMap getExpenseCategories();
  CategoryMap getCategoriesForEntryType(EntryType entryType);
  Category? getCategoryByKey(String key);
  CategoryMapIterable getSuggestableCategories();
}
