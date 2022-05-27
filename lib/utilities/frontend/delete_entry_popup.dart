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
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/utilities/frontend/user_alert.dart';

Future<bool?> generateDeletePopupFromArrayElement(
  BuildContext context,
  BalanceDataProvider balanceDataProvider,
  Map<String, dynamic> arrayElement,
) async {
  final bool isRepeatable = arrayElement["repeatId"] != null;
  return generateDeletePopup(
    context,
    balanceDataProvider,
    isRepeatable
        ? arrayElement["repeatId"] as String
        : arrayElement["id"] as String,
    isRepeatable: isRepeatable,
    formerTime: arrayElement["formerTime"] as Timestamp? ??
        arrayElement["time"] as Timestamp,
  );
}

Future<bool?> generateDeletePopup(
  BuildContext context,
  BalanceDataProvider balanceDataProvider,
  String id, {
  required bool isRepeatable,
  Timestamp? formerTime,
}) async {
  final UserAlert userAlert = UserAlert(context: context);

  return isRepeatable // REPEATABLE DELETE POPUP
      ? userAlert.showMyActionDialog(
          "enter_screen/delete-entry/dialog-label-deleterep",
          [
            DialogAction(
              // ignore: avoid_redundant_argument_values
              dialogPurpose: DialogPurpose.primary,
              actionTitle: "enter_screen/delete-entry/dialog-button-onlyonce",
              function: () {
                balanceDataProvider.removeRepeatedBalanceUsingId(
                  id: id,
                  removeType: RepeatableChangeType.onlyThisOne,
                  time: formerTime,
                );
                Navigator.of(context).pop(true);
              },
            ),
            DialogAction(
              dialogPurpose: DialogPurpose.danger,
              actionTitle: "enter_screen/delete-entry/dialog-button-untilnow",
              function: () {
                balanceDataProvider.removeRepeatedBalanceUsingId(
                  id: id,
                  removeType: RepeatableChangeType.thisAndAllBefore,
                  time: formerTime,
                );
                Navigator.of(context).pop(true);
              },
            ),
            DialogAction(
              dialogPurpose: DialogPurpose.danger,
              actionTitle: "enter_screen/delete-entry/dialog-button-fromnow",
              function: () {
                balanceDataProvider.removeRepeatedBalanceUsingId(
                  id: id,
                  removeType: RepeatableChangeType.thisAndAllAfter,
                  time: formerTime,
                );
                Navigator.of(context).pop(true);
              },
            ),
            DialogAction(
              dialogPurpose: DialogPurpose.danger,
              actionTitle: "enter_screen/delete-entry/dialog-button-allentries",
              function: () {
                balanceDataProvider.removeRepeatedBalanceUsingId(
                  id: id,
                  removeType: RepeatableChangeType.all,
                );
                Navigator.of(context).pop(true);
              },
            ),
            DialogAction(
              dialogPurpose: DialogPurpose.secondary,
              actionTitle: "enter_screen/delete-entry/dialog-button-cancel",
              function: () => Navigator.of(context).pop(false),
            )
          ],
          title: "enter_screen/delete-entry/dialog-label-title",
        )
      : // SINGLE-BALANCE DELETE POPUP
      userAlert.showMyActionDialog(
          "enter_screen/delete-entry/dialog-label-delete",
          [
            DialogAction(
              dialogPurpose: DialogPurpose.secondary,
              actionTitle: "enter_screen/delete-entry/dialog-button-cancel",
              function: () => Navigator.of(context).pop(false),
            ),
            DialogAction(
              dialogPurpose: DialogPurpose.danger,
              actionTitle: "enter_screen/delete-entry/dialog-button-delete",
              function: () {
                balanceDataProvider.removeSingleBalanceUsingId(
                  id,
                );
                Navigator.of(context).pop(true);
              },
            ),
          ],
          title: "enter_screen/delete-entry/dialog-label-title",
        );
}
