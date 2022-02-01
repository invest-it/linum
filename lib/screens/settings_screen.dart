import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/list_divider.dart';
import 'package:linum/frontend_functions/list_header.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/silent-scroll.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
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
  bool _schwabenmodus = false;
  bool _systemlang = true;

  final Map<StandardExpense, String> _categoriesCategoryExpenses = {
    StandardExpense.None: "settings_screen/standards-selector-none",
    StandardExpense.Food: "settings_screen/standard-expense-selector/food",
    StandardExpense.FreeTime:
        "settings_screen/standard-expense-selector/freetime",
    StandardExpense.House: "settings_screen/standard-expense-selector/house",
    StandardExpense.Lifestyle:
        "settings_screen/standard-expense-selector/lifestyle",
    StandardExpense.Car: "settings_screen/standard-expense-selector/car",
    StandardExpense.Miscellaneous:
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
    StandardIncome.Miscellaneous:
        "settings-screen/standard-income-selector/misc",
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

  List<bool> _languageSelection = [false, false];

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Account',
      providerKey: ProviderKey.SETTINGS,
      initialActionLipStatus: ActionLipStatus.HIDDEN,
      initialActionLipBody: Container(),
      body: ScrollConfiguration(
        behavior: SilentScroll(),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 24.0,
          ),
          children: [
            /// STANDARD CURRENCY
            /// FUTURE implement this properly, not the fucky-wucky this was before we decided to put it down
            // ListHeader(
            // 'settings_screen/standard-currency/label-title',
            // tooltipMessage: 'settings_screen/standard-currency/label-tooltip',
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     DropdownButtonFormField<String>(
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //       ),
            //       value: dropdownValue,
            //       icon: const Icon(Icons.arrow_drop_down),
            //       elevation: 16,
            //       style: const TextStyle(color: Colors.black),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           dropdownValue = newValue!;
            //         });
            //       },
            //       items: <String>[
            //         'Euro (EUR, €)',
            //         'Dollar (USD, \$)',
            //         'Pound Sterling (GBP, £)',
            //         'Yen (JPY, ¥)',
            //         'Krone (DKK, Kr.)',
            //       ].map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
            // ListDivider(T: 0),

            /// STANDARD CATEGORY
            ListHeader(
              'settings_screen/standard-category/label-title',
              tooltipMessage: 'settings_screen/standard-category/label-tooltip',
            ),

            /// TODO this is not lean programming and needs a rework.
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: proportionateScreenHeightFraction(
                              ScreenFraction.HALF),
                          color: Theme.of(context).colorScheme.onSecondary,
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-income-selector/label-title'),
                              ),
                            ),
                            Container(
                              height: proportionateScreenHeightFraction(
                                  ScreenFraction.TWOFIFTHS),
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
                          height: MediaQuery.of(context).size.height * 0.5,
                          color: createMaterialColor(Color(0xFFFAFAFA)),
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-expense-selector/label-title'),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
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
                              _categoriesCategoryExpenses[selectedExpense] ??
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
                          height: MediaQuery.of(context).size.height * 0.5,
                          color: createMaterialColor(Color(0xFFFAFAFA)),
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-account-selector/modal-label-title'),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
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
            ListDivider(),

            /// SPECIAL SETTINGS
            /// This setting will be hidden until implememted.
            // ListHeader('settings_screen/special-settings/label-title'),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SwitchListTile(
            //       /// TODO implement schwabenmodus functionality
            //       title: Text(
            //         AppLocalizations.of(context)!.translate(
            //             'settings_screen/special-settings/label-schwabenmodus'),
            //         style: Theme.of(context).textTheme.bodyText1,
            //       ),
            //       value: _schwabenmodus,
            //       activeColor: Colors.green,
            //       onChanged: (bool value) {
            //         setState(() {
            //           _schwabenmodus = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // ListDivider(),

            /// LANGUAGE SWITCH
            ListHeader(
              'settings_screen/language-settings/label-title',
              //TODO remove this once the syslang functionality is fully implemented
              tooltipMessage: 'settings_screen/language-settings/label-tooltip',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SwitchListTile(
                  /// TODO implement auto language functionality (see the comment on the toggle buttons below)
                  title: Text(
                    AppLocalizations.of(context)!.translate(
                        'settings_screen/language-settings/label-systemlang'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  value: _systemlang,
                  activeColor: Colors.grey[500],
                  onChanged: (bool value) {
                    // setState(() {
                    /// TODO remove this once we won't force the user anymore to use the system language settings
                    // _systemlang = value;
                    // _systemlang = _systemlang;
                    // });
                  },
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ToggleButtons(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                  'settings_screen/language-settings/label-en'),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                  'settings_screen/language-settings/label-de'),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                      ],
                      isSelected: _languageSelection,

                      /// TODO MVP we need to somehow read out 1. if the system language is used and turn on/off the functionality of this togglebutton,
                      /// 2. read out which language is being used and mark the corresponding toggle as active, 3. if the syslang switch is off, a press of
                      /// the toggle should lead to the language being updated.

                      // onPressed: (int index) {
                      // setState(() {
                      //   for (int i = 0; i < _languageSelection.length; i++)
                      //     _languageSelection[i] = i == index;
                      // });
                      // },
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ],
                ),
              ],
            ),
            ListDivider(),

            /// YOUR ACCOUNT
            ListHeader('settings_screen/system-settings/label-title'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Authentication Actions (including logOut will be handled via widgets/auth from now on.)
                LogoutForm(),
                ForgotPasswordButton(ProviderKey.SETTINGS),
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
  Miscellaneous,
}

enum StandardExpense {
  None,
  Food,
  FreeTime,
  House,
  Lifestyle,
  Car,
  Miscellaneous,
}
enum StandardAccount {
  None,
  Debit,
  Credit,
  Cash,
  Depot,
}
