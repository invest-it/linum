//  Settings Screen Income List View - the list view shown inside of the action lip
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron (small)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class IncomeListView extends StatelessWidget {
  final ActionLipStatusProvider actionLipStatusProvider;
  final AccountSettingsProvider accountSettingsProvider;
  const IncomeListView(
    this.accountSettingsProvider,
    this.actionLipStatusProvider,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: StandardCategoryIncome.values.length,
                  itemBuilder: (BuildContext context, int indexBuilder) {
                    return ListTile(
                      leading: Icon(
                        standardIncomeCategories[
                                StandardCategoryIncome.values[indexBuilder]]
                            ?.icon,
                      ),
                      title: Text(
                        tr(standardIncomeCategories[StandardCategoryIncome.values[indexBuilder]]?.label ?? "Category"),
                      ),
                      selected:
                          "StandardCategoryIncome.${accountSettingsProvider.settings["StandardCategoryIncome"] as String? ?? "None"}" ==
                              StandardCategoryIncome.values[indexBuilder]
                                  .toString(),
                      onTap: () {
                        final List<String> stringArr = StandardCategoryIncome
                            .values[indexBuilder]
                            .toString()
                            .split(".");
                        accountSettingsProvider.updateSettings({
                          stringArr[0]: stringArr[1],
                        });
                        actionLipStatusProvider.setActionLipStatus(
                          providerKey: ProviderKey.settings,
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
