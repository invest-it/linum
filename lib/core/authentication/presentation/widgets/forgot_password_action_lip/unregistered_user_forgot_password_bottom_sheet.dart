import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/forgot_password_input_field.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password_action_lip/forgot_password_scaffold.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

class UnregisteredUserForgotPasswordBottomSheet extends StatelessWidget {
  final TextEditingController controller;

  const UnregisteredUserForgotPasswordBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScaffold(
        label: tr(translationKeys.actionLip.forgotPassword.loggedOut.labelDescription),
        inputField: ForgotPasswordInputField(controller: controller),
        controller: controller,
        callback: () => _callback(context),
        buttonLabel: tr(translationKeys.actionLip.forgotPassword.loggedOut.buttonSubmit),
    );
  }

  void _callback(BuildContext context) {
    final authService = context.read<AuthenticationService>();

    authService.resetPassword(
      controller.text,
      onError: (message)
      {
        showAlertDialog(
          context,
          title: translationKeys.alertdialog.error.titleStandard,
          message: message,
          actionTitle: translationKeys.alertdialog.error.actionStandard,
        );
      },
      onComplete: (String message) {
        showAlertDialog(
          context,
          message: message,
          title: translationKeys.alertdialog.resetPassword.title,
          actionTitle: translationKeys.alertdialog.resetPassword.action,
        );
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
