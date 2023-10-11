import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/change_email_action_lip_scaffold.dart';
import 'package:linum/core/authentication/presentation/widgets/change_email_action_lip/email_input_field.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

class ChangeEmailActionLip extends StatelessWidget {
  final TextEditingController controller;

  const ChangeEmailActionLip({
    super.key,
    required this.controller,
  });



  @override
  Widget build(BuildContext context) {
    return ChangeEmailActionLipScaffold(
      label: tr(translationKeys.actionLip.changeEmail.labelDescription),
      inputField: EmailInputField(controller: controller, onEditingComplete: () => _callback(context)),
      controller: controller,
      callback: () => _callback(context),
      buttonLabel: tr(translationKeys.actionLip.changeEmail.buttonSubmit),
    );
  }

  void _callback(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    final viewModel = context.read<ActionLipViewModel>();

    authService.updateEmail(
      controller.text,
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
        viewModel.setActionLipStatus(
          context: context,
          screenKey: ScreenKey.settings,
          status: ActionLipVisibility.hidden,
        );
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
