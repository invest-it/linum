import 'package:flutter/cupertino.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/constants/standard_expense_categories.dart';
import 'package:linum/core/categories/core/domain/constants/standard_income_categories.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';

class CategoryServiceStandardImpl with ChangeNotifier implements ICategoryService {
  late final standardCategories = <String, Category> {
    ...standardExpenseCategories,
    ...standardIncomeCategories,
  };
  CategoryServiceStandardImpl();

  @override
  CategoryMap getAllCategories() {
    return standardCategories;
  }

  @override
  CategoryMap getCategoriesForEntryType(EntryType entryType) {
    switch (entryType) {
      case EntryType.unknown:
        return standardCategories;
      case EntryType.expense:
        return standardExpenseCategories;
      case EntryType.income:
        return standardIncomeCategories;
    }
  }

  @override
  Category? getCategoryByKey(String key) {
    return standardCategories[key];
  }

  @override
  CategoryMap getExpenseCategories() {
    return standardExpenseCategories;
  }

  @override
  CategoryMap getIncomeCategories() {
    return standardIncomeCategories;
  }

  @override
  CategoryMapIterable getSuggestableCategories() {
    return standardCategories.entries.where((element) => element.value.suggestable);
  }

}
