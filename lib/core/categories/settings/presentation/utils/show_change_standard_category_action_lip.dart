import 'package:flutter/material.dart';
import 'package:linum/common/components/sheets/linum_bottom_sheet.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';
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

  
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      final categoryList = context.read<ICategoryService>()
          .getCategoriesForEntryType(entryType).values.toList();

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
