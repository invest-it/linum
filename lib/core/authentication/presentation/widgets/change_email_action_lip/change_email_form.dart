

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/email_input_field.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

class ChangeEmailForm extends StatefulWidget {
  const ChangeEmailForm({super.key});

  @override
  State<ChangeEmailForm> createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                EmailInputField(
                  controller: _controller,
                  validator: (value) {
                    // checks if input is a valid email address
                    final bool valid = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',)
                        .hasMatch(value??"");
                    if(!valid){
                      return tr(translationKeys.actionLip.changeEmail.emailNotValid);
                    }
                    return null;
                  },
                  onEditingComplete: () => _callback(context),
                  hintLabel: tr(translationKeys.actionLip.changeEmail.hintLabel,
                  ),),
                EmailInputField(
                  validator: (value) {
                    if(_controller.value.text != value) {
                      return tr(translationKeys.actionLip.changeEmail.emailRepeatMismatchError);
                    }
                    return null;
                  },
                  onEditingComplete: () => _callback(context),
                  hintLabel: tr(translationKeys.actionLip.changeEmail.hintLabelRepeat),
                ),
                FilledButton(
                  onPressed: () {
                    final bool valid = _formKey.currentState!.validate();
                    if (valid) {
                      _callback(context);
                    }
                  },
                  child: Text(
                    tr(translationKeys.actionLip.changeEmail.buttonSubmit),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _callback(BuildContext context) {
    final authService = context.read<AuthenticationService>();

    authService.updateEmail(
      _controller.text,
      onError: (message) => showAlertDialog(
        context,
        message: message,
        title: translationKeys.alertdialog.error.titleStandard,
      ),
      onComplete: (String message) {
        showAlertDialog(
          context,
          message: message,
          title: translationKeys.alertdialog.updateEmail.title,
          actionTitle: translationKeys.alertdialog.updateEmail.action,
        );
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
