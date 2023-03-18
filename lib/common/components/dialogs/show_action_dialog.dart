import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/dialog_action.dart';

Future<bool?> showActionDialog(
    BuildContext context, {
      required String message,
      required List<DialogAction> actions,
      String title = 'alertdialog.error.title-standard',
      bool userMustDismissWithButton = true,
    }) async {
  return showDialog<bool?>(
    context: context,
    barrierDismissible:
    !userMustDismissWithButton, // user must tap button if userMustDismissWithButton is true
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title.tr(),
          style: Theme.of(context).textTheme.headline5,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message.tr()),
            ],
          ),
        ),
        actions: <Widget>[
          ...actions.map<Widget>(
                (DialogAction item) {
              Color buttonColor;
              switch (item.dialogPurpose) {
                case DialogPurpose.primary:
                  buttonColor = Theme.of(context).colorScheme.primary;
                  break;
                case DialogPurpose.secondary:
                  buttonColor = Theme.of(context).colorScheme.secondary;
                  break;
                case DialogPurpose.danger:
                  buttonColor = Theme.of(context).colorScheme.error;
                  break;
              }
              return TextButton(
                child: Text(
                  item.actionTitle.tr(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    // color: item.primaryButton
                    //     ? Theme.of(context).colorScheme.primary
                    //     : Theme.of(context).colorScheme.background)),
                    color: buttonColor,
                  ),
                ),
                // ignore: avoid_dynamic_calls
                onPressed: () => item.function(),
              );
            },
          )
        ],
      );
    },
  );
}
