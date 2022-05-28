//  Enter Screen Top Input Field - This is the currency input field in the Enter Screen (obviously, lol)
//
//  Author: thebluebaronx
//  Co-Author: SoTBurst, NightmindOfficial
//

import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/text_container.dart';
import 'package:provider/provider.dart';

class EnterScreenTopInputField extends StatefulWidget {
  const EnterScreenTopInputField({
    Key? key,
  }) : super(key: key);

  @override
  _EnterScreenTopInputFieldState createState() =>
      _EnterScreenTopInputFieldState();
}

class _EnterScreenTopInputFieldState extends State<EnterScreenTopInputField> {
  TextEditingController? myController;

  String lastState = "0,00";

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

  @override
  Widget build(BuildContext context) {
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    if (myController == null) {
      if (enterScreenProvider.amount != 0) {
        myController = TextEditingController(
          text:
              "${enterScreenProvider.amount.toStringAsFixed(2).replaceAll(".", ",")} €",
        );
      } else {
        myController = TextEditingController(text: "$lastState €");
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
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
          child: Container(
            alignment: Alignment.bottomCenter,
            width: proportionateScreenWidth(375),
            height: MediaQuery.of(context).size.height < 650
                ? 180
                : 190, //proportionateScreenHeight(200), //180
            color: Theme.of(context).colorScheme.primary,
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //text field
                  Form(
                    child: TextField(
                      // inputFormatters: [
                      //   CurrencyInputFormatter(
                      //     allowNegative: false,
                      //   ),
                      // ],

                      // validator: (value) {
                      //   if (value!.isNotEmpty && value.length < 8) {
                      //     return null;
                      //   } else {
                      //     return 'Enter a value!';
                      //   }
                      // },
                      autofocus: !enterScreenProvider.editMode,
                      cursorWidth: 0,
                      maxLength: 15,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      controller: myController,
                      showCursor: true,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counter: const SizedBox.shrink(),
                        isCollapsed: true,
                        isDense: true,
                        hintText: enterScreenProvider.isExpenses
                            ? " 0,00 €"
                            : " 0,00 €",
                        // as soon as multiple currencies are implemented, the provider for this will insert the corresponding symbol here.
                        // suffixIcon: Text("€"),
                        hintStyle: TextStyle(
                          color: _colorPicker(enterScreenProvider, context),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: _colorPicker(enterScreenProvider, context),
                          ),
                      onTap: () => {
                        myController!.selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: myController!.text.length - 2,
                          ),
                        )
                      },
                      onChanged: (String str) {
                        str = str.trim();

                        if (str.substring(str.length - 1) != "€" &&
                            !str
                                .substring(str.length - 1)
                                .contains(RegExp("[0-9]"))) {
                          str = str.substring(0, str.length - 1);
                        }
                        if (str.substring(str.length - 1) != "€") {
                          str = str.substring(0, str.length - 3) +
                              str.substring(str.length - 1);
                        } else {
                          str = str.substring(0, str.length - 2);
                        }

                        // if (lastState.length < str.length) {
                        //   String newChar =
                        //       str.substring(str.length - 1).trim();
                        //   int valueToAdd = int.parse(newChar);
                        //   int current =
                        //       int.parse(lastState.replaceAll(r",", ""));
                        //   newVal = (current * 10 + valueToAdd).toString();
                        // } else if (lastState.length > str.length) {
                        //   int currentValue =
                        //       int.parse(lastState.replaceAll(r",", ""));
                        //   newVal = (currentValue ~/ 10).toString();
                        // }

                        String newVal = int.parse(
                          str.replaceAll(",", "").replaceAll(".", ""),
                        ).toString();

                        if (newVal.length < 3) {
                          final int x = 3 - newVal.length;
                          for (int i = 0; i < x; i++) {
                            newVal = "0$newVal";
                          }
                        }
                        lastState = newVal.replaceRange(
                          newVal.length - 2,
                          newVal.length,
                          ",${newVal.substring(newVal.length - 2)}",
                        );
                        setState(() {
                          myController!.text = "$lastState €";
                          myController!.selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: myController!.text.length - 2,
                            ),
                          );
                        });
                        enterScreenProvider.setAmount(
                          double.tryParse(
                                myController!.text
                                    .substring(
                                      0,
                                      myController!.text.length - 2,
                                    )
                                    .replaceAll(".", "")
                                    .replaceAll(",", "."),
                              ) ??
                              0.0,
                        );
                        //print(enterScreenProvider.amount);
                      },
                    ),
                  ),
                  //the user chooses between expenses, income etc.
                  //standard is expenses
                  SizedBox(
                    width: proportionateScreenWidth(282),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            enterScreenProvider.setExpense();
                          },
                          child: SizedBox(
                            width: proportionateScreenWidth(94),
                            child: enterScreenProvider.isExpenses
                                ? TextContainer(
                                    //context: context,
                                    transactionClass:
                                        AppLocalizations.of(context)!.translate(
                                      'enter_screen/button-expenses-label',
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                        'enter_screen/button-expenses-label',
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            enterScreenProvider.setIncome();
                          },
                          child: SizedBox(
                            width: proportionateScreenWidth(94),
                            child: enterScreenProvider.isIncome
                                ? TextContainer(
                                    //context: context,
                                    transactionClass:
                                        AppLocalizations.of(context)!.translate(
                                      'enter_screen/button-income-label',
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                        'enter_screen/button-income-label',
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            enterScreenProvider.setTransaction();
                          },
                          child: SizedBox(
                            width: proportionateScreenWidth(94),
                            child: enterScreenProvider.isTransaction
                                ? TextContainer(
                                    //context: context,
                                    transactionClass:
                                        AppLocalizations.of(context)!.translate(
                                      'enter_screen/button-transaction-label',
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                        'enter_screen/button-transaction-label',
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  )
                ],
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
  Color _colorPicker(
    EnterScreenProvider enterScreenProvider,
    BuildContext context,
  ) {
    if (enterScreenProvider.isExpenses) {
      return Theme.of(context).colorScheme.error;
    } else if (enterScreenProvider.isIncome) {
      return Theme.of(context).colorScheme.background;
    }
    return Theme.of(context).colorScheme.secondary;
  }
}
