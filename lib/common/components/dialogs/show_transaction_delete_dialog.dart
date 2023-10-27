import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/dialog_action.dart';
import 'package:linum/common/components/dialogs/show_action_dialog.dart';
import 'package:linum/generated/translation_keys.g.dart';

void showTransactionDeleteDialog(
    BuildContext context,
    Function() callbackFunction,
    ) {
  showActionDialog(
    context,
    message: tr(translationKeys.alertdialog.deleteTransaction.dialogLabelDelete),
    title: tr(translationKeys.alertdialog.deleteTransaction.dialogLabelTitle),
    userMustDismissWithButton: false,
    actions: <DialogAction>[
      DialogAction(
        actionTitle: tr(
          translationKeys.alertdialog.deleteTransaction.dialogButtonCancel,
        ),
      ),
      DialogAction(
        actionTitle: tr(
          translationKeys.alertdialog.deleteTransaction.dialogButtonDelete,
        ),
        callback: callbackFunction,
        dialogPurpose: DialogPurpose.danger,
      ),
    ],
  );
}
