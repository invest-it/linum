import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/generated/translation_keys.g.dart';

import '../../../../common/components/dialogs/dialog_action.dart';
import '../../../../common/components/dialogs/show_alert_dialog.dart';


class DeleteUserConfirmationDialog extends StatefulWidget {
  final AuthenticationService authService;
  const DeleteUserConfirmationDialog({super.key, required this.authService});

  @override
  State<DeleteUserConfirmationDialog> createState() => _DeleteUserConfirmationDialogState();
}


class _DeleteUserConfirmationDialogState extends State<DeleteUserConfirmationDialog> {
  final _textEditingController = TextEditingController();
  bool? _reauthenticateResult = null; //null, da Variabel nicht inisalisiert ist
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Please enter your password",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: TextFormField(
        onChanged: (value){},
        controller: _textEditingController,
        decoration: const InputDecoration(hintText: "Enter Password"),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        autovalidateMode: AutovalidateMode.always,
        validator: (String? value) {
          if (_reauthenticateResult == false){
            return 'The password is not correct';
          }
          return null;
        }
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final result = await widget.authService.reauthenticate(_textEditingController.text);
            // TODO: Handle authentication result
            if(result){
              if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
              widget.authService.deleteUserAccount();
              return;
            }
            setState((){
              _reauthenticateResult = result;
            });
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
