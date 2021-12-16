import 'package:flutter/material.dart';
import 'package:linum/widgets/enter_screen_list.dart';
import 'package:linum/widgets/text_container.dart';

class EnterScreen extends StatefulWidget {
  EnterScreen({Key? key}) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  TextEditingController myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myController = TextEditingController();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

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
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.zero,
                  bottom: Radius.circular(40),
                ),
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    color: Theme.of(context).colorScheme.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        //TO DO: elimante the small bubble below the disabled color
                        //Change background color to have a better view
                        TextField(
                          controller: myController,
                          showCursor: false,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: isExpenses ? "-" + " 0.0" : "+" + " 0.0",
                            hintStyle: TextStyle(
                              color:
                                  _colorPicker(isExpenses, isIncome, context),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: TextStyle(
                              color:
                                  _colorPicker(isExpenses, isIncome, context),
                              fontSize: 30),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpenses = true;
                                    isIncome = false;
                                    isTransaction = false;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: isExpenses
                                      ? TextContainer(
                                          //context: context,
                                          transactionClass: "Expenses",
                                          isExpenses: isExpenses,
                                          isIncome: isIncome,
                                        )
                                      : Center(
                                          child: Text(
                                          "Expenses",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                        )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpenses = false;
                                    isIncome = true;
                                    isTransaction = false;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: isIncome
                                      ? TextContainer(
                                          //context: context,
                                          transactionClass: "Income",
                                          isExpenses: isExpenses,
                                          isIncome: isIncome,
                                        )
                                      : Center(
                                          child: Text(
                                          "Income",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background),
                                        )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpenses = false;
                                    isIncome = false;
                                    isTransaction = true;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: isTransaction
                                      ? TextContainer(
                                          //context: context,
                                          transactionClass: "Transaction",
                                          isExpenses: isExpenses,
                                          isIncome: isIncome,
                                        )
                                      : Center(
                                          child: Text(
                                            "Transaction",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              EnterScreenList(isExpenses: isExpenses, isIncome: isIncome),
            ],
          ),
        ),
      ),
    );
  }
}

_colorPicker(bool isExpenses, bool isIncome, context) {
  if (isExpenses) {
    return Theme.of(context).colorScheme.error;
  } else if (isIncome) {
    return Theme.of(context).colorScheme.background;
  }
  return Theme.of(context).colorScheme.secondary;
}

/*ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                  //width: sizeExpenses.width + 10,
                                  //height: sizeExpenses.height + 10,
                                  color: Colors.green,
                                  child: Center(child: Text("Expenses"))),
                            ),*/
