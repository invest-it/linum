import 'package:linum/core/account/data/mappers/settings_mapper_interface.dart';
import 'package:linum/core/account/data/models/category_settings.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';

class CategorySettingsMapper implements ISettingsMapper<CategorySettings> {
  @override
  Map<String, dynamic> toMap(CategorySettings model) {
    final expenseId = model.expenseCategory?.id;
    final incomeId = model.incomeCategory?.id;

    return {
      "StandardCategoryIncome": incomeId ?? "None",
      "StandardCategoryExpense": expenseId ?? "None",
    };
  }

  @override
  CategorySettings toModel(Map<String, dynamic> map) {
    final expenseId = map["StandardCategoryExpense"] as String?;
    final incomeId = map["StandardCategoryIncome"] as String?;

    return CategorySettings(
        expenseCategory: standardCategories[expenseId],
        incomeCategory: standardCategories[incomeId],
    );
  }

}
