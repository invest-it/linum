import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';

class LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool validated;

  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.validated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: TextField(
        key: const Key("loginPasswordField"),
        obscureText: true,
        controller: controller,
        keyboardType: TextInputType.visiblePassword,
        //onSubmitted: (_) =>
        //    logIn(_mailController!.text, _passController.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:
          tr(translationKeys.onboardingScreen.loginPasswordHintlabel),
          errorText: _errorText(validated),
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  String? _errorText(bool validated) {
    if (validated) {
      return tr(translationKeys.onboardingScreen.loginPasswordErrorlabel);
    }
    return null;
  }
}
