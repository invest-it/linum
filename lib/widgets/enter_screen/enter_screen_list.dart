import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';
import 'package:provider/provider.dart';

class EnterScreenList extends StatefulWidget {
  EnterScreenList({Key? key}) : super(key: key);

  @override
  State<EnterScreenList> createState() => _EnterScreenListState();
}

class _EnterScreenListState extends State<EnterScreenList> {
  //all the lists that are displayed in the enter screen
  final List<Category> _categoriesExpenses = [
    Category("Kategorie", Icons.restaurant),
    Category("Account", Icons.local_atm),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];

  final List<Category> _categoriesIncome = [
    Category("Kategorie", Icons.payments),
    Category("Account", Icons.local_atm),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];

  final List<Category> _categoriesTransaction = [
    Category("Von Account", Icons.local_atm),
    Category("Zu Account", Icons.local_atm),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];
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

  final List<String> _categoriesRepeat = [
    "Täglich",
    "Wöchentlich",
    "Monatlich zum 1.",
    "Zum Quartalsbeginn",
    "Jährlich",
    "Frei auswählen"
  ];

  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    //returns a different list view builder depending on the page
    if (enterScreenProvider.isExpenses)
      return EnterScreenListViewBuilder(
        categories: _categoriesExpenses,
        categoriesExpenses: _categoriesExpenses,
        categoriesIncome: _categoriesIncome,
        categoriesTransaction: _categoriesTransaction,
        categoriesAccount: _categoriesAccount,
        categoriesCategoryExpenses: _categoriesCategoryExpenses,
        categoriesCategoryIncome: _categoriesCategoryIncome,
        categoriesRepeat: _categoriesRepeat,
      );
    else if (enterScreenProvider.isIncome)
      return EnterScreenListViewBuilder(
        categories: _categoriesIncome,
        categoriesExpenses: _categoriesExpenses,
        categoriesIncome: _categoriesIncome,
        categoriesTransaction: _categoriesTransaction,
        categoriesAccount: _categoriesAccount,
        categoriesCategoryExpenses: _categoriesCategoryExpenses,
        categoriesCategoryIncome: _categoriesCategoryIncome,
        categoriesRepeat: _categoriesRepeat,
      );
    else
      return EnterScreenListViewBuilder(
        categories: _categoriesTransaction,
        categoriesExpenses: _categoriesExpenses,
        categoriesIncome: _categoriesIncome,
        categoriesTransaction: _categoriesTransaction,
        categoriesAccount: _categoriesAccount,
        categoriesCategoryExpenses: _categoriesCategoryExpenses,
        categoriesCategoryIncome: _categoriesCategoryIncome,
        categoriesRepeat: _categoriesRepeat,
      );
  }
}

class Category {
  String type;
  IconData icon;
  Category(this.type, this.icon);
}
