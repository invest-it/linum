import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';
import 'package:provider/provider.dart';

class EnterScreenList extends StatefulWidget {
  EnterScreenList({Key? key}) : super(key: key);

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
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    if (enterScreenProvider.isExpenses)
      return EnterScreenListViewBuilder(
          categories: _categoriesExpenses,
          categoriesExpenses: _categoriesExpenses);
    else if (enterScreenProvider.isIncome)
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
