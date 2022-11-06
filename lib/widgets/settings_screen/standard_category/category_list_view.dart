import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';



class CategoryListView<T extends Enum> extends StatelessWidget {
  final ActionLipStatusProvider actionLipStatusProvider;
  final AccountSettingsProvider accountSettingsProvider;

  late final int enumItemCount;
  late final EntryCategory? Function(int indexBuilder) standardCategory;
  late final bool Function(int indexBuilder) itemIsSelected;
  late final String Function(int indexBuilder) enumStr;

  CategoryListView(this.accountSettingsProvider, this.actionLipStatusProvider) {
    if (T == StandardCategoryExpense) {
      enumItemCount = StandardCategoryExpense.values.length;
      standardCategory = (int indexBuilder) =>
      standardExpenseCategories[StandardCategoryExpense.values[indexBuilder]];
      itemIsSelected = (int indexBuilder) =>
          StandardCategoryExpense.values[indexBuilder]
              .equals(accountSettingsProvider.settings["StandardCategoryExpense"] as String?);
      enumStr = (int indexBuilder) =>
          StandardCategoryExpense.values[indexBuilder].toString();
    }
    if (T == StandardCategoryIncome) {
      enumItemCount = StandardCategoryIncome.values.length;
      standardCategory = (int indexBuilder) =>
      standardIncomeCategories[StandardCategoryIncome.values[indexBuilder]];
      itemIsSelected = (int indexBuilder) =>
          StandardCategoryIncome.values[indexBuilder]
              .equals(accountSettingsProvider.settings["StandardCategoryIncome"] as String?);
      enumStr = (int indexBuilder) =>
          StandardCategoryIncome.values[indexBuilder].toString();
    }
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
                height:
                  proportionateScreenHeightFraction(ScreenFraction.twofifths),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: enumItemCount,
                  itemBuilder: (BuildContext context, int indexBuilder) {
                    return ListTile(
                      //leading: Icon(widget.categories[index].icon),
                      leading: Icon(standardCategory(indexBuilder)?.icon),
                      title: Text(
                        tr(standardCategory(indexBuilder)?.label ?? "Category"),
                      ),
                      selected: itemIsSelected(indexBuilder),
                      onTap: () {
                        final List<String> stringArr = enumStr(indexBuilder).split(".");
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
