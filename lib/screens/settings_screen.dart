import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/silent-scroll.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/widgets/auth/logout_form.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _toggled = false;

  final Map<StandardExpense, String> _categoriesCategoryExpenses = {
    StandardExpense.None: "settings_screen/standards-selector-none",
    StandardExpense.Food: "settings_screen/standard-expense-selector/food",
    StandardExpense.FreeTime:
        "settings_screen/standard-expense-selector/freetime",
    StandardExpense.House: "settings_screen/standard-expense-selector/house",
    StandardExpense.Lifestyle:
        "settings_screen/standard-expense-selector/lifestyle",
    StandardExpense.Car: "settings_screen/standard-expense-selector/car",
    StandardExpense.Diversified:
        "settings_screen/standard-expense-selector/misc",
  };

  final Map<StandardIncome, String> _categoriesCategoryIncome = {
    StandardIncome.None: "settings_screen/standards-selector-none",
    StandardIncome.Income: "settings_screen/standard-income-selector/salary",
    StandardIncome.Allowance:
        "settings_screen/standard-income-selector/allowance",
    StandardIncome.SideJob: "settings_screen/standard-income-selector/sidejob",
    StandardIncome.Investments:
        "settings_screen/standard-income-selector/investments",
    StandardIncome.ChildSupport:
        "settings_screen/standard-income-selector/childsupport",
    StandardIncome.Interest:
        "settings_screen/standard-income-selector/interest",
    StandardIncome.Diversified: "settings-screen/standard-income-selector/misc",
  };

  final Map<StandardAccount, String> _categoriesAccount = {
    StandardAccount.None: "settings_screen/standards-selector-none",
    StandardAccount.Debit:
        "settings_screen/standard-account-selector/debit-card",
    StandardAccount.Credit:
        "settings_screen/standard-account-selector/credit-card",
    StandardAccount.Cash: "settings_screen/standard-account-selector/cash",
    StandardAccount.Depot: "settings_screen/standard-account-selector/deposit",
  };

  String dropdownValue = 'Euro (EUR, €)';

  List<bool> _selections = List.generate(2, (index) => false);

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);

    AuthenticationService auth = Provider.of<AuthenticationService>(context);

    return ScreenSkeleton(
      head: 'Account',
      body: ScrollConfiguration(
        behavior: SilentScroll(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0.0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                              AppLocalizations.of(context)!.translate(
                                  'settings_screen/standard-currency/label-title'),
                              style: Theme.of(context).textTheme.overline),
                          Tooltip(
                            child: Align(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: Icon(
                                Icons.help_outline_rounded,
                                size: 10 * 1.8,
                              ),
                            ),
                            message: AppLocalizations.of(context)!.translate(
                                'settings_screen/standard-currency/label-tooltip'),
                            triggerMode: TooltipTriggerMode.tap,
                            padding: EdgeInsets.all(8.0),
                            enableFeedback: false,
                            preferBelow: false,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 8.0,
                          right: 8.0,
                          bottom: 0,
                        ),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(border: InputBorder.none),
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: <String>[
                            'Euro (EUR, €)',
                            'Dollar (USD, \$)',
                            'Pound Sterling (GBP, £)',
                            'Yen (JPY, ¥)',
                            'Krone (DKK, Kr.)',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                //line in between
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 16.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.001,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                //going on...
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                              AppLocalizations.of(context)!.translate(
                                  'settings_screen/standard-category/label-title'),
                              style: Theme.of(context).textTheme.overline),
                          Tooltip(
                            child: Align(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: Icon(
                                Icons.help_outline_rounded,
                                size: 10 * 1.8,
                              ),
                            ),
                            message: AppLocalizations.of(context)!.translate(
                                'settings_screen/standard-category/label-tooltip'),
                            triggerMode: TooltipTriggerMode.tap,
                            padding: EdgeInsets.all(8.0),
                            enableFeedback: false,
                            preferBelow: false,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                color: createMaterialColor(Color(0xFFFAFAFA)),
                                child: Column(children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'settings_screen/standard-income-selector/label-title'),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: _incomeListViewBuilder(
                                      _categoriesCategoryIncome,
                                    ),
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          // onTap: ontap(),
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-income-selector/label-title') +
                                AppLocalizations.of(context)!.translate(
                                    _categoriesCategoryIncome[selectedIncome] ??
                                        "Category"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),

                          trailing: Icon(
                            Icons.north_east,
                            color: createMaterialColor(Color(0xFF97BC4E)),
                          ),
                        ),
                      ),
                      //Ende Einnahmen ListTile
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                color: createMaterialColor(Color(0xFFFAFAFA)),
                                child: Column(children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'settings_screen/standard-expense-selector/label-title'),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: _expensesListViewBuilder(
                                      _categoriesCategoryExpenses,
                                    ),
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          // onTap: ontap(),
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-expense-selector/label-title') +
                                AppLocalizations.of(context)!.translate(
                                    _categoriesCategoryExpenses[
                                            selectedExpense] ??
                                        "Category"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: Icon(
                            Icons.south_east,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      //Ende GestureDetector Ausgaben
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                color: createMaterialColor(Color(0xFFFAFAFA)),
                                child: Column(children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'settings_screen/standard-account-selector/modal-label-title'),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: _accountListViewBuilder(
                                      _categoriesAccount,
                                    ),
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          // onTap: ontap(),
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-account-selector/label-title') +
                                AppLocalizations.of(context)!.translate(
                                    _categoriesAccount[selectedAccount] ??
                                        "Category"),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: Icon(
                            Icons.swap_horiz,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      //Einde GestureDetector Accounts
                      //Icons disputable
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 16.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.001,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          AppLocalizations.of(context)!.translate(
                              'settings_screen/special-settings/label-title'),
                          style: Theme.of(context).textTheme.overline),
                      SwitchListTile(
                        // onTap: ontap(),
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                              'settings_screen/special-settings/label-schwabenmodus'),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        value: _toggled,
                        activeColor: Colors.green,
                        onChanged: (bool value) {
                          setState(() {
                            _toggled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 40.0,
                //     right: 40.0,
                //     top: 0,
                //     bottom: 0,
                //   ),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width,
                //     height: MediaQuery.of(context).size.height * 0.001,
                //     child: const DecoratedBox(
                //       decoration: const BoxDecoration(
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ),
                // ),
                // Ende graue Linie
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 16.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.001,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                              'settings_screen/system-settings/label-title'),
                          style: Theme.of(context).textTheme.overline,
                        ),
                      ),
                      Container(
                        height: proportionateScreenHeight(48),
                        child: Expanded(
                          child: Center(
                            child: ToggleButtons(
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'settings_screen/system-settings/language-selector-en'),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                                Container(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'settings_screen/system-settings/language-selector-de'),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                              ],
                              isSelected: _selections,
                              onPressed: (int index) {
                                setState(() {
                                  for (int i = 0; i < _selections.length; i++)
                                    _selections[i] = i == index;
                                });
                              },
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: proportionateScreenHeight(32),
                      ),
                      // All Authentication Actions (including logOut will be handled via widgets/auth from now on.)
                      LogoutForm(),
                    ],
                  ),
                ),
                SizedBox(
                  height: proportionateScreenHeight(64),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //ListView.builder für Standard Kategorien

  StandardIncome selectedIncome = StandardIncome.None;
  StandardExpense selectedExpense = StandardExpense.None;
  StandardAccount selectedAccount = StandardAccount.None;

  ListView _incomeListViewBuilder(
      Map<StandardIncome, String> _categoriesCategoryIncome) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardIncome.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
            //leading: Icon(widget.categories[index].icon),
            title: Text(AppLocalizations.of(context)!.translate(
                _categoriesCategoryIncome[
                        StandardIncome.values[indexBuilder]] ??
                    "Category")),
            selected: selectedIncome == StandardIncome.values[indexBuilder],
            onTap: () {
              setState(() {
                selectedIncome = StandardIncome.values[indexBuilder];
              });
              Navigator.pop(context);
            }
            // trailing: ,
            );
      },
    );
  }

  ListView _expensesListViewBuilder(
      Map<StandardExpense, String> _categoriesCategoryExpenses) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardExpense.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
            //leading: Icon(widget.categories[index].icon),
            title: Text(AppLocalizations.of(context)!.translate(
                _categoriesCategoryExpenses[
                        StandardExpense.values[indexBuilder]] ??
                    "Category")),
            selected: selectedExpense == StandardExpense.values[indexBuilder],
            onTap: () {
              setState(() {
                selectedExpense = StandardExpense.values[indexBuilder];
              });
              Navigator.pop(context);
            });
      },
    );
  }

  ListView _accountListViewBuilder(
      Map<StandardAccount, String> _categoriesAccount) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardAccount.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(AppLocalizations.of(context)!.translate(
              _categoriesAccount[StandardAccount.values[indexBuilder]] ??
                  "Category")),
          selected: selectedAccount == StandardAccount.values[indexBuilder],
          onTap: () {
            setState(() {
              selectedAccount = StandardAccount.values[indexBuilder];
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

ListView _currencyChange(_currency) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: _currency.length,
    itemBuilder: (BuildContext context, int indexBuilder) {
      return ListTile(
        //leading: Icon(widget.categories[index].icon),
        title: Text(_currency[indexBuilder]),
        // onTap: () => _selectCategoryItem(
        //     widget.categoriesCategoryIncome[indexBuilder],
        //     enterScreenProvider),
      );
    },
  );
}

enum StandardIncome {
  None,
  Income,
  Allowance,
  SideJob,
  Investments,
  ChildSupport,
  Interest,
  Diversified,
}

enum StandardExpense {
  None,
  Food,
  FreeTime,
  House,
  Lifestyle,
  Car,
  Diversified,
}
enum StandardAccount {
  None,
  Debit,
  Credit,
  Cash,
  Depot,
}
