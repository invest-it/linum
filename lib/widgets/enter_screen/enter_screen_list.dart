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
  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);

    //returns a different list view builder depending on the page

    return EnterScreenListViewBuilder();
    // else {
    //   return EnterScreenListViewBuilder(
    //     categories: _categoriesTransaction,
    //     categoriesExpenses: _categoriesExpenses,
    //     categoriesIncome: _categoriesIncome,
    //     categoriesRepeat: _categoriesRepeat,
    //   );
    // }
  }
}
