import 'package:flutter/cupertino.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/categories/settings/presentation/widgets/category_list_view.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:provider/provider.dart';

void showChangeStandardCategoryActionLip(BuildContext context, {
  required EntryType entryType,
  required String lipTitle,
}) {
  final categorySettings = context.read<ICategorySettingsService>();
  final actionLipViewModel = context.read<ActionLipViewModel>();

  void onCategorySelection(Category category) {
    categorySettings.setEntryCategory(category);
    actionLipViewModel.setActionLipStatus(
      context: context,
      screenKey: ScreenKey.settings,
      status: ActionLipVisibility.hidden,
    );
  }

  final categoryList = standardCategories.values
      .where((category) => category.entryType == entryType)
      .toList();


  actionLipViewModel.setActionLip(
    context: context,
    screenKey: ScreenKey.settings,
    actionLipStatus: ActionLipVisibility.onviewport,
    actionLipTitle: lipTitle,
    actionLipBody: CategoryListView(
      categories: categoryList,
      defaultCategoryId: categorySettings.getEntryCategory(entryType)?.id ?? "",
      onCategorySelection: onCategorySelection,
    ),
  );
}
