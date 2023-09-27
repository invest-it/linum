import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/data/models/category.dart';

abstract class ICategorySettingsService with ChangeNotifier {
  Category? getEntryCategory(EntryType entryType);
  Category? getIncomeEntryCategory();
  Category? getExpenseEntryCategory();

  Future<void> setEntryCategory(Category category);
}
