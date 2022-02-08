import 'package:flutter/material.dart';
import 'package:linum/backend_functions/currency_input_formatter.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
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
      if (enterScreenProvider.amount != 0) {
        myController = TextEditingController(
            text: enterScreenProvider.amount.toStringAsFixed(2) + " €");
      } else {
        myController = TextEditingController();
      }
    }
    //calculation of the size (width and height) of a text - here it
    //is "Expenses"
    //use like this: variable.width or variable.height
    /*final Size sizeMyController = (TextPainter(
            text: TextSpan(text: myController!.text),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;*/

    return Stack(
      children: [
        ClipRRect(
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
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //text field
                    Form(
                      key: enterScreenProvider.formKey,
                      child: Container(
                        child: TextField(
                          inputFormatters: [
                            CurrencyInputFormatter(),
                            // DecimalTextInputFormatter(decimalRange: 2),
                            // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          // validator: (value) {
                          //   if (value!.isNotEmpty && value.length < 8) {
                          //     return null;
                          //   } else {
                          //     return 'Enter a value!';
                          //   }
                          // },
                          maxLength: 15,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: myController,
                          showCursor: true,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counter: SizedBox.shrink(),
                            isCollapsed: true,
                            isDense: true,
                            hintText: enterScreenProvider.isExpenses
                                ? " 0.00 €"
                                : " 0.00 €",
                            // prefixIcon: enterScreenProvider.isExpenses
                            //     ? Icon(Icons.remove,
                            //         color: Theme.of(context).colorScheme.error)
                            //     : Icon(Icons.add,
                            //         color: enterScreenProvider.isIncome
                            //             ? Theme.of(context)
                            //                 .colorScheme
                            //                 .background
                            //             : Theme.of(context)
                            //                 .colorScheme
                            //                 .secondary),
                            // as soon as multiple currencies are implemented, the provider for this will insert the corresponding symbol here.
                            // suffixIcon: Text("€"),
                            hintStyle: TextStyle(
                              color: _colorPicker(enterScreenProvider, context),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                color:
                                    _colorPicker(enterScreenProvider, context),
                              ),
                          onChanged: (String _) {
                            enterScreenProvider.setAmount(double.tryParse(
                                    myController!.text
                                        .substring(
                                            0, myController!.text.length - 2)
                                        .replaceAll(".", "")
                                        .replaceAll(",", ".")) ??
                                0.0);

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
                              enterScreenProvider.setExpense();
                            },
                            child: Container(
                              width: proportionateScreenWidth(94),
                              child: enterScreenProvider.isExpenses
                                  ? TextContainer(
                                      //context: context,
                                      transactionClass: AppLocalizations.of(
                                              context)!
                                          .translate(
                                              'enter_screen/button-expenses-label'),
                                    )
                                  : Center(
                                      child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'enter_screen/button-expenses-label'),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                    )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              enterScreenProvider.setIncome();
                            },
                            child: Container(
                              width: proportionateScreenWidth(94),
                              child: enterScreenProvider.isIncome
                                  ? TextContainer(
                                      //context: context,
                                      transactionClass: AppLocalizations.of(
                                              context)!
                                          .translate(
                                              'enter_screen/button-income-label'),
                                    )
                                  : Center(
                                      child: Text(
                                      AppLocalizations.of(context)!.translate(
                                          'enter_screen/button-income-label'),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background),
                                    )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              enterScreenProvider.setTransaction();
                            },
                            child: Container(
                              width: proportionateScreenWidth(94),
                              child: enterScreenProvider.isTransaction
                                  ? TextContainer(
                                      //context: context,
                                      transactionClass: AppLocalizations.of(
                                              context)!
                                          .translate(
                                              'enter_screen/button-transaction-label'),
                                    )
                                  : Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.translate(
                                            'enter_screen/button-transaction-label'),
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
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: AppBar(
              elevation: 0,
              //actions: [AppBarAction.fromPreset(DefaultAction.CLOSE)],
              title: Text(
                AppLocalizations.of(context)!
                    .translate('enter_screen/label-title'),
                style: Theme.of(context).textTheme.button,
              ),
              centerTitle: true,
            ),
          ),
        ),
      ],
    );
  }

  //which color to show depending on expense or not
  Color _colorPicker(EnterScreenProvider enterScreenProvider, context) {
    if (enterScreenProvider.isExpenses) {
      return Theme.of(context).colorScheme.error;
    } else if (enterScreenProvider.isIncome) {
      return Theme.of(context).colorScheme.background;
    }
    return Theme.of(context).colorScheme.secondary;
  }
}
