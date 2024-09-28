import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';

abstract class ICategorySettingsService extends IProvidableService with NotifyReady {
  Category? getEntryCategory(EntryType entryType);
  Category getIncomeEntryCategory();
  Category getExpenseEntryCategory();

  Future<void> setEntryCategory(Category category);
}
