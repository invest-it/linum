import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/enter_screen_listviewbuilder.dart';

class EnterScreenList extends StatefulWidget {
  final bool isExpenses;
  final bool isIncome;

  EnterScreenList({Key? key, required this.isExpenses, required this.isIncome})
      : super(key: key);

  @override
  State<EnterScreenList> createState() => _EnterScreenListState();
}

class _EnterScreenListState extends State<EnterScreenList> {
  final List<Category> _categoriesExpenses = [
    Category("Category", Icons.ac_unit),
    Category("Account", Icons.create_new_folder),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  final List<Category> _categoriesIncome = [
    Category("Category", Icons.ac_unit),
    Category("Account", Icons.create_new_folder),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  final List<Category> _categoriesTransaction = [
    Category("Account", Icons.create_new_folder),
    Category("To Account", Icons.ac_unit),
    Category("Date", Icons.access_alarm_outlined),
    Category("Repeat", Icons.access_time_sharp),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.isExpenses)
      return EnterScreenListViewBuilder(
          categories: _categoriesExpenses,
          categoriesExpenses: _categoriesExpenses);
    else if (widget.isIncome)
      return EnterScreenListViewBuilder(
        categories: _categoriesIncome,
        categoriesExpenses: _categoriesExpenses,
      );
    else
      return EnterScreenListViewBuilder(
        categories: _categoriesTransaction,
        categoriesExpenses: _categoriesExpenses,
      );
  }
}

class Category {
  String type;
  IconData icon;
  Category(this.type, this.icon);
}
