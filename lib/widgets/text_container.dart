import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:provider/provider.dart';

class TextContainer extends StatelessWidget {
  final String transactionClass;
  //var context;

  TextContainer({
    Key? key,
    // required this.context,
    required this.transactionClass,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    //calculation of the size (width and height) of a text - here it
    //is "Expenses"
    //use like this: variable.width or variable.height
    final Size sizeExpenses = (TextPainter(
            text: TextSpan(text: "Expenses"),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: sizeExpenses.width + 10,
        height: sizeExpenses.height + 10,
        color: Theme.of(context).colorScheme.background,
        child: Center(
          child: Text(
            transactionClass,
            style: TextStyle(
              color: _colorPicker(enterScreenProvider, context),
            ),
          ),
        ),
      ),
    );
  }
}

_colorPicker(enterScreenProvider, context) {
  if (enterScreenProvider.isExpenses) {
    return Theme.of(context).colorScheme.error;
  } else if (enterScreenProvider.isIncome) {
    return Theme.of(context).colorScheme.primary;
  }
  return Theme.of(context).colorScheme.secondary;
}
