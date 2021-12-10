import 'package:flutter/material.dart';

class EnterScreen extends StatelessWidget {
  const EnterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //the top, green lip
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(40),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      Text("0€"),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textContainer(
                                context: context, transactionClass: "Expenses"),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                  //width: sizeExpenses.width + 10,
                                  //height: sizeExpenses.height + 10,
                                  color: Colors.green,
                                  child: Center(child: Text("Expenses"))),
                            ),
                            Text("Income"),
                            Text("Transaction")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _textContainer({
  required var context,
  required transactionClass,
}) {
  var context;
  String transactionClass;

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
          color: Colors.green,
          child: Center(/*child: Text(transactionClass*/)));
}
