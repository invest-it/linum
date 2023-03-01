import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

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
      standardCategory = (int index) =>
          standardExpenseCategories[StandardCategoryExpense.values[index]];
      itemIsSelected = (int index) => StandardCategoryExpense.values[index]
          .equals(accountSettingsProvider.settings["StandardCategoryExpense"]
              as String?);
      enumStr = (int index) => StandardCategoryExpense.values[index].toString();
    }
    if (T == StandardCategoryIncome) {
      enumItemCount = StandardCategoryIncome.values.length;
      standardCategory = (int index) =>
          standardIncomeCategories[StandardCategoryIncome.values[index]];
      itemIsSelected = (int index) => StandardCategoryIncome.values[index]
          .equals(accountSettingsProvider.settings["StandardCategoryIncome"]
              as String?);
      enumStr = (int index) => StandardCategoryIncome.values[index].toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    final sizeGuideProvider =
        Provider.of<SizeGuideProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Column(
            children: [
              SizedBox(
                height: sizeGuideProvider.proportionateScreenHeightFraction(
                    ScreenFraction.twofifths),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: enumItemCount,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      //leading: Icon(widget.categories[index].icon),
                      leading: Icon(standardCategory(index)?.icon),
                      title: Text(
                        tr(standardCategory(index)?.label ?? "Category"),
                      ),
                      selected: itemIsSelected(index),
                      onTap: () {
                        final List<String> stringArr =
                            enumStr(index).split(".");
                        accountSettingsProvider.updateSettings({
                          stringArr[0]: stringArr[1],
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
