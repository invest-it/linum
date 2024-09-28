import 'package:linum/core/categories/core/presentation/category_service.dart';
import 'package:linum/core/categories/settings/data/category_settings.dart';
import 'package:linum/core/settings/data/settings_mapper_interface.dart';

// TODO: CategoryService must be loaded before the settings mapper is used
class CategorySettingsMapper implements ISettingsMapper<CategorySettings> {
  final ICategoryService categoryService;
  CategorySettingsMapper({
    required this.categoryService,
  });

  @override
  Map<String, dynamic> toMap(CategorySettings model) {
    final expenseId = model.expenseCategory.id;
    final incomeId = model.incomeCategory.id;

    return {
      "StandardCategoryIncome": incomeId,
      "StandardCategoryExpense": expenseId,
    };
  }

  @override
  CategorySettings toModel(Map<String, dynamic> map) {
    final expenseId = map["StandardCategoryExpense"] as String?;
    final incomeId = map["StandardCategoryIncome"] as String?;

    final expenseCategories = categoryService.getExpenseCategories();
    final incomeCategories = categoryService.getIncomeCategories();

    return CategorySettings(
        expenseCategory: expenseCategories[expenseId] ?? expenseCategories["none-expense"]!,
        incomeCategory: incomeCategories[incomeId] ?? incomeCategories["none-income"]!,
    );
  }

}
