import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/enter_screen_provider.dart';

void showAddAmountAlertDialog(
    BuildContext context,
    EnterScreenProvider enterScreenProvider,
    ) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          tr('enter_screen.add-amount.dialog-label-title-expenses'),
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              tr('enter_screen.add-amount.dialog-label-title'),
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
