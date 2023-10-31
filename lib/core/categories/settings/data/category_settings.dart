import 'package:linum/core/categories/core/data/models/category.dart';

class CategorySettings {
  final Category expenseCategory;
  final Category incomeCategory;

  CategorySettings({
    required this.expenseCategory,
    required this.incomeCategory,
  });

  CategorySettings copyWith({
    Category? expenseCategory,
    Category? incomeCategory,
  }) {
    return CategorySettings(
      expenseCategory: expenseCategory ?? this.expenseCategory,
      incomeCategory: incomeCategory ?? this.incomeCategory,
    );
  }

  @override
  String toString() {
    return "CategorySettings(expenseCategory: $expenseCategory, incomeCategory: $incomeCategory)";
  }
}
