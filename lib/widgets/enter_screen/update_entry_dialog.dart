import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/serial_transaction_change_type_enum.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:provider/provider.dart';

Future<bool?> showChangeEntryDialog(BuildContext context, DateTime selectedDate) {
  final UserAlert userAlert = UserAlert(context: context);
  final BalanceDataProvider balanceDataProvider = Provider.of<BalanceDataProvider>(context, listen: false);
  final EnterScreenProvider enterScreenProvider = Provider.of<EnterScreenProvider>(context, listen: false);
  return userAlert.showActionDialog(
    "enter_screen.change-entry.dialog-label-change",
    <DialogAction>[
      DialogAction(
        actionTitle: "enter_screen.delete-entry.dialog-button-onlyonce",
        function: () {
          balanceDataProvider.updateSerialTransaction(
            id: enterScreenProvider
                .repeatId!,
            changeType: SerialTransactionChangeType.onlyThisOne,
            amount: enterScreenProvider.amountToDisplay(),
            category: enterScreenProvider.category,
            currency: "EUR",
            name: enterScreenProvider.name,
            time: enterScreenProvider.formerTime,
            newTime: Timestamp.fromDate(
              selectedDate,
            ),
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        actionTitle:
        "enter_screen.delete-entry.dialog-button-untilnow",
        dialogPurpose:
        DialogPurpose.danger,
        function: () {
          balanceDataProvider
              .updateSerialTransaction(
            id: enterScreenProvider
                .repeatId!,
            changeType:
            SerialTransactionChangeType
                .thisAndAllBefore,
            amount: enterScreenProvider.amountToDisplay(),
            category: enterScreenProvider
                .category,
            currency: "EUR",
            name:
            enterScreenProvider.name,
            time: enterScreenProvider
                .formerTime,
            newTime: Timestamp.fromDate(
              selectedDate,
            ),
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        actionTitle:
        "enter_screen.delete-entry.dialog-button-fromnow",
        dialogPurpose:
        DialogPurpose.danger,
        function: () {
          balanceDataProvider
              .updateSerialTransaction(
            id: enterScreenProvider
                .repeatId!,
            changeType:
            SerialTransactionChangeType
                .thisAndAllAfter,
            amount: enterScreenProvider.amountToDisplay(),
            category: enterScreenProvider
                .category,
            currency: "EUR",
            name:
            enterScreenProvider.name,
            time: enterScreenProvider
                .formerTime,
            newTime: Timestamp.fromDate(
              selectedDate,
            ),
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        actionTitle:
        "enter_screen.delete-entry.dialog-button-allentries",
        dialogPurpose:
        DialogPurpose.danger,
        function: () {
          balanceDataProvider
              .updateSerialTransaction(
            id: enterScreenProvider
                .repeatId!,
            changeType:
            SerialTransactionChangeType.all,
            amount: enterScreenProvider.amountToDisplay(),
            category: enterScreenProvider
                .category,
            currency: "EUR",
            name:
            enterScreenProvider.name,
            time: enterScreenProvider
                .formerTime,
            newTime: Timestamp.fromDate(
              selectedDate,
            ),
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        actionTitle:
        "enter_screen.delete-entry.dialog-button-cancel",
        dialogPurpose:
        DialogPurpose.secondary,
        function: () {
          Navigator.of(context, rootNavigator: true)
              .pop(false);
        },
      ),
    ],
    title:
    "enter_screen.delete-entry.dialog-label-title",
  );
}
