import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';

class UnregisteredUserInputField extends StatelessWidget {
  final TextEditingController controller;
  const UnregisteredUserInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: () => {
          authService.resetPassword(
            controller.text,
            onError: (message) => showAlertDialog(
              context,
              message: message,
            ),
            onComplete: (message) => showAlertDialog(
              context,
              message: message,
              title: translationKeys.alertdialog.resetPassword.title,
              actionTitle: translationKeys.alertdialog.resetPassword.action,
              userMustDismissWithButton: true,
            ),
          ),
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: tr(
            translationKeys.onboardingScreen.loginEmailHintlabel,
          ),
          hintStyle: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
