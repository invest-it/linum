import 'package:flutter/material.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';

class EnterScreenList extends StatefulWidget {
   bool isExpenses;
   bool isIncome;

  EnterScreenList({Key? key, required this.isExpenses, required this.isIncome})
      : super(key: key);

  @override
  State<EnterScreenList> createState() => _EnterScreenListState();
}

class _EnterScreenListState extends State<EnterScreenList> {
  final List<Category> _categoriesExpenses = [
    Category("Category", Icons.restaurant),
    Category("Account", Icons.local_atm),
    Category("Date", Icons.event),
    Category("Repeat", Icons.loop),
  ];

  final List<Category> _categoriesIncome = [
    Category("Category", Icons.payments),
    Category("To Category", Icons.local_atm),
    Category("Date", Icons.event),
    Category("Repeat", Icons.loop),
  ];

  final List<Category> _categoriesTransaction = [
    Category("Account", Icons.local_atm),
    Category("To Account", Icons.local_atm),
    Category("Date", Icons.event),
    Category("Repeat", Icons.loop),
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
