import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/screen_fraction_enum.dart';
import 'package:linum/models/category.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

class CategoryListView extends StatelessWidget {
  final ActionLipStatusProvider actionLipStatusProvider;
  final AccountSettingsProvider accountSettingsProvider;
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ),
                child: ListView.builder(
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
                          providerKey: ProviderKey.settings,
                          status: ActionLipStatus.hidden,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
