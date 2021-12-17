import 'package:flutter/material.dart';
import 'package:linum/widgets/enter_screen/enter_screen_list.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';

class EnterScreen extends StatefulWidget {
  EnterScreen({Key? key}) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  bool isExpenses = true;

  bool isIncome = false;

  bool isTransaction = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //the top, green lip
              EnterScreenTopInputField(
                  isTransaction: isTransaction,
                  isIncome: isIncome,
                  isExpenses: isExpenses),
              EnterScreenList(isExpenses: isExpenses, isIncome: isIncome),
            ],
          ),
        ),
      ),
    );
  }
}



/*ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                  //width: sizeExpenses.width + 10,
                                  //height: sizeExpenses.height + 10,
                                  color: Colors.green,
                                  child: Center(child: Text("Expenses"))),
                            ),*/
