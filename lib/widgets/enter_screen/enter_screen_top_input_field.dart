//  Enter Screen Top Input Field - This is the currency input field in the Enter Screen (obviously, lol)
//
//  Author: thebluebaronx
//  Co-Author: SoTBurst, NightmindOfficial
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linum/navigation/get_delegate.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/text_container.dart';
import 'package:provider/provider.dart';

class EnterScreenTopInputField extends StatefulWidget {
  const EnterScreenTopInputField({
    super.key,
  });

  @override
  _EnterScreenTopInputFieldState createState() =>
      _EnterScreenTopInputFieldState();
}

class _EnterScreenTopInputFieldState extends State<EnterScreenTopInputField> {
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (textController != null) {
      textController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);

    final formatter = CurrencyFormatter(context.locale);
    // TODO: Write a better formatter for every currency symbol

    if (textController == null) {
      if (enterScreenProvider.amount != 0) {
        textController = TextEditingController(
          text: formatter.format(enterScreenProvider.amount),
        );
      } else {
        textController = TextEditingController(text: formatter.format(0));
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
                      controller: textController,
                      showCursor: true,
                      cursorColor: Colors.white,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          color: _pickColor(enterScreenProvider, context),
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: _pickColor(enterScreenProvider, context),
                          ),
                      onTap: () => {
                        actionLipStatusProvider.setActionLipStatus(
                          providerKey: ProviderKey.enter,
                        ),
                        textController!.selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: textController!.text.length - 2,
                          ),
                        )
                      },
                      onChanged: (String str) {
                        final value = _parseInput(str);
                        setState(() {
                          textController!.text = formatter.format(value);
                          textController!.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: textController!.text.length - 2,
                            ),
                          );
                        });

                        enterScreenProvider.setAmount(value);
                      },
                    ),
                  ),
                  //the user chooses between expenses, income etc.
                  //standard is expenses
                  SizedBox(
                    width: proportionateScreenWidth(282),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    transactionClass: tr(
                                        'enter_screen.button-expenses-label'),
                                  )
                                : Center(
                                    child: Text(
                                      tr('enter_screen.button-expenses-label'),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
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
                                        tr('enter_screen.button-income-label'),
                                  )
                                : Center(
                                    child: Text(
                                      tr('enter_screen.button-income-label'),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        /*GestureDetector(
                          onTap: () {
                            enterScreenProvider.setTransaction();
                          },
                          child: SizedBox(
                            width: proportionateScreenWidth(94),
                            child: enterScreenProvider.isTransaction
                                ? TextContainer(
                                    //context: context,
                                    transactionClass: tr(
                                        'enter_screen.button-transaction-label'),
                                  )
                                : Center(
                                    child: Text(
                                      tr('enter_screen.button-transaction-label'),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                          ),
                        ),*/
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
                tr('enter_screen.title.${enterScreenProvider.editMode ? 'edit' : 'add'}'),
                style: Theme.of(context).textTheme.button,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: AppBarAction.fromParameters(
                icon: Icons.arrow_back,
                ontap: () {
                  actionLipStatusProvider.setActionLipStatus(
                    providerKey: ProviderKey.enter,
                  );
                  getRouterDelegate().popRoute();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _parseInput(String str) {
    final trimmedStr = str.trim().replaceAll(RegExp(r"^[\$,£,€]\s?0+"), "");
    final paddedStr = trimmedStr.padLeft(3, "0");
    final decimalStr =
        "${paddedStr.substring(0, paddedStr.length - 2)}.${paddedStr.substring(paddedStr.length - 2)}";
    return double.parse(decimalStr);
  }

  //which color to show depending on expense or not
  Color _pickColor(
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
