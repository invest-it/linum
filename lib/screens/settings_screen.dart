import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/providers/authentication_service.dart';
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
    StandardExpense.None: "Kein",
    StandardExpense.Food: "Essen & Trinken",
    StandardExpense.FreeTime: "Freizeit",
    StandardExpense.House: "Haus",
    StandardExpense.Lifestyle: "Lebensstil",
    StandardExpense.Car: "Auto/Nahverkehr",
    StandardExpense.Diversified: "Diverses",
  };

  final Map<StandardIncome, String> _categoriesCategoryIncome = {
    StandardIncome.None: "Kein",
    StandardIncome.Income: "Gehalt",
    StandardIncome.Allowance: "Taschengeld",
    StandardIncome.SideJob: "Nebenjob",
    StandardIncome.Investments: "Investitionen",
    StandardIncome.ChildSupport: "Kindergeld",
    StandardIncome.Interest: "Zinsen",
    StandardIncome.Diversified: "Diverses",
  };

  final Map<StandardAccount, String> _categoriesAccount = {
    StandardAccount.None: "Kein",
    StandardAccount.Debit: "Debitkarte",
    StandardAccount.Credit: "Kreditkarte",
    StandardAccount.Cash: "Bargeld",
    StandardAccount.Depot: "Depot",
  };

  String dropdownValue = 'Euro (EUR, €)';

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);
    return ScreenSkeleton(
        head: 'Account',
        isInverted: false,
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
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
                          Text('STANDARD-WÄHRUNG',
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
                            message:
                                'Diese Währung wird standardmäßig bei jeder neuen Transaktion genutzt. Du kannst diese auch individuell ändern.',
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
                            'Pfund (GBP, £)',
                            'Yen (JPY, ¥)',
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
                          Text('STANDARD-KATEGORIEN',
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
                            message:
                                'Diese Kategorien werden standardmäßig bei jeder neuen Einnahme/Ausgabe/Transaktion genutzt. Du kannst diese auch individuell ändern.',
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
                                    title: Text('Einnahmen'),
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
                          title: Text('Einnahmen'),
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
                                    title: Text('Ausgaben'),
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
                          title: Text('Augaben'),
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
                                    title: Text('Accounts'),
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
                          title: Text('Transaktionen'),
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
                        Text('BESONDERE EINSTELLUNGEN',
                            style: Theme.of(context).textTheme.overline),
                        SwitchListTile(
                          // onTap: ontap(),
                          title: Text('Schwabenmodus'),
                          value: _toggled,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState(() {
                              _toggled = value;
                            });
                          },
                        ),
                      ]),
                ),
                ElevatedButton(
                  onPressed: () => {auth.signOut()},
                  child: Text('Ausloggen'),
                ),
              ],
            ),
          ],
        ));
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
            title: Text(_categoriesCategoryIncome[
                    StandardIncome.values[indexBuilder]] ??
                ""),
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
            title: Text(_categoriesCategoryExpenses[
                    StandardExpense.values[indexBuilder]] ??
                ""),
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
          title: Text(
              _categoriesAccount[StandardAccount.values[indexBuilder]] ?? ""),
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
