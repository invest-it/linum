import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:provider/provider.dart';

class EnterScreenListViewBuilder extends StatefulWidget {
  List categories;
  List categoriesExpenses;
  EnterScreenListViewBuilder(
      {Key? key, required this.categories, required this.categoriesExpenses})
      : super(key: key);

  @override
  _EnterScreenListViewBuilderState createState() =>
      _EnterScreenListViewBuilderState();
}

class _EnterScreenListViewBuilderState
    extends State<EnterScreenListViewBuilder> {
  final List<String> _categoriesCategoryExpenses = [
    "Category 1",
    "Category 2",
    "Category 3",
    "Category 4",
    "Category 5",
    "Category 6",
  ];

  final List<String> _categoriesCategoryIncome = [
    "Category Income1",
    "Category Income2",
    "Category Income3",
    "Category Income4",
    "Category Income5",
    "Category Income6",
  ];

  final List<String> _categoriesAccount = [
    "Account 1",
    "Account 2",
    "Account 3",
    "Account 4",
    "Account 5",
    "Account 6",
  ];

  final List<String> _categoriesRepeat = [
    "Every day",
    "Every week",
    "Every month on the 1st",
    "Every quarter",
    "Every year",
  ];

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
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              controller: myController,
              showCursor: true,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: enterScreenProvider.isExpenses
                    ? "What did you buy?"
                    : "How did you make money?",
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
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: widget.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onCategoryPressed(
                      index, widget.categoriesExpenses, enterScreenProvider),
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

  void _onCategoryPressed(int index, categoriesExpenses, enterScreenProvider) {
    print(
      index.toString(),
    );
    if (index == 2) {
      _openDatePicker(enterScreenProvider);
    } else
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
                        child: Icon(categoriesExpenses.elementAt(index).icon),
                      ),
                    ),
                    Column(
                      children: [
                        Text(categoriesExpenses.elementAt(index).type),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    height: 300,
                    child: _chooseListViewBuilder(index, enterScreenProvider),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  _chooseListViewBuilder(enterScreenProvider, index) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(index, enterScreenProvider);
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(index, enterScreenProvider);
    }
    return _listViewBuilderTransaction(index, enterScreenProvider);
  }

  _listViewBuilderExpenses(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: _categoriesCategoryExpenses.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesCategoryExpenses[indexBuilder]),
            onTap: () => _selectCategoryItem(
                _categoriesCategoryExpenses[indexBuilder], enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: _categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesAccount[indexBuilder]),
            onTap: () => _selectAccountItem(
              _categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: _categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesRepeat[indexBuilder]),
            onTap: () => _selectRepeatItem(
              _categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }

  _listViewBuilderIncome(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: _categoriesCategoryIncome.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesCategoryIncome[indexBuilder]),
            onTap: () => _selectCategoryItem(
                _categoriesCategoryIncome[indexBuilder], enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: _categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesAccount[indexBuilder]),
            onTap: () => _selectAccountItem(
              _categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: _categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesRepeat[indexBuilder]),
            onTap: () => _selectRepeatItem(
              _categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }

  _listViewBuilderTransaction(index, enterScreenProvider) {
    if (index == 0) {
      return ListView.builder(
        itemCount: _categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesAccount[indexBuilder]),
            onTap: () => _selectCategoryItem(
                _categoriesAccount[indexBuilder], enterScreenProvider),
          );
        },
      );
    } else if (index == 1) {
      return ListView.builder(
        itemCount: _categoriesAccount.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesAccount[indexBuilder]),
            onTap: () => _selectAccountItem(
              _categoriesAccount[indexBuilder],
            ),
          );
        },
      );
    } else
      return ListView.builder(
        itemCount: _categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(widget.categories[index].icon),
            title: Text(_categoriesRepeat[indexBuilder]),
            onTap: () => _selectRepeatItem(
              _categoriesRepeat[indexBuilder],
            ),
          );
        },
      );
  }

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
