import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    BuildContext context, {
      required String message,
      String title = 'alertdialog.login.title-standard',
      String actionTitle = 'alertdialog.login.action-standard',
      bool userMustDismissWithButton = false,
    }) async {
  final actionTitleStyle = Theme.of(context).textTheme.bodyLarge
      ?.copyWith(color: Theme.of(context).colorScheme.primary);

  return showDialog<void>(
    context: context,
    barrierDismissible:
    !userMustDismissWithButton, // user must tap button if userMustDismissWithButton is true
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
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
              style: actionTitleStyle,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );
    },
  );
}
