//  Enter Screen - Input Screen for Adding new Transactions as well as to Edit existing ones. Note: This screen will not be part of the default routes.
//
//  Author: SoTBurst (thebluebaronx before the grand overhaul)
//  Co-Author: NightmindOfficial, thebluebaronx
/// NO PAGE INDEX (This screen is not part of the default route and needs to be pushed onto the Navigator)
import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/navigation/get_delegate.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/enter_screen/add_amount_dialog.dart';
import 'package:linum/widgets/enter_screen/delete_entry_dialog.dart';
import 'package:linum/widgets/enter_screen/enter_screen_listviewbuilder.dart';
import 'package:linum/widgets/enter_screen/enter_screen_top_input_field.dart';
import 'package:linum/widgets/enter_screen/update_entry_dialog.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/top_bar_action_item.dart';
import 'package:provider/provider.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({
    super.key,
  });

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
    final String partialSelectedDate =
        enterScreenProvider.selectedDate.toString().split(' ')[0];
    final DateTime formattedSelectedDate =
        DateTime.parse(partialSelectedDate);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenSkeleton(
        providerKey: ProviderKey.enter,
        initialActionLipBody: Container(),

        contentOverride: true,
        head: "Enter",
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
                          Text(tr('main.label-wip')),
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
                                  generateDeleteDialog(
                                    context,
                                    balanceDataProvider,
                                    enterScreenProvider.repeatId ??
                                        enterScreenProvider.formerId!,
                                    isRepeatable:
                                        enterScreenProvider.repeatId != null,
                                    formerTime: enterScreenProvider.formerTime,
                                  ).then(
                                    (pop) => pop != null && pop ? getRouterDelegate().popRoute() : {},
                                  );
                                },
                                child: Text(
                                  tr("enter_screen.button-delete-entry"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SaveButton
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: Theme.of(context).textTheme.button,
                                // TODO REMOVE IGNORES
                                // ignore: deprecated_member_use
                                primary: Theme.of(context).colorScheme.primary,
                                // ignore: deprecated_member_use
                                onPrimary:
                                    Theme.of(context).colorScheme.background,
                                // ignore: deprecated_member_use
                                onSurface: Colors.white,
                                fixedSize: Size(
                                  proportionateScreenWidth(300),
                                  proportionateScreenHeight(40),
                                ),
                              ),
                              onPressed: () {
                                if (enterScreenProvider.isIncome &&
                                    enterScreenProvider.amountToDisplay() <= 0) {
                                  showAddAmountAlertDialog(context, enterScreenProvider);
                                  dev.log(
                                    "amount was to low: ${enterScreenProvider.amountToDisplay()}",
                                  );
                                  return;
                                }

                                if (enterScreenProvider.editMode) {
                                  updateBalance(formattedSelectedDate);
                                } else {
                                  addBalance(formattedSelectedDate);
                                  getRouterDelegate().popRoute();
                                }
                              },
                              child: Text(tr('enter_screen.button-save-entry')),
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


  void addBalance(DateTime selectedDate) {
    final EnterScreenProvider enterScreenProvider = Provider.of<EnterScreenProvider>(context, listen: false);
    final BalanceDataProvider balanceDataProvider = Provider.of<BalanceDataProvider>(context, listen: false);
    if (enterScreenProvider.repeatDuration == null ||
        enterScreenProvider.repeatDurationTyp == null) {
      balanceDataProvider.addSingleBalance(
        SingleBalanceData(
          amount: enterScreenProvider.amountToDisplay(),
          category: enterScreenProvider.category,
          currency: "EUR",
          name: enterScreenProvider.name,
          note: enterScreenProvider.note,
          time: Timestamp.fromDate(
            selectedDate,
          ),
        ),
      );
    } else {
      balanceDataProvider.addRepeatedBalance(
        RepeatedBalanceData(
          amount: enterScreenProvider.amountToDisplay(),
          category: enterScreenProvider.category,
          currency: "EUR",
          name: enterScreenProvider.name,
          initialTime: Timestamp.fromDate(
            DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedDate.hour != 0
                  ? selectedDate.hour
                  : DateTime.now().hour,
              selectedDate.minute != 0
                  ? selectedDate.minute
                  : DateTime.now().minute,
              selectedDate.second != 0
                  ? selectedDate.second
                  : DateTime.now().second,
            ),
          ),
          repeatDuration: enterScreenProvider.repeatDuration!,
          repeatDurationType: enterScreenProvider.repeatDurationTyp!,
        ),
      );
    }
  }

  void updateBalance(DateTime selectedDate) {
    final EnterScreenProvider enterScreenProvider = Provider.of<EnterScreenProvider>(context, listen: false);
    final BalanceDataProvider balanceDataProvider = Provider.of<BalanceDataProvider>(context, listen: false);
    if (enterScreenProvider.repeatId == null) {
      balanceDataProvider.updateSingleBalance(
        SingleBalanceData(
          id: enterScreenProvider.formerId ?? "",
          amount: enterScreenProvider.amountToDisplay(),
          category: enterScreenProvider.category,
          currency: "EUR",
          name: enterScreenProvider.name,
          note: enterScreenProvider.note,
          time: Timestamp.fromDate(
            selectedDate,
          ),
        ),
      );
      getRouterDelegate().popRoute();
    } else {
      // open popup
      showChangeEntryDialog(context, selectedDate).then(
            (pop) => pop != null && pop ? getRouterDelegate().popRoute() : {},
      );
    }
  }
}
// TODO: Refactor
