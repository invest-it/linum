import 'package:flutter/material.dart';

class EnterScreenList extends StatelessWidget {
  bool isExpenses;
  bool isIncome;
  EnterScreenList({Key? key, required this.isExpenses, required this.isIncome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExpenses)
      return ListView.builder(
          itemCount: 6,
          itemBuilder: (ctx, index) => Card(
                elevation: 6,
              ));
    else if (isIncome)
      return ListView.builder(
        itemBuilder: (ctx, index) => Card(
          elevation: 6,
        ),
      );
    else
      return ListView.builder(
        itemBuilder: (ctx, index) => Card(
          elevation: 6,
        ),
      );
  }
}
