import 'package:easy_localization/easy_localization.dart';

import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';

class CategoryIdTranslator {
  final CategoryMap categories;

  CategoryIdTranslator({
    required this.categories,
  });

  String translate(String? categoryId, {
    required bool isExpense,
  }) {
    if (categoryId?.toLowerCase() == "none" || categoryId == null || categoryId == "") {
      return tr(
        "settings_screen.standards-selector-none",
      );
    }

    final category = categories[categoryId];
    return tr(
      category?.label ?? 'listview.label-error-translation',
    );
  }
}

String translateCategory(
    Category? category,
) {
  return tr(
    category?.label ?? "settings_screen.standards-selector-none",
  );
}
