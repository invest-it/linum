//  Forgot Password - Button that provides functionalities to reset the user password
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/utils/show_forgot_password_action_lip.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';


class ForgotPasswordButton extends StatelessWidget {
  final ScreenKey screenKey;

  const ForgotPasswordButton(this.screenKey);


  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService =
        context.read<AuthenticationService>();

    final theme = Theme.of(context);

    return OutlinedButton(
      key: const Key("forgotPasswordButton"),
      onPressed: () => showForgotPasswordBottomSheet(context, screenKey),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: theme.colorScheme.primary,
        ),
      ),
      child: Text(
        authenticationService.isLoggedIn
            ? tr(translationKeys.settingsScreen.systemSettings.buttonForgotPassword)
            : tr(translationKeys.onboardingScreen.loginLipForgotPasswordButton),
        style: theme.textTheme.labelMedium
            ?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}
