import 'package:flutter/material.dart';

class EnterScreenList extends StatefulWidget {
  final bool isExpenses;
  final bool isIncome;

  EnterScreenList({Key? key, required this.isExpenses, required this.isIncome})
      : super(key: key);

  @override
  State<EnterScreenList> createState() => _EnterScreenListState();
}

class _EnterScreenListState extends State<EnterScreenList> {
  List<Category> _categoriesExpenses = [
    Category("Category", Icons.ac_unit),
    Category("Account", Icons.create_new_folder),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  List<Category> _categoriesIncome = [
    Category("Category", Icons.ac_unit),
    Category("Account", Icons.create_new_folder),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  List<Category> _categoriesTransaction = [
    Category("Account", Icons.create_new_folder),
    Category("To Account", Icons.ac_unit),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  String _selectedItem = "";

  @override
  Widget build(BuildContext context) {
    if (widget.isExpenses)
      return Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _categoriesExpenses.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _onCategoryPressed(),
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
                          child: Icon(_categoriesExpenses[index].icon),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(_categoriesExpenses[index].type + ":"),
                        Text(_selectedItem),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ),
      );
    else if (widget.isIncome)
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            itemCount: _categoriesIncome.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.background),
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
                      child: Icon(_categoriesIncome[index].icon),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_categoriesIncome[index].type + ":"),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      );
    else
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _categoriesTransaction.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background),
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
                        child: Icon(_categoriesTransaction[index].icon),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(_categoriesTransaction[index].type + ":"),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ),
      );
  }

  void _onCategoryPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('hello'),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('hello'),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('hello'),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('hello'),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('hello'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
  }
}

class Category {
  String type;
  IconData icon;
  Category(this.type, this.icon);
}
