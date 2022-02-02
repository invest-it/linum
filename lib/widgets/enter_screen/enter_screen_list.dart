import 'package:flutter/foundation.dart';
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
  //all the lists that are displayed in the enter screen
  final List<Category> _categoriesExpenses = [
    Category("Kategorie", Icons.restaurant),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];

  final List<Category> _categoriesIncome = [
    Category("Kategorie", Icons.payments),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];

  final List<Category> _categoriesTransaction = [
    Category("Von Account", Icons.local_atm),
    Category("Zu Account", Icons.local_atm),
    Category("Datum", Icons.event),
    Category("Wiederholen", Icons.loop),
  ];
  final List<Category2> _categoriesCategoryExpenses = [
    Category2("Essen & Trinken", Icons.food_bank_outlined),
    Category2("Freizeit", Icons.beach_access),
    Category2("Haus", Icons.home),
    Category2("Lebensstil", Icons.soap),
    Category2("Auto/Nahverkehr", Icons.car_rental),
    Category2("Diverses", Icons.radio),
  ];

  final List<Category2> _categoriesCategoryIncome = [
    Category2("Gehalt", Icons.work),
    Category2("Taschengeld", Icons.wallet_giftcard),
    Category2("Nebenjob", Icons.home_work),
    Category2("Investitionen", Icons.upgrade),
    Category2("Zinsen", Icons.assignment_return),
    Category2("Diverses", Icons.money),
  ];

  final List<Category2> _categoriesRepeat = [
    Category2("Täglich", Icons.calendar_today),
    Category2("Wöchentlich", Icons.next_week),
    Category2("Monatlich zum 1.", Icons.calendar_view_month),
    Category2("Frei auswählen", Icons.repeat),
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

class Category2 {
  String categoryName;
  IconData categoryIcon;
  Category2(this.categoryName, this.categoryIcon);
}
