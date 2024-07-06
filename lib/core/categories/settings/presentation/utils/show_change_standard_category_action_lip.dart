import 'package:flutter/material.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/categories/settings/presentation/widgets/category_list_view.dart';
import 'package:provider/provider.dart';

void showChangeStandardCategoryBottomSheet(BuildContext context, {
  required EntryType entryType,
  required String title,
}) {
  final categorySettings = context.read<ICategorySettingsService>();

  void onCategorySelection(Category category) {
    categorySettings.setEntryCategory(category);
    Navigator.pop(context);
  }

  final categoryList = standardCategories.values
      .where((category) => category.entryType == entryType)
      .toList();
  
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return LinumBottomSheet(
          title: title,
          body: CategoryListView(
            categories: categoryList,
            defaultCategoryId: categorySettings.getEntryCategory(entryType)?.id ?? "",
            onCategorySelection: onCategorySelection,
          ),
      );
    },
  );

}
