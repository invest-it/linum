import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class DeleteUserConfirmationDialog extends StatefulWidget {
  const DeleteUserConfirmationDialog({super.key});

  @override
  State<DeleteUserConfirmationDialog> createState() => _DeleteUserConfirmationDialogState();
}

TextEditingController _textEditingController = TextEditingController();
class _DeleteUserConfirmationDialogState extends State<DeleteUserConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Please write your password",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      // TODO: Add password input field
      content: TextField(
        onChanged: (value){},
        controller: _textEditingController,
        decoration: const InputDecoration(hintText: "Enter Password"),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // TODO: Read out password and print to console
            print(_textEditingController.text);
            final authService = context.read<AuthenticationService>();

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
