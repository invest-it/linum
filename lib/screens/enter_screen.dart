import 'package:flutter/material.dart';

import 'package:linum/widgets/enter_screen/enter_screen_list.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';

class EnterScreen extends StatefulWidget {
  EnterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
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
              EnterScreenTopInputField(),
              EnterScreenList(),
              Expanded(
                child:
                    Container(color: Theme.of(context).colorScheme.background),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.button,
                        primary: Theme.of(context).colorScheme.primary,
                        onPrimary: Theme.of(context).colorScheme.background,
                        onSurface: Colors.white,
                        fixedSize: Size(300, 40)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      //balanceDataProvider.addSingleBalance(amount: amount, category: category, currency: currency, name: name, time: time)
                    },
                    child: Text("Save transaction"),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*_textPicker(bool isExpenses, bool isIncome, String saveType) {
    if (isExpenses) {
      saveType = "Expense";
    } else if (isIncome) {
      saveType = "Income";
    } else
      saveType = "Transaction";
  }*/
}
