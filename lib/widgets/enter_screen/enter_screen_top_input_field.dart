import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/decimal_text_input_formatter.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/text_container.dart';
import 'package:provider/provider.dart';

class EnterScreenTopInputField extends StatefulWidget {
  EnterScreenTopInputField({
    Key? key,
  }) : super(key: key);

  @override
  _EnterScreenTopInputFieldState createState() =>
      _EnterScreenTopInputFieldState();
}

class _EnterScreenTopInputFieldState extends State<EnterScreenTopInputField> {
  TextEditingController? myController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (myController != null) {
      myController!.dispose();
    }

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    if (myController == null) {
      myController =
          TextEditingController(text: enterScreenProvider.amount.toString());
    }
    //calculation of the size (width and height) of a text - here it
    //is "Expenses"
    //use like this: variable.width or variable.height
    final Size sizeMyController = (TextPainter(
            text: TextSpan(text: myController!.text),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.zero,
        bottom: Radius.circular(40),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        width: proportionateScreenWidth(375),
        height: proportionateScreenHeight(164),
        color: Theme.of(context).colorScheme.primary,
        child: GestureDetector(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height < 690
                      ? proportionateScreenHeight(35)
                      : proportionateScreenHeight(50),
                ),
                //upper left "x" to close the window
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.only(left: 50),
                    constraints: BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    color: Colors.white,
                  ),
                ),
                //text field
                Form(
                  key: enterScreenProvider.formKey,
                  child: Container(
                    //current solution to "center" the textfield as best as possible
                    width: sizeMyController.width + 120,
                    child: TextFormField(
                      inputFormatters: [
                        DecimalTextInputFormatter(decimalRange: 2)
                      ],
                      // validator: (value) {
                      //   if (value!.isNotEmpty && value.length < 8) {
                      //     return null;
                      //   } else {
                      //     return 'Enter a value!';
                      //   }
                      // },
                      maxLength: 7,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      controller: myController,
                      showCursor: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counter: SizedBox.shrink(),
                        isCollapsed: true,
                        isDense: true,
                        hintText:
                            enterScreenProvider.isExpenses ? " 0.0" : " 0.0",
                        prefixIcon: enterScreenProvider.isExpenses
                            ? Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(Icons.remove,
                                    color: Theme.of(context).colorScheme.error),
                              )
                            : Icon(Icons.add,
                                color: enterScreenProvider.isIncome
                                    ? Theme.of(context).colorScheme.background
                                    : Theme.of(context).colorScheme.secondary),
                        hintStyle: TextStyle(
                          color: _colorPicker(enterScreenProvider, context),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                          color: _colorPicker(enterScreenProvider, context),
                          fontSize: 30),
                      onChanged: (String _) {
                        setState(() {
                          enterScreenProvider.setAmount(
                              double.tryParse(myController!.text) == null
                                  ? 0.0
                                  : double.tryParse(myController!.text)!);
                        });
                        //print(enterScreenProvider.amount);
                      },
                    ),
                  ),
                ),
                //the user chooses between expenses, income etc.
                //standard is expenses
                Container(
                  width: proportionateScreenWidth(282),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            enterScreenProvider.setIsExpenses(true);
                            enterScreenProvider.setIsIncome(false);
                            enterScreenProvider.setIsTransaction(false);
                          });
                        },
                        child: Container(
                          width: proportionateScreenWidth(94),
                          child: enterScreenProvider.isExpenses
                              ? TextContainer(
                                  //context: context,
                                  transactionClass: "Ausgaben",
                                )
                              : Center(
                                  child: Text(
                                  "Ausgaben",
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
                            enterScreenProvider.setIsExpenses(false);
                            enterScreenProvider.setIsIncome(true);
                            enterScreenProvider.setIsTransaction(false);
                          });
                        },
                        child: Container(
                          width: proportionateScreenWidth(94),
                          child: enterScreenProvider.isIncome
                              ? TextContainer(
                                  //context: context,
                                  transactionClass: "Einkommen",
                                )
                              : Center(
                                  child: Text(
                                  "Einkommen",
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
                            enterScreenProvider.setIsExpenses(false);
                            enterScreenProvider.setIsIncome(false);
                            enterScreenProvider.setIsTransaction(true);
                          });
                        },
                        child: Container(
                          width: proportionateScreenWidth(94),
                          child: enterScreenProvider.isTransaction
                              ? TextContainer(
                                  //context: context,
                                  transactionClass: "Transaktion",
                                )
                              : Center(
                                  child: Text(
                                    "Transaktion",
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
    );
  }

  //which color to show depending on expense or not
  _colorPicker(EnterScreenProvider enterScreenProvider, context) {
    if (enterScreenProvider.isExpenses) {
      return Theme.of(context).colorScheme.error;
    } else if (enterScreenProvider.isIncome) {
      return Theme.of(context).colorScheme.background;
    }
    return Theme.of(context).colorScheme.secondary;
  }
}
