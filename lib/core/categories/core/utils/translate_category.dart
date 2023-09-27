import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';

import 'package:linum/core/categories/core/data/models/category.dart';

String translateCategoryId(
    String? categoryId, {
      required bool isExpense,
    }) {

  if (categoryId?.toLowerCase() == "none" || categoryId == null || categoryId == "") {
    return tr(
      "settings_screen.standards-selector-none",
    );
  }

  final category = standardCategories[categoryId];
  return tr(
    category?.label ?? 'listview.label-error-translation',
  );
}

String translateCategory(
    Category? category,
) {
  return tr(
    category?.label ?? "settings_screen.standards-selector-none",
  );
}
