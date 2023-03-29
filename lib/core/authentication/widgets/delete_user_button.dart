import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/dialog_action.dart';
import 'package:linum/common/components/dialogs/show_action_dialog.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:provider/provider.dart';


class DeleteUserButton extends StatelessWidget {
  const DeleteUserButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: OutlinedButton(
        onPressed: () {
          showActionDialog(
            context,
            message: tr("alertdialog.delete-account.message"),
            actions: <DialogAction>[
              DialogAction(
                actionTitle: tr("alertdialog.delete-account.cancel"),
                dialogPurpose: DialogPurpose.secondary,
                function: () =>
                    {Navigator.of(context, rootNavigator: true).pop()},
              ),
              DialogAction(
                actionTitle: tr("alertdialog.delete-account.action"),
                dialogPurpose: DialogPurpose.danger,
                function: () {
                  context.read<AuthenticationService>().deleteUserAccount(
                    onError: (message) => showAlertDialog(
                      context,
                      message: message,
                      title: "alertdialog.reset-password.title",
                      actionTitle: "alertdialog.reset-password.action",
                      userMustDismissWithButton: true,
                    ),
                  );
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
            title: tr("alertdialog.delete-account.title"),
          );
        },
        style: OutlinedButton.styleFrom(
          elevation: 8,
          shadowColor: Theme.of(context).colorScheme.onBackground,
          minimumSize: Size(
            double.infinity,
            context.proportionateScreenHeight(48),
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
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
