import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/authentication/widgets/forgot_password_action_lip/forgot_password_action_lip_scaffold.dart';
import 'package:linum/core/authentication/widgets/forgot_password_action_lip/unregistered_user_input_field.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

class UnregisteredUserForgotPasswordActionLip extends StatelessWidget {
  final TextEditingController controller;

  const UnregisteredUserForgotPasswordActionLip({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordActionLipScaffold(
        label: tr(translationKeys.actionLip.forgotPassword.loggedOut.labelDescription),
        inputField: UnregisteredUserInputField(controller: controller),
        controller: controller,
        callback: () => _callback(context),
        buttonLabel: tr(translationKeys.actionLip.forgotPassword.loggedOut.buttonSubmit),
    );
  }

  void _callback(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    final viewModel = context.read<ActionLipViewModel>();

    authService.resetPassword(
      controller.text,
      onError: (message) => showAlertDialog(
        context,
        message:message,
      ),
      onComplete: (String message) {
        showAlertDialog(
          context,
          message: message,
          title: translationKeys.alertdialog.resetPassword.title,
          actionTitle: translationKeys.alertdialog.resetPassword.action,
        );
        viewModel.setActionLipStatus(
          context: context,
          screenKey: ScreenKey.onboarding,
          status: ActionLipVisibility.hidden,
        );
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
