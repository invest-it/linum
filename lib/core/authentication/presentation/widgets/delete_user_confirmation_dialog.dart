import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/generated/translation_keys.g.dart';


class DeleteUserConfirmationDialog extends StatefulWidget {
  final AuthenticationService authService;
  const DeleteUserConfirmationDialog({super.key, required this.authService});

  @override
  State<DeleteUserConfirmationDialog> createState() => _DeleteUserConfirmationDialogState();
}

TextEditingController _textEditingController = TextEditingController();
class _DeleteUserConfirmationDialogState extends State<DeleteUserConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Please enter your password",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
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
            widget.authService.reauthenticate(_textEditingController.text);
            // TODO: Handle authentication result
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
