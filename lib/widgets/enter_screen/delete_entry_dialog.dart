//  Delete Entry Popup - Generates a UserAlert widget capable of removing balances
//
//  Author: NightmindOfficial (pls refer to Co-Author for any questions regarding existing code)
//  Co-Author: SoTBurst
//

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/serial_transaction_change_type_enum.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:provider/provider.dart';

Future<bool?> generateDeleteDialogFromTransaction(
  BuildContext context,
  BalanceDataProvider balanceDataProvider,
  Transaction transaction,
) async {
  final bool isRepeatable = transaction.repeatId != null;
  return generateDeleteDialog(
    context,
    balanceDataProvider,
    isRepeatable ? transaction.repeatId! : transaction.id,
    isRepeatable: isRepeatable,
    formerTime: transaction.formerTime ?? transaction.time,
  );
}


Future<bool?> generateDeleteDialogFromSerialTransaction(BuildContext context, BalanceDataProvider balanceDataProvider, SerialTransaction serialTransaction) async{
  return showDefaultDeleteDialog(context, serialTransaction.id);
}

Future<bool?> showRepeatableDeleteDialog(
    BuildContext context,
    String transactionId, {
    firestore.Timestamp? formerTime,
}) async {
  final UserAlert userAlert = UserAlert(context: context);
  final BalanceDataProvider balanceDataProvider = Provider.of<BalanceDataProvider>(context, listen: false);
  return userAlert.showActionDialog(
    "enter_screen.delete-entry.dialog-label-deleterep",
    [
      DialogAction(
        // ignore: avoid_redundant_argument_values
        dialogPurpose: DialogPurpose.primary,
        actionTitle: "enter_screen.delete-entry.dialog-button-onlyonce",
        function: () {
          balanceDataProvider.removeSerialTransactionUsingId(
            id: transactionId,
            removeType: SerialTransactionChangeType.onlyThisOne,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-untilnow",
        function: () {
          balanceDataProvider.removeSerialTransactionUsingId(
            id: transactionId,
            removeType: SerialTransactionChangeType.thisAndAllBefore,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-fromnow",
        function: () {
          balanceDataProvider.removeSerialTransactionUsingId(
            id: transactionId,
            removeType: SerialTransactionChangeType.thisAndAllAfter,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-allentries",
        function: () {
          balanceDataProvider.removeSerialTransactionUsingId(
            id: transactionId,
            removeType: SerialTransactionChangeType.all,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.secondary,
        actionTitle: "enter_screen.delete-entry.dialog-button-cancel",
        function: () => Navigator.of(context, rootNavigator: true).pop(false),
      )
    ],
    title: "enter_screen.delete-entry.dialog-label-title",
  );
}

Future<bool?> showDefaultDeleteDialog(
    BuildContext context,
    String balanceDataId, {
    firestore.Timestamp? formerTime,
}) async {
  final UserAlert userAlert = UserAlert(context: context);
  final BalanceDataProvider balanceDataProvider = Provider.of<BalanceDataProvider>(context, listen: false);
  return userAlert.showActionDialog(
    "enter_screen.delete-entry.dialog-label-delete",
    [
      DialogAction(
        dialogPurpose: DialogPurpose.secondary,
        actionTitle: "enter_screen.delete-entry.dialog-button-cancel",
        function: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-delete",
        function: () {
          balanceDataProvider.removeTransactionUsingId(
            balanceDataId,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
    ],
    title: "enter_screen.delete-entry.dialog-label-title",
  );
}

Future<bool?> generateDeleteDialog(
  BuildContext context,
  BalanceDataProvider balanceDataProvider,
  String transactionId, {
  required bool isRepeatable,
  firestore.Timestamp? formerTime,
}) async {


  return isRepeatable
      ? showRepeatableDeleteDialog(context, transactionId, formerTime: formerTime)
      : showDefaultDeleteDialog(context, transactionId, formerTime: formerTime);
}
