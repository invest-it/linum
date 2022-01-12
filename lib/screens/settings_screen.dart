import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/enter_screen/enter_screen_list.dart';
//import 'package:linum/providers/balance_data_provider.dart';
//import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _toggled = false;

  final List<String> _categoriesCategoryExpenses = [
    "Essen & Trinken",
    "Freizeit",
    "Haus",
    "Lebensstil",
    "Auto/Nahverkehr",
    "Diverses",
  ];

  final List<String> _categoriesCategoryIncome = [
    "Gehalt",
    "Taschengeld",
    "Nebenjob",
    "Investitionen",
    "Kindergeld",
    "Zinsen",
    "Diverses",
  ];

  final List<String> _categoriesAccount = [
    "Debitkarte",
    "Kreditkarte",
    "Bargeld",
    "Depot",
  ];

  final List<String> _currency = [
    "Euro",
    "Dollar",
    "Japanese Yen",
    "Pound",
  ];

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    // BalanceDataProvider balanceDataProvider =
    //     Provider.of<BalanceDataProvider>(context);
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
                      Text('Währung'),
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
                                    title: Text('Währungen'),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: _currencyChange(
                                      _currency,
                                    ),
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                        child: ListTile(
                          // onTap: ontap(),
                          title: Text('Währung auswählen...'),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ),
                      ),
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
                      Text('Standard Kategorien'),
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
                                    child: _incomeListViewBuilder(
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
                                    child: _incomeListViewBuilder(
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
                        Text('Besondere Einstellungen'),
                        SwitchListTile(
                          // onTap: ontap(),
                          title: Text('Schwabenmodus'),
                          value: _toggled,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState((() {
                              _toggled = value;
                            }));
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ],
        ));
  }

  //ListView.builder für Standard Kategorien

  _incomeListViewBuilder(_categoriesCategoryIncome) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _categoriesCategoryIncome.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(_categoriesCategoryIncome[indexBuilder]),
          // onTap: () => _selectCategoryItem(
          //     widget.categoriesCategoryIncome[indexBuilder],
          //     enterScreenProvider),
        );
      },
    );
  }

  _expensesListViewBuilder(_categoriesCategoryExpenses) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _categoriesCategoryExpenses.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(_categoriesCategoryExpenses[indexBuilder]),
          // onTap: () => _selectCategoryItem(
          //     widget.categoriesCategoryIncome[indexBuilder],
          //     enterScreenProvider),
        );
      },
    );
  }

  _accountListViewBuilder(_categoriesAccount) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _categoriesAccount.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          //leading: Icon(widget.categories[index].icon),
          title: Text(_categoriesAccount[indexBuilder]),
          // onTap: () => _selectCategoryItem(
          //     widget.categoriesCategoryIncome[indexBuilder],
          //     enterScreenProvider),
        );
      },
    );
  }

  _currencyChange(_currency) {
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
}
