import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/dialog_action.dart';
import 'package:linum/common/components/dialogs/show_action_dialog.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';
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
            message: tr(translationKeys.alertdialog.deleteAccount.message),
            actions: <DialogAction>[
              DialogAction(
                actionTitle:
                    tr(translationKeys.alertdialog.deleteAccount.cancel),
                dialogPurpose: DialogPurpose.secondary,
                callback: () =>
                    {Navigator.of(context, rootNavigator: true).pop()},
              ),
              DialogAction(
                actionTitle:
                    tr(translationKeys.alertdialog.deleteAccount.action),
                dialogPurpose: DialogPurpose.danger,
                callback: () {
                  final authService = context.read<AuthenticationService>();
                  final onError = (String message) => showAlertDialog(
                    context,
                    message: message,
                    title: translationKeys.alertdialog.resetPassword.title,
                    actionTitle: translationKeys.alertdialog.resetPassword.action,
                    userMustDismissWithButton: true,
                  );
                  authService.deleteUserAccount(onError: onError);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
            title: tr(translationKeys.alertdialog.deleteAccount.title),
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
          tr(translationKeys.settingsScreen.systemSettings.buttonDeleteUser),
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
