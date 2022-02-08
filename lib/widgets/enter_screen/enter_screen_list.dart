import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
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
  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);

    //all the lists that are displayed in the enter screen
    // final List<EntryCategory> _categoriesExpenses = [
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_category'),
    //       icon: Icons.restaurant),
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_date'),
    //       icon: Icons.event),
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_repeat'),
    //       icon: Icons.loop),
    // ];

    // final List<EntryCategory> _categoriesIncome = [
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_category'),
    //       icon: Icons.payments),
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_date'),
    //       icon: Icons.event),
    //   EntryCategory(
    //       label: AppLocalizations.of(context)!
    //           .translate('enter_screen_attribute_repeat'),
    //       icon: Icons.loop),
    // ];

    // final List<EntryCategory> _categoriesTransaction = [
    //   EntryCategory("Von Account", Icons.local_atm),
    //   EntryCategory("Zu Account", Icons.local_atm),
    //   EntryCategory("Datum", Icons.event),
    //   EntryCategory("Wiederholen", Icons.loop),
    // ];

    final List<EntryCategory> _categoriesRepeat = [
      EntryCategory(
          label: AppLocalizations.of(context)!
              .translate('enter_screen/label-repeat-daily'),
          icon: Icons.calendar_today),
      EntryCategory(
          label: AppLocalizations.of(context)!
              .translate('enter_screen/label-repeat-weekly'),
          icon: Icons.next_week),
      EntryCategory(
          label: AppLocalizations.of(context)!
              .translate('enter_screen/label-repeat-monthly'),
          icon: Icons.calendar_view_month),
      EntryCategory(
          label: AppLocalizations.of(context)!
              .translate('enter_screen/label-repeat-freeselect'),
          icon: Icons.repeat),
    ];

    //returns a different list view builder depending on the page
    if (enterScreenProvider.isExpenses)
      return EnterScreenListViewBuilder(
        categoriesRepeat: _categoriesRepeat,
      );
    else if (enterScreenProvider.isIncome)
      return EnterScreenListViewBuilder(
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
