import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/settings/data/category_settings.dart';
import 'package:linum/core/settings/data/settings_mapper_interface.dart';

class CategorySettingsMapper implements ISettingsMapper<CategorySettings> {
  @override
  Map<String, dynamic> toMap(CategorySettings model) {
    final expenseId = model.expenseCategory.id;
    final incomeId = model.incomeCategory.id;

    return {
      "StandardCategoryIncome": incomeId ?? "none-income",
      "StandardCategoryExpense": expenseId ?? "none-expense",
    };
  }

  @override
  CategorySettings toModel(Map<String, dynamic> map) {
    final expenseId = map["StandardCategoryExpense"] as String?;
    final incomeId = map["StandardCategoryIncome"] as String?;

    return CategorySettings(
        expenseCategory: standardCategories[expenseId] ?? standardCategories["none-expense"]!,
        incomeCategory: standardCategories[incomeId] ?? standardCategories["none-income"]!,
    );
  }

}
