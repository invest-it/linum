import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/widgets/category_list_tile.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categories;
  final String settingsKey;

  const CategoryListView({
    required this.categories,
    required this.settingsKey,
  });

  @override
  Widget build(BuildContext context) {
    final accountSettingsService
      = Provider.of<AccountSettingsService>(context, listen: false);
    final actionLipViewModel
      = Provider.of<ActionLipViewModel>(context, listen: false);

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: context.proportionateScreenHeightFraction(ScreenFraction.onefifth),
        ),
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];

          return CategoryListTile(
            category: category,
            selected: category.id == accountSettingsService.settings[settingsKey],
            onTap: () {
              accountSettingsService.updateSettings({
                settingsKey: category.id,
              });
              actionLipViewModel.setActionLipStatus(
                screenKey: ScreenKey.settings,
                status: ActionLipVisibility.hidden,
              );
            },
          );
        },
      ),
    );
  }
}
