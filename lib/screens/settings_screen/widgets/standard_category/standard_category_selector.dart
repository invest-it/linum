import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/categories/core/presentation/widgets/category_list_tile.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/settings_screen/widgets/standard_category/category_list_view.dart';
import 'package:provider/provider.dart';

class StandardCategorySelector extends StatelessWidget {
  final EntryType categoryType;
  const StandardCategorySelector({
    super.key,
    required this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final categorySettings = context.read<ICategorySettingsService>();
        final actionLipViewModel = context.read<ActionLipViewModel>();

        actionLipViewModel.setActionLip(
          context: context,
          screenKey: ScreenKey.settings,
          actionLipStatus: ActionLipVisibility.onviewport,
          actionLipTitle: _selectLabel(),
          actionLipBody: CategoryListView(
            categories: standardCategories.values
                .where((category) => category.entryType == categoryType)
                .toList(),
            defaultCategoryId: categorySettings
                .getEntryCategory(categoryType)?.id ?? "",
            onCategorySelection: (Category category) {

              categorySettings.setEntryCategory(category);
              actionLipViewModel.setActionLipStatus(
                context: context,
                screenKey: ScreenKey.settings,
                status: ActionLipVisibility.hidden,
              );

            },
          ),
        );
      },
      child: Selector<ICategorySettingsService, Category?>(
        selector: (_, settings) => settings.getEntryCategory(categoryType),
        builder: (context, category, _) {
          return CategoryListTile(
            labelTitle: _selectLabelTitle(),
            category: category,
            trailingIcon: Icons.north_east,
            trailingIconColor: Colors.green,
          );
        },
      ),
    );
  }


  String _selectLabel() {
    switch (categoryType) {
      case EntryType.expense:
        return tr(translationKeys.actionLip.standardCategory.expenses.labelTitle);
      case EntryType.income:
        return tr(translationKeys.actionLip.standardCategory.income.labelTitle);
      case EntryType.unknown:
        return "";
    }
  }

  String _selectLabelTitle() {
    switch (categoryType) {
      case EntryType.expense:
        return tr(translationKeys.settingsScreen.standardExpenseSelector.labelTitle);
      case EntryType.income:
        return tr(translationKeys.settingsScreen.standardIncomeSelector.labelTitle);
      case EntryType.unknown:
        return "";
    }
  }
}
