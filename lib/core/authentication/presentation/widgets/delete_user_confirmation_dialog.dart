import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';

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
      title: Text("Please write your password"),
      // TODO: Add password input field
      content: TextField(
        onChanged: (value){},
        controller: _textEditingController,
        decoration: InputDecoration(hintText: "Enter Password"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Read out password and print to console
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text that the user has entered by using the
                  // TextEditingController.
                  content: Text(_textEditingController.text),
                );
              },
            );
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
