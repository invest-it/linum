//  Delete Entry Popup - Generates a UserAlert widget capable of removing balances
//
//  Author: NightmindOfficial (pls refer to Co-Author for any questions regarding existing code)
//  Co-Author: SoTBurst
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/repeatable_change_type_enum.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:provider/provider.dart';

Future<bool?> generateDeleteDialogFromSingleBalanceData(
  BuildContext context,
  BalanceDataProvider balanceDataProvider,
  SingleBalanceData singleBalanceData,
) async {
  final bool isRepeatable = singleBalanceData.repeatId != null;
  return generateDeleteDialog(
    context,
    balanceDataProvider,
    isRepeatable ? singleBalanceData.repeatId! : singleBalanceData.id,
    isRepeatable: isRepeatable,
    formerTime: singleBalanceData.formerTime ?? singleBalanceData.time,
  );
}

Future<bool?> showRepeatableDeleteDialog(
    BuildContext context,
    String balanceDataId, {
    Timestamp? formerTime,
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
          balanceDataProvider.removeRepeatedBalanceUsingId(
            id: balanceDataId,
            removeType: RepeatableChangeType.onlyThisOne,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-untilnow",
        function: () {
          balanceDataProvider.removeRepeatedBalanceUsingId(
            id: balanceDataId,
            removeType: RepeatableChangeType.thisAndAllBefore,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-fromnow",
        function: () {
          balanceDataProvider.removeRepeatedBalanceUsingId(
            id: balanceDataId,
            removeType: RepeatableChangeType.thisAndAllAfter,
            time: formerTime,
          );
          Navigator.of(context, rootNavigator: true).pop(true);
        },
      ),
      DialogAction(
        dialogPurpose: DialogPurpose.danger,
        actionTitle: "enter_screen.delete-entry.dialog-button-allentries",
        function: () {
          balanceDataProvider.removeRepeatedBalanceUsingId(
            id: balanceDataId,
            removeType: RepeatableChangeType.all,
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
    Timestamp? formerTime,
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
          balanceDataProvider.removeSingleBalanceUsingId(
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
  String balanceDataId, {
  required bool isRepeatable,
  Timestamp? formerTime,
}) async {


  return isRepeatable
      ? showRepeatableDeleteDialog(context, balanceDataId, formerTime: formerTime)
      : showDefaultDeleteDialog(context, balanceDataId, formerTime: formerTime);
}
