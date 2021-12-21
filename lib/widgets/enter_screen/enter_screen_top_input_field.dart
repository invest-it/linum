import 'package:flutter/material.dart';
import 'package:linum/widgets/text_container.dart';

class EnterScreenTopInputField extends StatefulWidget {
  bool isExpenses;
  bool isIncome;
  bool isTransaction;

  EnterScreenTopInputField({
    Key? key,
    required this.isTransaction,
    required this.isIncome,
    required this.isExpenses,
  }) : super(key: key);

  @override
  _EnterScreenTopInputFieldState createState() =>
      _EnterScreenTopInputFieldState();
}

class _EnterScreenTopInputFieldState extends State<EnterScreenTopInputField> {
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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
              //TODO eliminate the small bubble below the disabled color
              //Change background color to have a better view
              TextField(
                controller: myController,
                showCursor: false,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: widget.isExpenses ? "-" + " 0.0" : "+" + " 0.0",
                  hintStyle: TextStyle(
                    color: _colorPicker(
                        widget.isExpenses, widget.isIncome, context),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                    color: _colorPicker(
                        widget.isExpenses, widget.isIncome, context),
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
                          widget.isExpenses = true;
                          widget.isIncome = false;
                          widget.isTransaction = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: widget.isExpenses
                            ? TextContainer(
                                //context: context,
                                transactionClass: "Expenses",
                                isExpenses: widget.isExpenses,
                                isIncome: widget.isIncome,
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
                          widget.isExpenses = false;
                          widget.isIncome = true;
                          widget.isTransaction = false;
                       
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: widget.isIncome
                            ? TextContainer(
                                //context: context,
                                transactionClass: "Income",
                                isExpenses: widget.isExpenses,
                                isIncome: widget.isIncome,
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
                          widget.isExpenses = false;
                          widget.isIncome = false;
                          widget.isTransaction = true;
                       
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: widget.isTransaction
                            ? TextContainer(
                                //context: context,
                                transactionClass: "Transaction",

                                isExpenses: widget.isExpenses,
                                isIncome: widget.isIncome,
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
    );
  }

  _colorPicker(bool isExpenses, bool isIncome, context) {
    if (isExpenses) {
      return Theme.of(context).colorScheme.error;
    } else if (isIncome) {
      return Theme.of(context).colorScheme.background;
    }
    return Theme.of(context).colorScheme.secondary;
  }
}

//asdf