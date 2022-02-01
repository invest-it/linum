import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/decimal_text_input_formatter.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:provider/provider.dart';

import 'enter_screen_list.dart';

class EnterScreenListViewBuilder extends StatefulWidget {
  //all the lists from the enter_screen_list.dart file
  List<Category> categories;
  List<Category> categoriesExpenses;
  List<Category> categoriesIncome;
  List<Category> categoriesTransaction;
  List<Category2> categoriesCategoryExpenses;
  List<Category2> categoriesCategoryIncome;
  List<Category2> categoriesAccount;
  List<Category2> categoriesRepeat;
  EnterScreenListViewBuilder({
    Key? key,
    required this.categories,
    required this.categoriesExpenses,
    required this.categoriesIncome,
    required this.categoriesTransaction,
    required this.categoriesAccount,
    required this.categoriesCategoryExpenses,
    required this.categoriesCategoryIncome,
    required this.categoriesRepeat,
  }) : super(key: key);

  @override
  _EnterScreenListViewBuilderState createState() =>
      _EnterScreenListViewBuilderState();
}

class _EnterScreenListViewBuilderState
    extends State<EnterScreenListViewBuilder> {
  String selectedCategory = "";
  String selectedAccount = "";
  Icon categoriesCategoryExpensesIcon = Icon(Icons.restaurant);
  Icon categoriesAccountIcon = Icon(Icons.local_atm);
  Icon categoriesCategoryIncomeIcon = Icon(Icons.payments);
  Icon categoriesRepeatIcon = Icon(Icons.loop);

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
              maxLength: 18,
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
              itemCount: widget.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onCategoryPressed(
                      index,
                      widget.categoriesExpenses,
                      widget.categoriesIncome,
                      widget.categoriesTransaction,
                      enterScreenProvider),
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
                          child: _selectIcon(index, enterScreenProvider),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(widget.categories[index].type + ":"),
                        SizedBox(
                          width: 5,
                        ),
                        //displays the selecte option behind the category/repetiton etc.
                        //e.g. Category : Food <-- Food is the select Text
                        _selectText(index, enterScreenProvider),
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
  void _onCategoryPressed(int index, categoriesExpenses, categoriesIncome,
      categoriesTransaction, enterScreenProvider) {
    if (index == 2) {
      //opens the date picker
      _openDatePicker(enterScreenProvider);
    } else
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
                          child: _selectIcon(index, enterScreenProvider)),
                    ),
                    Column(
                      children: [
                        //text depending on the category
                        _typeChooser(enterScreenProvider, categoriesExpenses,
                            index, categoriesIncome, categoriesTransaction),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    height: proportionateScreenHeight(300),
                    //which list view is displayed depending on which category is tapped
                    child: _chooseListViewBuilder(enterScreenProvider, index),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  //which hint text at the upper text field is shown
  String _hintTextChooser(enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return "Was hast du gekauft?";
    } else if (enterScreenProvider.isIncome) {
      return "Wie heißt dieses Einkommen?";
    } else
      return "Wie heißt diese Transaktion?";
  }

  //which icon will displayed depending on expense etc.
  Icon _iconChooser(enterScreenProvider, categoriesExpenses, index,
      categoriesIncome, categoriesTransaction) {
    if (enterScreenProvider.isExpenses) {
      return Icon(categoriesExpenses.elementAt(index).icon);
    } else if (enterScreenProvider.isIncome) {
      return Icon(categoriesIncome.elementAt(index).icon);
    } else
      return Icon(categoriesTransaction.elementAt(index).icon);
  }

  //which text will displayed depending on expense etc.
  Text _typeChooser(enterScreenProvider, categoriesExpenses, index,
      categoriesIncome, categoriesTransaction) {
    if (enterScreenProvider.isExpenses) {
      return Text(categoriesExpenses.elementAt(index).type);
    } else if (enterScreenProvider.isIncome) {
      return Text(categoriesIncome.elementAt(index).type);
    } else
      return Text(categoriesTransaction.elementAt(index).type);
  }

  //which lists view is built depending on expense etc.
  ListView _chooseListViewBuilder(enterScreenProvider, index) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(index, enterScreenProvider);
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(index, enterScreenProvider);
    } else
      return _listViewBuilderTransaction(index, enterScreenProvider);
  }

  //which list view is built depending on the tapped category at EXPENSES
  ListView _listViewBuilderExpenses(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesCategoryExpenses.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
                widget.categoriesCategoryExpenses[indexBuilder].categoryIcon),
            title: Text(
                widget.categoriesCategoryExpenses[indexBuilder].categoryName),
            //selects the item as the categories value
            onTap: () => _selectCategoryItemExpenses(
              widget.categoriesCategoryExpenses[indexBuilder].categoryName,
              enterScreenProvider,
              widget.categoriesCategoryExpenses[indexBuilder].categoryIcon,
            ),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
            title: Text(widget.categoriesAccount[indexBuilder].categoryName),
            //selects the item as the account value
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder].categoryName,
              widget.categoriesAccount[indexBuilder].categoryIcon,
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesRepeat[indexBuilder].categoryIcon),
            title: Text(widget.categoriesRepeat[indexBuilder].categoryName),
            //selects the item as the repeat value
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder].categoryName,
              enterScreenProvider,
              widget.categoriesRepeat[indexBuilder].categoryIcon,
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at INCOME

  ListView _listViewBuilderIncome(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesCategoryIncome.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
                widget.categoriesCategoryIncome[indexBuilder].categoryIcon),
            title: Text(
                widget.categoriesCategoryIncome[indexBuilder].categoryName),
            onTap: () => _selectCategoryItemIncome(
              widget.categoriesCategoryIncome[indexBuilder].categoryName,
              enterScreenProvider,
              widget.categoriesCategoryIncome[indexBuilder].categoryIcon,
            ),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
            title: Text(widget.categoriesAccount[indexBuilder].categoryName),
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder].categoryName,
              widget.categoriesAccount[indexBuilder].categoryIcon,
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesRepeat[indexBuilder].categoryIcon),
            title: Text(widget.categoriesRepeat[indexBuilder].categoryName),
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder].categoryName,
              enterScreenProvider,
              widget.categoriesRepeat[indexBuilder].categoryIcon,
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at TRANSACTION

  ListView _listViewBuilderTransaction(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
            title: Text(widget.categoriesAccount[indexBuilder].categoryName),
            onTap: () => _selectCategoryItemTransactions(
              widget.categoriesAccount[indexBuilder].categoryName,
              enterScreenProvider,
            ),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
            title: Text(widget.categoriesAccount[indexBuilder].categoryName),
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder].categoryName,
              widget.categoriesAccount[indexBuilder].categoryIcon,
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categoriesRepeat[indexBuilder].categoryIcon),
            title: Text(widget.categoriesRepeat[indexBuilder].categoryName),
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder].categoryName,
              enterScreenProvider,
              widget.categoriesRepeat[indexBuilder].categoryIcon,
            ),
          );
        },
      );
  }

  //returns the selected value as a text
  Text _selectText(index, enterScreenProvider) {
    if (index == 0) {
      return Text(enterScreenProvider.category);
    } else if (index == 1) {
      return Text(selectedAccount);
    } else if (index == 2) {
      return Text(enterScreenProvider.selectedDate.toString().split(' ')[0]);
    } else if (index == 3) {
      return Text(enterScreenProvider.repeat);
    } else
      return Text("Trash");
  }

  Icon _selectIcon(index, EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      if (index == 0) {
        return categoriesCategoryExpensesIcon; //categoriesCategoryExpensesIcon;
      } else if (index == 1) {
        return categoriesAccountIcon;
      } else if (index == 2) {
        return Icon(Icons.event);
      } else if (index == 3) {
        return categoriesRepeatIcon;
      }
    } else if (enterScreenProvider.isIncome) {
      if (index == 0) {
        return categoriesCategoryIncomeIcon; //categoriesCategoryExpensesIcon;
      } else if (index == 1) {
        return categoriesAccountIcon;
      } else if (index == 2) {
        return Icon(Icons.event);
      } else if (index == 3) {
        return categoriesRepeatIcon;
      }
    } else if (enterScreenProvider.isTransaction) {
      if (index == 0) {
        return categoriesAccountIcon; //categoriesCategoryExpensesIcon;
      } else if (index == 1) {
        return categoriesAccountIcon;
      } else if (index == 2) {
        return Icon(Icons.event);
      } else if (index == 3) {
        return categoriesRepeatIcon;
      }
    }
    return Icon(Icons.error);
  }

//functions that set the category, account item etc when tapped
  void _selectCategoryItemExpenses(
      String name, enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setCategory(name);
      categoriesCategoryExpensesIcon = Icon(icon);
    });
  }

  void _selectCategoryItemIncome(
      String name, enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setCategory(name);
      categoriesCategoryIncomeIcon = Icon(icon);
    });
  }

  void _selectCategoryItemTransactions(String name, enterScreenProvider) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setCategory(name);
    });
  }

  void _selectAccountItem(String name, IconData icon) {
    Navigator.pop(context);
    setState(() {
      selectedAccount = name;
      categoriesAccountIcon = Icon(icon);
    });
  }

  void _selectRepeatItem(String name, enterScreenProvider, IconData icon) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setRepeat(name);
      categoriesRepeatIcon = Icon(icon);
    });
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
