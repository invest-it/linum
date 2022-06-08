//  Settings Screen Standard Category - The selector for the standard categories
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: none

import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class StandardCategory extends StatelessWidget {
  const StandardCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            //Request from SoTBurst - this fix is related to issue #46
            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle: AppLocalizations.of(context)!.translate(
                'action_lip/forgot-password/logged-out/label-title',
              ),
              actionLipBody: Column(
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
                          child: _incomeListViewBuilder(
                            accountSettingsProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate(
                    'settings_screen/standard-income-selector/label-title',
                  ) +
                  AppLocalizations.of(context)!.translate(
                    accountSettingsProvider.getIncomeEntryCategory()?.label ??
                        "ChosenStandardIncome", // TODO: Does this make sense?
                  ), // yeah im sorry that is really complicated code. :( It translates the value from firebase
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: const Icon(
              Icons.north_east,
              color: Color(0xFF97BC4E),
            ),
            leading: Icon(
              accountSettingsProvider.getIncomeEntryCategory()?.icon ??
                  Icons.error,
            ),
          ),
        ),
        //Ende Einnahmen ListTile
        GestureDetector(
          onTap: () {
            //Request from SoTBurst - this fix is related to issue #46
            actionLipStatusProvider.setActionLipStatus(
              providerKey: ProviderKey.settings,
            );

            actionLipStatusProvider.setActionLip(
              providerKey: ProviderKey.settings,
              actionLipStatus: ActionLipStatus.onviewport,
              actionLipTitle: AppLocalizations.of(context)!.translate(
                'action_lip/forgot-password/logged-out/label-title',
              ),
              actionLipBody: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 24.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: _expensesListViewBuilder(
                            accountSettingsProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: ListTile(
            title: Text(
              AppLocalizations.of(context)!.translate(
                    'settings_screen/standard-expense-selector/label-title',
                  ) +
                  AppLocalizations.of(context)!.translate(
                    accountSettingsProvider.getExpenseEntryCategory()?.label ??
                        "ChosenStandardExpense",
                  ), // yeah im sorry that is really complicated code. :( It translates the value from firebase
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: const Icon(
              Icons.south_east,
              color: Colors.red,
            ),
            leading: Icon(
              accountSettingsProvider.getExpenseEntryCategory()?.icon ??
                  Icons.error,
            ),
          ),
        ),
      ],
    );
  }
  //ListView.builder für Standard Kategorien

  ListView _incomeListViewBuilder(
    AccountSettingsProvider accountSettingsProvider,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardCategoryIncome.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(
            AppLocalizations.of(context)!.translate(
              standardCategoryIncomes[
                          StandardCategoryIncome.values[indexBuilder]]
                      ?.label ??
                  "Category",
            ),
          ),
          selected:
              "StandardCategoryIncome.${accountSettingsProvider.settings["StandardCategoryIncome"] as String? ?? "None"}" ==
                  StandardCategoryIncome.values[indexBuilder].toString(),
          onTap: () {
            final List<String> stringArr = StandardCategoryIncome
                .values[indexBuilder]
                .toString()
                .split(".");
            accountSettingsProvider.updateSettings({
              stringArr[0]: stringArr[1],
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  ListView _expensesListViewBuilder(
    AccountSettingsProvider accountSettingsProvider,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardCategoryExpense.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(
            AppLocalizations.of(context)!.translate(
              standardCategoryExpenses[
                          StandardCategoryExpense.values[indexBuilder]]
                      ?.label ??
                  "Category",
            ),
          ),
          selected:
              "StandardCategoryExpense.${accountSettingsProvider.settings["StandardCategoryExpense"] as String? ?? "None"}" ==
                  StandardCategoryExpense.values[indexBuilder].toString(),
          onTap: () {
            final List<String> stringArr = StandardCategoryExpense
                .values[indexBuilder]
                .toString()
                .split(".");
            accountSettingsProvider.updateSettings({
              stringArr[0]: stringArr[1],
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
}


//income ModalBottomSheet
            /*showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: proportionateScreenHeightFraction(
                    ScreenFraction.half,
                  ),
                  color: Theme.of(context).colorScheme.onSecondary,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                            'settings_screen/standard-income-selector/label-title',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: proportionateScreenHeightFraction(
                          ScreenFraction.twofifths,
                        ),
                        child: _incomeListViewBuilder(
                          accountSettingsProvider,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );*/

//expense ModalBottomSheet
 /*showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color(0xFFFAFAFA),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                            'settings_screen/standard-expense-selector/label-title',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: _expensesListViewBuilder(
                          accountSettingsProvider,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );*/