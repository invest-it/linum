import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EnterScreenListViewBuilder extends StatefulWidget {
  final List<EntryCategory> categoriesRepeat;
  EnterScreenListViewBuilder({
    Key? key,
    required this.categoriesRepeat,
  }) : super(key: key);

  @override
  _EnterScreenListViewBuilderState createState() =>
      _EnterScreenListViewBuilderState();
}

class _EnterScreenListViewBuilderState
    extends State<EnterScreenListViewBuilder> {
  // String selectedCategory = "";

  EntryCategory timeEntryCategory =
      EntryCategory(label: 'enter_screen_attribute_date', icon: Icons.event);
  EntryCategory repeatDurationEntryCategory =
      EntryCategory(label: 'enter_screen_attribute_repeat', icon: Icons.loop);

  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2020, 1);
  final lastDate = DateTime(2025, 12);

  TextEditingController? myController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (myController != null) {
      myController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    // BalanceDataProvider balanceDataProvider =
    //     Provider.of<BalanceDataProvider>(context);
    if (myController == null) {
      myController =
          TextEditingController(text: enterScreenProvider.name.toString());
    }
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: proportionateScreenHeight(50),
          ),
          //the text field where the user describes e.g. what he bought
          Container(
            width: proportionateScreenWidth(281),
            child: TextField(
              maxLength: 32,
              controller: myController,
              showCursor: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: _hintTextChooser(enterScreenProvider),
                hintStyle: TextStyle(),
                counter: SizedBox.shrink(),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.headline5,
              onChanged: (_) {
                enterScreenProvider.setName(myController!.text);
              },
            ),
          ),

          Container(
            width: proportionateScreenWidth(300),
            //the list view that contains the different categories
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onCategoryPressed(
                      index,
                      // widget.categoriesTransaction,
                      enterScreenProvider,
                      accountSettingsProvider),
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.background),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2.0,
                                spreadRadius: 0.0,
                                offset: Offset(
                                    0.5, 2.0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Icon(
                            <IconData>[
                              _selectIcon(
                                          EnumToString.fromString(
                                              enterScreenProvider.isExpenses
                                                  ? StandardCategoryExpense
                                                      .values
                                                  : StandardCategoryIncome
                                                      .values,
                                              enterScreenProvider.category),
                                          enterScreenProvider,
                                          accountSettingsProvider)
                                      .icon ??
                                  Icons.error,
                              timeEntryCategory.icon,
                              repeatDurationEntryCategory.icon,
                            ][index],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(AppLocalizations.of(context)!.translate(
                              [
                                "enter_screen_attribute_category",
                                timeEntryCategory.label,
                                repeatDurationEntryCategory.label,
                              ][index],
                            ) +
                            ": "),
                        SizedBox(
                          width: 5,
                        ),
                        //displays the selecte option behind the category/repetiton etc.
                        //e.g. Category : Food <-- Food is the select Text
                        _selectText(index, enterScreenProvider,
                            accountSettingsProvider),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  //function executed when one of the categories (category, account, date etc.) is tapped
  void _onCategoryPressed(int index, EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider) {
    if (index == 1) {
      //opens the date picker
      _openDatePicker(enterScreenProvider);
    } else {
      //opens a modal bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: proportionateScreenHeight(400),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        //icon depending on the category
                        child: Icon(
                          <IconData>[
                            _selectIcon(
                                        EnumToString.fromString(
                                            enterScreenProvider.isExpenses
                                                ? StandardCategoryExpense.values
                                                : StandardCategoryIncome.values,
                                            enterScreenProvider.category),
                                        enterScreenProvider,
                                        accountSettingsProvider)
                                    .icon ??
                                Icons.error,
                            timeEntryCategory.icon,
                            repeatDurationEntryCategory.icon,
                          ][index],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        //text depending on the category
                        _typeChooser(
                          enterScreenProvider,
                          accountSettingsProvider,
                          index,
                        ),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    height: proportionateScreenHeight(300),
                    //which list view is displayed depending on which category is tapped
                    child: _chooseListViewBuilder(
                        enterScreenProvider, index, accountSettingsProvider),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  //which hint text at the upper text field is shown
  String _hintTextChooser(enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return AppLocalizations.of(context)!
          .translate('enter_screen/expenses-textfield-title');
    } else if (enterScreenProvider.isIncome) {
      return AppLocalizations.of(context)!
          .translate('enter_screen/income-textfield-title');
    } else
      return AppLocalizations.of(context)!
          .translate('enter_screen/transaction-textfield-title');
  }

  //which icon will displayed depending on expense etc.
  // Icon _iconChooser(enterScreenProvider, categoriesExpenses, index,
  //     categoriesIncome, categoriesTransaction) {
  //   if (enterScreenProvider.isExpenses) {
  //     return Icon(categoriesExpenses.elementAt(index).icon);
  //   } else if (enterScreenProvider.isIncome) {
  //     return Icon(categoriesIncome.elementAt(index).icon);
  //   } else
  //     return Icon(categoriesTransaction.elementAt(index).icon);
  // }

  //which text will displayed depending on expense etc.
  Text _typeChooser(
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    int index,
  ) {
    return Text(AppLocalizations.of(context)!.translate(
          [
            "enter_screen_attribute_category",
            timeEntryCategory.label,
            repeatDurationEntryCategory.label,
          ][index],
        ) +
        ": ");
  }

  //which lists view is built depending on expense etc.
  ListView _chooseListViewBuilder(EnterScreenProvider enterScreenProvider,
      int index, AccountSettingsProvider accountSettingsProvider) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(
          index, enterScreenProvider, accountSettingsProvider);
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(
          index, enterScreenProvider, accountSettingsProvider);
    } else
      return _listViewBuilderTransaction(index, enterScreenProvider);
  }

  //which list view is built depending on the tapped category at EXPENSES
  ListView _listViewBuilderExpenses(
      int index,
      EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider) {
    if (index == 0) {
      if (enterScreenProvider.isExpenses) {
        return ListView.builder(
          itemCount: accountSettingsProvider.standardCategoryExpenses.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(accountSettingsProvider
                  .standardCategoryExpenses[
                      StandardCategoryExpense.values[indexBuilder]]!
                  .icon),
              title: Text(AppLocalizations.of(context)!.translate(
                  accountSettingsProvider
                      .standardCategoryExpenses[
                          StandardCategoryExpense.values[indexBuilder]]!
                      .label)),
              //selects the item as the categories value
              onTap: () => _selectCategoryItemExpenses(
                StandardCategoryExpense.values[indexBuilder]
                    .toString()
                    .split(".")[1],
                enterScreenProvider,
                accountSettingsProvider
                    .standardCategoryExpenses[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
            );
          },
        );
      } else {
        return ListView.builder(
          itemCount: accountSettingsProvider.standardCategoryExpenses.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(accountSettingsProvider
                  .standardCategoryIncomes[
                      StandardCategoryIncome.values[indexBuilder]]!
                  .icon),
              title: Text(AppLocalizations.of(context)!.translate(
                  accountSettingsProvider
                      .standardCategoryIncomes[
                          StandardCategoryIncome.values[indexBuilder]]!
                      .label)),
              //selects the item as the categories value
              onTap: () => _selectCategoryItemIncome(
                StandardCategoryIncome.values[indexBuilder]
                    .toString()
                    .split(".")[1],
                enterScreenProvider,
                accountSettingsProvider
                    .standardCategoryIncomes[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
            );
          },
        );
      }
      // } else if (index == 1) {
      // return ListView.builder(
      //   itemCount: widget.categoriesAccount.length,
      //   itemBuilder: (BuildContext context, int indexBuilder) {
      //     return ListTile(
      //       leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
      //       title: Text(widget.categoriesAccount[indexBuilder].categoryName),
      //       //selects the item as the account value
      //       onTap: () => _selectAccountItem(
      //         widget.categoriesAccount[indexBuilder].categoryName,
      //         widget.categoriesAccount[indexBuilder].categoryIcon,
      //       ),
      //     );
      //   },
      // );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesRepeat[indexBuilder].icon),
            title: Text(widget.categoriesRepeat[indexBuilder].label),
            //selects the item as the repeat value
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder].label,
              enterScreenProvider,
              widget.categoriesRepeat[indexBuilder].icon,
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at INCOME

  ListView _listViewBuilderIncome(
      int index,
      EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: accountSettingsProvider.standardCategoryIncomes.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(accountSettingsProvider
                .standardCategoryIncomes[
                    StandardCategoryIncome.values[indexBuilder]]!
                .icon),
            title: Text(AppLocalizations.of(context)!.translate(
                accountSettingsProvider
                    .standardCategoryIncomes[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .label)),
            onTap: () => _selectCategoryItemIncome(
              StandardCategoryIncome.values[indexBuilder]
                  .toString()
                  .split(".")[1],
              enterScreenProvider,
              accountSettingsProvider
                  .standardCategoryIncomes[
                      StandardCategoryIncome.values[indexBuilder]]!
                  .icon,
            ),
          );
        },
      );
      // } else if (index == 1) {
      // return ListView.builder(
      //   itemCount: widget.categoriesAccount.length,
      //   itemBuilder: (BuildContext context, int indexBuilder) {
      //     return ListTile(
      //       leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
      //       title: Text(widget.categoriesAccount[indexBuilder].categoryName),
      //       onTap: () => _selectAccountItem(
      //         widget.categoriesAccount[indexBuilder].categoryName,
      //         widget.categoriesAccount[indexBuilder].categoryIcon,
      //       ),
      //     );
      //   },
      // );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesRepeat[indexBuilder].icon),
            title: Text(widget.categoriesRepeat[indexBuilder].label),
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder].label,
              enterScreenProvider,
              widget.categoriesRepeat[indexBuilder].icon,
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at TRANSACTION

  ListView _listViewBuilderTransaction(
      int index, EnterScreenProvider enterScreenProvider) {
    // if (index == 0) {
    //   return ListView.builder(
    //     itemCount: widget.categoriesAccount.length,
    //     itemBuilder: (BuildContext context, int indexBuilder) {
    //       return ListTile(
    //         leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
    //         title: Text(widget.categoriesAccount[indexBuilder].categoryName),
    //         onTap: () => _selectCategoryItemTransactions(
    //           widget.categoriesAccount[indexBuilder].categoryName,
    //           enterScreenProvider,
    //         ),
    //       );
    //     },
    //   );
    // } else if (index == 1) {
    // return ListView.builder(
    //   itemCount: widget.categoriesAccount.length,
    //   itemBuilder: (BuildContext context, int indexBuilder) {
    //     return ListTile(
    //       leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
    //       title: Text(widget.categoriesAccount[indexBuilder].categoryName),
    //       onTap: () => _selectAccountItem(
    //         widget.categoriesAccount[indexBuilder].categoryName,
    //         widget.categoriesAccount[indexBuilder].categoryIcon,
    //       ),
    //     );
    //   },
    // );
    // } else
    return ListView.builder(
      itemCount: widget.categoriesRepeat.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          leading: Icon(widget.categoriesRepeat[indexBuilder].icon),
          title: Text(widget.categoriesRepeat[indexBuilder].label),
          onTap: () => _selectRepeatItem(
            widget.categoriesRepeat[indexBuilder].label,
            enterScreenProvider,
            widget.categoriesRepeat[indexBuilder].icon,
          ),
        );
      },
    );
  }

  //returns the selected value as a text
  Text _selectText(int index, EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider) {
    if (index == 0) {
      if (enterScreenProvider.isExpenses) {
        if (enterScreenProvider.category == "") {
          return Text(AppLocalizations.of(context)!.translate(
              accountSettingsProvider
                  .standardCategoryExpenses[StandardCategoryExpense.None]!
                  .label));
        }
        return Text(AppLocalizations.of(context)!.translate(
            (accountSettingsProvider
                    .standardCategoryExpenses[
                        EnumToString.fromString<StandardCategoryExpense>(
                            StandardCategoryExpense.values,
                            enterScreenProvider.category)]
                    ?.label ??
                'chosen expense')));
      } else {
        if (enterScreenProvider.category == "") {
          return Text(AppLocalizations.of(context)!.translate(
              accountSettingsProvider
                  .standardCategoryIncomes[StandardCategoryIncome.None]!
                  .label));
        }
        return Text(AppLocalizations.of(context)!.translate(
            (accountSettingsProvider
                    .standardCategoryIncomes[
                        EnumToString.fromString<StandardCategoryIncome>(
                            StandardCategoryIncome.values,
                            enterScreenProvider.category)]
                    ?.label ??
                'chosen income')));
      }
    } else if (index == 1) {
      String langCode = AppLocalizations.of(context)!.locale.languageCode;

      DateFormat formatter = DateFormat('dd. MMMM yyyy', langCode);
      return Text(formatter.format(enterScreenProvider.selectedDate));
    } else if (index == 2) {
      return Text(enterScreenProvider.repeat);
    } else {
      log("Something has gone wrong with the index in enter_screen_listviewbuilder.dart");
      return Text(AppLocalizations.of(context)!.translate("main/label-error"));
    }
  }

  Icon _selectIcon(dynamic index, EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider) {
    if (enterScreenProvider.isExpenses) {
      if (index.runtimeType != StandardCategoryExpense) {
        log("Error index had wrong type to choose icon");
        log("assumed: " +
            index.runtimeType.toString() +
            " to be StandardCategoryExpense");
        return Icon(Icons.error);
      }
      return Icon(
          accountSettingsProvider.standardCategoryExpenses[index]!.icon);
    } else if (enterScreenProvider.isIncome) {
      if (index.runtimeType != StandardCategoryIncome) {
        log("Error index had wrong type to choose icon");
        log("assumed: " +
            index.runtimeType.toString() +
            " to be StandardCategoryIncome");

        return Icon(Icons.error);
      }
      return Icon(accountSettingsProvider.standardCategoryIncomes[index]!.icon);
    }
    return Icon(Icons.error);
  }

//functions that set the category, account item etc when tapped
  void _selectCategoryItemExpenses(
      String name, enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    enterScreenProvider.setCategory(name);
  }

  void _selectCategoryItemIncome(
      String name, enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    enterScreenProvider.setCategory(name);
  }

  // ignore: unused_element
  void _selectCategoryItemTransactions(
      String name, EnterScreenProvider enterScreenProvider) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setCategory(name);
    });
  }

  void _selectRepeatItem(
      String name, EnterScreenProvider enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    // setState(() {
    //   categoriesRepeatIcon = Icon(icon);
    // });
  }

  void _openDatePicker(EnterScreenProvider enterScreenProvider) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: enterScreenProvider.selectedDate,
      //which date will display when user open the picker
      firstDate: firstDate,
      //what will be the previous supported year in picker
      lastDate: lastDate,
    ); //what will be the up to supported date in picker

    //then usually do the future job
    if (pickedDate == null) {
      //if user tap cancel then this function will stop
      return;
    }
    TimeOfDay? timeOfDay =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (timeOfDay != null) {
      enterScreenProvider.setSelectedDate(
        pickedDate.add(
          Duration(
            hours: timeOfDay.hour,
            minutes: timeOfDay.minute,
          ),
        ),
      );
    }
  }

  // String validateMyInput(String value) {
  //   RegExp regex = new RegExp(r'^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,4})?$');
  //   if (!regex.hasMatch(value))
  //     return 'Enter Valid Number';
  //   else
  //     return 'Nothing';
  // }
}
