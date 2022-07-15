//  User Alert - generates customized Popup Messages (User Alerts) with the option of providing customized callbacks. Oftentimes used for catching errors.
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/dialog_action.dart';

class UserAlert {
  final BuildContext _context;

  UserAlert({required BuildContext context}) : _context = context;

  Future<void> Function(String) showMyDialogCreator({
    String title = 'alertdialog/error/title-standard',
    String actionTitle = 'alertdialog/error/action-standard',
    bool userMustDismissWithButton = true,
  }) {
    return (message) => showMyDialog(
          message,
          title: title,
          actionTitle: actionTitle,
          userMustDismissWithButton: userMustDismissWithButton,
        );
  }

  Future<void> showMyDialog(
    String message, {
    String title = 'alertdialog/login/title-standard',
    String actionTitle = 'alertdialog/login/action-standard',
    bool userMustDismissWithButton = false,
  }) async {
    return showDialog<void>(
      context: _context,
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
            TextButton(
              child: Text(
                actionTitle.tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
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

  Future<bool?> showMyActionDialog(
    String message,
    List<DialogAction> actions, {
    String title = 'alertdialog/error/title-standard',
    bool userMustDismissWithButton = true,
  }) async {
    return showDialog<bool?>(
      context: _context,
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
}
