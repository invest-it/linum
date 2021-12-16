import 'package:flutter/material.dart';

class EnterScreenList extends StatelessWidget {
  final bool isExpenses;
  final bool isIncome;
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
    Category("Beep", Icons.access_time_sharp),
  ];
  final List<int> colorCodes = <int>[600, 500, 100];
  EnterScreenList({Key? key, required this.isExpenses, required this.isIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExpenses)
      return Center(
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _categoriesExpenses.length,
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
                      child: Icon(_categoriesExpenses[index].icon),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(_categoriesExpenses[index].type + ":"),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      );
    else if (isIncome)
      return Center(
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.separated(
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
          height: 500,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView.separated(
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
      );
  }
}

class Category {
  String type;
  IconData icon;
  Category(this.type, this.icon);
}
