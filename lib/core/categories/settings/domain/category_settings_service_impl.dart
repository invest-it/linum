import 'dart:async';

import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/categories/settings/data/category_settings.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';


class CategorySettingsServiceImpl
    extends SubscriptionHandler
    implements ICategorySettingsService
{
  final ISettingsRepository<CategorySettings> _repository;



  CategorySettingsServiceImpl(this._repository) {
    super.subscribe(_repository.settingsStream, (event) {
      notifyListeners();
    });
  }

  @override
  Category? getEntryCategory(EntryType entryType) {
    switch (entryType) {
      case EntryType.income:
        return getIncomeEntryCategory();
      case EntryType.expense:
        return getExpenseEntryCategory();
      case EntryType.unknown:
        return null;
    }
  }

  @override
  Category? getExpenseEntryCategory() {
    return _repository.settings.expenseCategory;
  }

  @override
  Category? getIncomeEntryCategory() {
    return _repository.settings.incomeCategory;
  }

  @override
  Future<void> setEntryCategory(Category category) async {
    switch (category.entryType) {
      case EntryType.income:
        return _setIncomeEntryCategory(category);
      case EntryType.expense:
        return _setExpenseEntryCategory(category);
      case EntryType.unknown:
        return;
    }
  }

  Future<void> _setIncomeEntryCategory(Category category) async {
    final update = _repository.settings.copyWith(incomeCategory: category);
    return _repository.update(update);
  }

  Future<void> _setExpenseEntryCategory(Category category) async {
    final update = _repository.settings.copyWith(expenseCategory: category);
    return _repository.update(update);
  }

}
