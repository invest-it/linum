import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:provider/provider.dart';

class EnterScreenListViewBuilder extends StatefulWidget {
  //all the lists from the enter_screen_list.dart file
  List categories;
  List categoriesExpenses;
  List categoriesIncome;
  List categoriesTransaction;
  List categoriesCategoryExpenses;
  List categoriesCategoryIncome;
  List categoriesAccount;
  List categoriesRepeat;
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
  String selectedRepetition = "";

  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2020, 1);
  final lastDate = DateTime(2025, 12);

  TextEditingController myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          //the text field where the user describes e.g. what he bought
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              controller: myController,
              showCursor: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: _hintTextChooser(enterScreenProvider),
                hintStyle: TextStyle(),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (_) {
                enterScreenProvider.setName(myController.text);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
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
                          child: Icon(widget.categories[index].icon),
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
    print(
      index.toString(),
    );
    if (index == 2) {
      //opens the date picker
      _openDatePicker(enterScreenProvider);
    } else
      //opens a modal bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        //icon depending on the category
                        child: _iconChooser(
                            enterScreenProvider,
                            categoriesExpenses,
                            index,
                            categoriesIncome,
                            categoriesTransaction),
                      ),
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
                    height: 300,
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
  _hintTextChooser(enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return "Was hast du gekauft?";
    } else if (enterScreenProvider.isIncome) {
      return "Wie heißt dieses Einkommen?";
    } else
      return "Wie heißt diese Transaktion?";
  }

  //which icon will displayed depending on expense etc.
  _iconChooser(enterScreenProvider, categoriesExpenses, index, categoriesIncome,
      categoriesTransaction) {
    if (enterScreenProvider.isExpenses) {
      return Icon(categoriesExpenses.elementAt(index).icon);
    } else if (enterScreenProvider.isIncome) {
      return Icon(categoriesIncome.elementAt(index).icon);
    } else
      return Icon(categoriesTransaction.elementAt(index).icon);
  }

  //which text will displayed depending on expense etc.
  _typeChooser(enterScreenProvider, categoriesExpenses, index, categoriesIncome,
      categoriesTransaction) {
    if (enterScreenProvider.isExpenses) {
      return Text(categoriesExpenses.elementAt(index).type);
    } else if (enterScreenProvider.isIncome) {
      return Text(categoriesIncome.elementAt(index).type);
    } else
      return Text(categoriesTransaction.elementAt(index).type);
  }

  //which lists view is built depending on expense etc.
  _chooseListViewBuilder(enterScreenProvider, index) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(index, enterScreenProvider);
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(index, enterScreenProvider);
    } else
      return _listViewBuilderTransaction(index, enterScreenProvider);
  }

  //which list view is built depending on the tapped category at EXPENSES
  _listViewBuilderExpenses(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesCategoryExpenses.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesCategoryExpenses[indexBuilder]),
            //selects the item as the categories value
            onTap: () => _selectCategoryItem(
                widget.categoriesCategoryExpenses[indexBuilder],
                enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesAccount[indexBuilder]),
            //selects the item as the account value
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesRepeat[indexBuilder]),
            //selects the item as the repeat value
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at INCOME

  _listViewBuilderIncome(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesCategoryIncome.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesCategoryIncome[indexBuilder]),
            onTap: () => _selectCategoryItem(
                widget.categoriesCategoryIncome[indexBuilder],
                enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesAccount[indexBuilder]),
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesRepeat[indexBuilder]),
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }
  //which list view is built depending on the tapped category at TRANSACTION

  _listViewBuilderTransaction(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesAccount[indexBuilder]),
            onTap: () => _selectCategoryItem(
                widget.categoriesAccount[indexBuilder], enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: widget.categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesAccount[indexBuilder]),
            onTap: () => _selectAccountItem(
              widget.categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: widget.categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(widget.categoriesRepeat[indexBuilder]),
            onTap: () => _selectRepeatItem(
              widget.categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }

  //returns the selected value as a text
  _selectText(index, enterScreenProvider) {
    if (index == 0) {
      return Text(enterScreenProvider.category);
    } else if (index == 1) {
      return Text(selectedAccount);
    } else if (index == 2) {
      return Text(enterScreenProvider.selectedDate.toString().split(' ')[0]);
    } else if (index == 3) {
      return Text(selectedRepetition);
    } else
      return Text("Trash");
  }

//functions that set the category, account item etc when tapped
  void _selectCategoryItem(String name, enterScreenProvider) {
    Navigator.pop(context);
    setState(() {
      enterScreenProvider.setCategory(name);
    });
  }

  void _selectAccountItem(String name) {
    Navigator.pop(context);
    setState(() {
      selectedAccount = name;
    });
  }

  void _selectRepeatItem(String name) {
    Navigator.pop(context);
    setState(() {
      selectedRepetition = name;
    });
  }

  void _openDatePicker(EnterScreenProvider enterScreenProvider) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: firstDate,
            //what will be the previous supported year in picker
            lastDate:
                lastDate) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        enterScreenProvider.setSelectedDate(pickedDate);
      });
    });
  }
}
