import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/entry_category.dart';
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
  final List<EntryCategory> _categoriesExpenses = [
    EntryCategory(label: "Kategorie", icon: Icons.restaurant),
    EntryCategory(label: "Datum", icon: Icons.event),
    EntryCategory(label: "Wiederholen", icon: Icons.loop),
  ];

  final List<EntryCategory> _categoriesIncome = [
    EntryCategory(label: "Kategorie", icon: Icons.payments),
    EntryCategory(label: "Datum", icon: Icons.event),
    EntryCategory(label: "Wiederholen", icon: Icons.loop),
  ];

  // final List<EntryCategory> _categoriesTransaction = [
  //   EntryCategory("Von Account", Icons.local_atm),
  //   EntryCategory("Zu Account", Icons.local_atm),
  //   EntryCategory("Datum", Icons.event),
  //   EntryCategory("Wiederholen", Icons.loop),
  // ];

  final List<EntryCategory> _categoriesRepeat = [
    EntryCategory(label: "Täglich", icon: Icons.calendar_today),
    EntryCategory(label: "Wöchentlich", icon: Icons.next_week),
    EntryCategory(label: "Monatlich zum 1.", icon: Icons.calendar_view_month),
    EntryCategory(label: "Frei auswählen", icon: Icons.repeat),
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
        categoriesRepeat: _categoriesRepeat,
      );
    else if (enterScreenProvider.isIncome)
      return EnterScreenListViewBuilder(
        categories: _categoriesIncome,
        categoriesExpenses: _categoriesExpenses,
        categoriesIncome: _categoriesIncome,
        categoriesRepeat: _categoriesRepeat,
      );
    // else {
    //   return EnterScreenListViewBuilder(
    //     categories: _categoriesTransaction,
    //     categoriesExpenses: _categoriesExpenses,
    //     categoriesIncome: _categoriesIncome,
    //     categoriesRepeat: _categoriesRepeat,
    //   );
    // }
    else {
      return Text('Unexpected Error');
    }
  }
}
