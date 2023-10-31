//  Login Form - Form for signing the user in
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored)

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/authentication/presentation/widgets/forgot_password.dart';
import 'package:linum/core/authentication/presentation/widgets/sign_in_sign_up_button.dart';
import 'package:linum/core/authentication/presentation/widgets/sign_in_with_google_button.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/login_form/login_email_field.dart';
import 'package:linum/screens/onboarding_screen/widgets/login_form/login_password_field.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController? _mailController;

  final _passController = TextEditingController();

  bool _mailValidated = false;
  bool _passValidated = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingScreenViewModel>();
    final theme = Theme.of(context);

    if (viewModel.pageState.isLogin() && viewModel.hasPageChanged) {
      _mailController = null;
      _passController.clear();
      _mailValidated = false;
      _passValidated = false;
    }

    _mailController ??= TextEditingController(text: viewModel.mailInput);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr(translationKeys.onboardingScreen.loginLipTitle),
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.onBackground,
                      blurRadius: 20.0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    LoginEmailField(
                        controller: _mailController!,
                        validated: _mailValidated,
                    ),
                    LoginPasswordField(
                        controller: _passController,
                        validated: _passValidated,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.proportionateScreenHeight(32),
              ),
              SignInSignUpButton(
                text: tr(translationKeys.onboardingScreen.loginLipLoginButton),
                callback: _signInCallback,
              ),
              SizedBox(
                height: context.proportionateScreenHeight(8),
              ),
              const ForgotPasswordButton(ScreenKey.onboarding),
              SizedBox(
                height: context.proportionateScreenHeight(8),
              ),
              SignInWithGoogleButton(
                onPressed: context.read<AuthenticationService>().signInWithGoogle,
              ),
              SizedBox(
                height: context.proportionateScreenHeight(8),
              ),
              if (Platform.isIOS) ...[
                // Works only on iOS at the moment (according to Google)
                SignInWithAppleButton(
                  onPressed: context.read<AuthenticationService>().signInWithApple,
                  text: tr(translationKeys.onboardingScreen.appleButton),
                  height: context.proportionateScreenHeight(40),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _signInCallback() {
    setState(() {
      _mailController!.text.isEmpty
          ? _mailValidated = true
          : _mailValidated = false;
      _passController.text.isEmpty
          ? _passValidated = true
          : _passValidated = false;
    });

    if (!_mailValidated && !_passValidated) {
      _logIn(_mailController!.text, _passController.text);
    }
  }

  void _logIn(String mail, String pass) {
    final authService = context.read<AuthenticationService>();
    authService.signIn(
      mail.trim(),
      pass,
      onError: (message) => showAlertDialog(context, message: message),
      onNotVerified: () => showAlertDialog(
        context,
        message: translationKeys.alertdialog.loginVerification.message,
        title: translationKeys.alertdialog.loginVerification.title,
        actionTitle: translationKeys.alertdialog.loginVerification.action,
      ),
    );
  }
}
