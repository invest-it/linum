import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/dialog_action.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/utilities/frontend/delete_entry_popup.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:provider/provider.dart';

class DeleteUserButton extends StatelessWidget {
  const DeleteUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context);

    final UserAlert userAlert = UserAlert(context: context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: OutlinedButton(
        onPressed: () {
          userAlert.showActionDialog(
            tr("alertdialog.delete-account.title"),
            <DialogAction>[
              DialogAction(
                actionTitle: tr("alertdialog.delete-account.action"),
                function: () {
                  authenticationService.deleteUserAccount(
                    onError: userAlert.showMyDialogCreator(
                      title: "alertdialog.reset-password.title",
                      actionTitle: "alertdialog.reset-password.action",
                    ),
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              DialogAction(
                actionTitle: tr("alertdialog.delete-account.cancel"),
                function: () =>
                    {Navigator.of(context, rootNavigator: true).pop()},
              ),
            ],
          );
        },
        style: OutlinedButton.styleFrom(
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.onBackground,
          minimumSize: Size(
            double.infinity,
            proportionateScreenHeight(48),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          side: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          tr("settings_screen.system-settings.button-delete-user"),
          style: Theme.of(context)
              .textTheme
              .button
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
