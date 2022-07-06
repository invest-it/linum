//  Enter Screen - Input Screen for Adding new Transactions as well as to Edit existing ones. Note: This screen will not be part of the default routes.
//
//  Author: SoTBurst (thebluebaronx before the grand overhaul)
//  Co-Author: NightmindOfficial, thebluebaronx
/// NO PAGE INDEX (This screen is not part of the default route and needs to be pushed onto the Navigator)
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/repeatable_change_type_enum.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/delete_entry_popup.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';
import 'package:linum/widgets/top_bar_action_item.dart';
import 'package:provider/provider.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  @override
  Widget build(BuildContext context) {
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    //  AccountSettingsProvider accountSettingsProvider =
    //       Provider.of<AccountSettingsProvider>(context);

    //to format the date time it has to be parsed to a string, get formatted
    //and get parsed back to a date time
    final String selectedDateStringFormatted =
        enterScreenProvider.selectedDate.toString().split(' ')[0];
    final DateTime selectedDateDateTimeFormatted =
        DateTime.parse(selectedDateStringFormatted);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        // extendBodyBehindAppBar: true,
        body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            const int sensitivity = 1;
            if (details.primaryVelocity! < -sensitivity) {
              if (enterScreenProvider.isExpenses) {
                enterScreenProvider.setIncome();
              } else if (enterScreenProvider.isIncome) {
                enterScreenProvider.setTransaction();
              }
            } else if (details.primaryVelocity! > sensitivity) {
              if (enterScreenProvider.isIncome) {
                enterScreenProvider.setExpense();
              } else if (enterScreenProvider.isTransaction) {
                enterScreenProvider.setIncome();
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //the top, green lip
              const EnterScreenTopInputField(),
              enterScreenProvider.isTransaction
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TopBarActionItem(
                            buttonIcon: Icons.build,
                            onPressedAction: () => {},
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('main/label-wip'),
                          ),
                        ],
                      ),
                    )
                  : EnterScreenListViewBuilder(),
              /*SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),*/
              /*Expanded(
                child: Container(color: Colors.red),
              ),*/

              MediaQuery.of(context).viewInsets.bottom > 1
                  ? Container()
                  : Column(
                      children: [
                        enterScreenProvider.editMode
                            ? TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: Theme.of(context).textTheme.button,
                                  fixedSize: Size(
                                    proportionateScreenWidth(300),
                                    proportionateScreenHeight(50),
                                  ),
                                ),
                                onPressed: () {
                                  generateDeletePopup(
                                    context,
                                    balanceDataProvider,
                                    enterScreenProvider.repeatId ??
                                        enterScreenProvider.formerId!,
                                    isRepeatable:
                                        enterScreenProvider.repeatId != null,
                                    formerTime: enterScreenProvider.formerTime,
                                  ).then(
                                    (_) => Navigator.of(context).pop(),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                    "enter_screen/button-delete-entry",
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.button,
                                primary: Theme.of(context).colorScheme.primary,
                                onPrimary:
                                    Theme.of(context).colorScheme.background,
                                onSurface: Colors.white,
                                fixedSize: Size(
                                  proportionateScreenWidth(300),
                                  proportionateScreenHeight(40),
                                ),
                              ),
                              onPressed: () {
                                if (enterScreenProvider.isIncome &&
                                    _amountChooser(enterScreenProvider) <= 0) {
                                  showAlertDialog(context, enterScreenProvider);
                                  dev.log(
                                    "amount was to low: ${_amountChooser(enterScreenProvider)}",
                                  );
                                  return;
                                }

                                if (enterScreenProvider.editMode) {
                                  if (enterScreenProvider.repeatId == null) {
                                    balanceDataProvider.updateSingleBalance(
                                      SingleBalanceData(
                                        id: enterScreenProvider.formerId ?? "",
                                        amount:
                                            _amountChooser(enterScreenProvider),
                                        category: enterScreenProvider.category,
                                        currency: "EUR",
                                        name: enterScreenProvider.name,
                                        note: enterScreenProvider.note,
                                        time: Timestamp.fromDate(
                                          selectedDateDateTimeFormatted,
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } else {
                                    // open popup
                                    final UserAlert userAlert =
                                        UserAlert(context: context);
                                    userAlert
                                        .showMyActionDialog(
                                          "enter_screen/change-entry/dialog-label-change",
                                          <DialogAction>[
                                            DialogAction(
                                              actionTitle:
                                                  "enter_screen/delete-entry/dialog-button-onlyonce",
                                              function: () {
                                                balanceDataProvider
                                                    .updateRepeatedBalance(
                                                  id: enterScreenProvider
                                                      .repeatId!,
                                                  changeType:
                                                      RepeatableChangeType
                                                          .onlyThisOne,
                                                  amount: _amountChooser(
                                                    enterScreenProvider,
                                                  ),
                                                  category: enterScreenProvider
                                                      .category,
                                                  currency: "EUR",
                                                  name:
                                                      enterScreenProvider.name,
                                                  time: enterScreenProvider
                                                      .formerTime,
                                                  newTime: Timestamp.fromDate(
                                                    selectedDateDateTimeFormatted,
                                                  ),
                                                );
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            DialogAction(
                                              actionTitle:
                                                  "enter_screen/delete-entry/dialog-button-untilnow",
                                              dialogPurpose:
                                                  DialogPurpose.danger,
                                              function: () {
                                                dev.log("");
                                                balanceDataProvider
                                                    .updateRepeatedBalance(
                                                  id: enterScreenProvider
                                                      .repeatId!,
                                                  changeType:
                                                      RepeatableChangeType
                                                          .thisAndAllBefore,
                                                  amount: _amountChooser(
                                                    enterScreenProvider,
                                                  ),
                                                  category: enterScreenProvider
                                                      .category,
                                                  currency: "EUR",
                                                  name:
                                                      enterScreenProvider.name,
                                                  time: enterScreenProvider
                                                      .formerTime,
                                                  newTime: Timestamp.fromDate(
                                                    selectedDateDateTimeFormatted,
                                                  ),
                                                );
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            DialogAction(
                                              actionTitle:
                                                  "enter_screen/delete-entry/dialog-button-fromnow",
                                              dialogPurpose:
                                                  DialogPurpose.danger,
                                              function: () {
                                                balanceDataProvider
                                                    .updateRepeatedBalance(
                                                  id: enterScreenProvider
                                                      .repeatId!,
                                                  changeType:
                                                      RepeatableChangeType
                                                          .thisAndAllAfter,
                                                  amount: _amountChooser(
                                                    enterScreenProvider,
                                                  ),
                                                  category: enterScreenProvider
                                                      .category,
                                                  currency: "EUR",
                                                  name:
                                                      enterScreenProvider.name,
                                                  time: enterScreenProvider
                                                      .formerTime,
                                                  newTime: Timestamp.fromDate(
                                                    selectedDateDateTimeFormatted,
                                                  ),
                                                );
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            DialogAction(
                                              actionTitle:
                                                  "enter_screen/delete-entry/dialog-button-allentries",
                                              dialogPurpose:
                                                  DialogPurpose.danger,
                                              function: () {
                                                balanceDataProvider
                                                    .updateRepeatedBalance(
                                                  id: enterScreenProvider
                                                      .repeatId!,
                                                  changeType:
                                                      RepeatableChangeType.all,
                                                  amount: _amountChooser(
                                                    enterScreenProvider,
                                                  ),
                                                  category: enterScreenProvider
                                                      .category,
                                                  currency: "EUR",
                                                  name:
                                                      enterScreenProvider.name,
                                                  time: enterScreenProvider
                                                      .formerTime,
                                                  newTime: Timestamp.fromDate(
                                                    selectedDateDateTimeFormatted,
                                                  ),
                                                );
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                            DialogAction(
                                              actionTitle:
                                                  "enter_screen/delete-entry/dialog-button-cancel",
                                              dialogPurpose:
                                                  DialogPurpose.secondary,
                                              function: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                          ],
                                          title:
                                              "enter_screen/delete-entry/dialog-label-title",
                                        )
                                        .then(
                                          (value) =>
                                              Navigator.of(context).pop(),
                                        );
                                  }
                                } else {
                                  if (enterScreenProvider.repeatDuration ==
                                          null ||
                                      enterScreenProvider.repeatDurationTyp ==
                                          null) {
                                    balanceDataProvider.addSingleBalance(
                                      SingleBalanceData(
                                        amount:
                                            _amountChooser(enterScreenProvider),
                                        category: enterScreenProvider.category,
                                        currency: "EUR",
                                        name: enterScreenProvider.name,
                                        note: enterScreenProvider.note,
                                        time: Timestamp.fromDate(
                                          selectedDateDateTimeFormatted,
                                        ),
                                      ),
                                    );
                                  } else {
                                    balanceDataProvider.addRepeatedBalance(
                                      RepeatedBalanceData(
                                        amount:
                                            _amountChooser(enterScreenProvider),
                                        category: enterScreenProvider.category,
                                        currency: "EUR",
                                        name: enterScreenProvider.name,
                                        initialTime: Timestamp.fromDate(
                                          DateTime(
                                            selectedDateDateTimeFormatted.year,
                                            selectedDateDateTimeFormatted.month,
                                            selectedDateDateTimeFormatted.day,
                                            selectedDateDateTimeFormatted
                                                        .hour !=
                                                    0
                                                ? selectedDateDateTimeFormatted
                                                    .hour
                                                : DateTime.now().hour,
                                            selectedDateDateTimeFormatted
                                                        .minute !=
                                                    0
                                                ? selectedDateDateTimeFormatted
                                                    .minute
                                                : DateTime.now().minute,
                                            selectedDateDateTimeFormatted
                                                        .second !=
                                                    0
                                                ? selectedDateDateTimeFormatted
                                                    .second
                                                : DateTime.now().second,
                                          ),
                                        ),
                                        repeatDuration:
                                            enterScreenProvider.repeatDuration!,
                                        repeatDurationType: enterScreenProvider
                                            .repeatDurationTyp!,
                                      ),
                                    );
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  'enter_screen/button-save-entry',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //if the amount is entered in expenses, it's set to the negative equivalent if
  //the user did not accidentally press the minus
  num _amountChooser(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      if (enterScreenProvider.amount < 0) {
        return enterScreenProvider.amount;
      } else {
        return -enterScreenProvider.amount;
      }
    } else {
      return enterScreenProvider.amount;
    }
  }

  void showAlertDialog(
    BuildContext context,
    EnterScreenProvider enterScreenProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate(
              'enter_screen/add-amount/dialog-label-title-expenses',
            ),
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!
                    .translate('enter_screen/add-amount/dialog-label-title'),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
// TODO: Refactor
