import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';

class DeleteUserConfirmationDialog extends StatefulWidget {
  const DeleteUserConfirmationDialog({super.key});

  @override
  State<DeleteUserConfirmationDialog> createState() => _DeleteUserConfirmationDialogState();
}

class _DeleteUserConfirmationDialogState extends State<DeleteUserConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Hello world"),
      // TODO: Add password input field
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Read out password and print to console
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text("Ok"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(tr(translationKeys.alertdialog.deleteAccount.cancel)),
        ),
      ],
    );
  }
}
