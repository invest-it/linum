import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/enter_screen/enter_screen_list.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';
import 'package:provider/provider.dart';

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
    Timestamp time = Timestamp.fromDate(DateTime.now());
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);
    String selectedDateStringFormatted =
        enterScreenProvider.selectedDate.toString().split(' ')[0];
    DateTime selectedDateDateTimeFormatted =
        DateTime.parse(selectedDateStringFormatted);
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
                      balanceDataProvider.addSingleBalance(
                          amount: enterScreenProvider.amount,
                          category: enterScreenProvider.category,
                          currency: "EUR",
                          name: enterScreenProvider.name == ""
                              ? enterScreenProvider.category
                              : enterScreenProvider.name,
                          time: Timestamp.fromDate(
                              selectedDateDateTimeFormatted));
                    },
                    child: Text("Eintrag speichern"),
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
}
