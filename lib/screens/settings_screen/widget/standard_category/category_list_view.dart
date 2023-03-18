import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';

class CategoryListView extends StatelessWidget {
  final ActionLipViewModel actionLipStatusProvider;
  final AccountSettingsService accountSettingsProvider;
  final List<Category> categories;
  final String settingsKey;
  late final bool Function(Category category) isSelected;


  CategoryListView(
      this.accountSettingsProvider,
      this.actionLipStatusProvider, {
        required this.categories,
        required this.settingsKey,
  }) {
    isSelected = (category) =>
        category.id ==  accountSettingsProvider.settings[settingsKey];
  }
  @override
  Widget build(BuildContext context) {
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

          return ListTile(
            //leading: Icon(widget.categories[index].icon),
            leading: Icon(category.icon),
            title: Text(
              tr(category.label),
            ),
            selected: isSelected(categories[index]),
            onTap: () {
              accountSettingsProvider.updateSettings({
                settingsKey: category.id,
              });
              actionLipStatusProvider.setActionLipStatus(
                screenKey: ScreenKey.settings,
                status: ActionLipStatus.hidden,
              );
            },
          );
        },
      ),
    );
  }
}
