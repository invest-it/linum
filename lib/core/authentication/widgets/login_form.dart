//  Login Form - Form for signing the user in
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored)

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/authentication/widgets/forgot_password.dart';
import 'package:linum/core/authentication/widgets/sign_in_sign_up_button.dart';
import 'package:linum/core/authentication/widgets/sign_in_with_google_button.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController? _mailController;

  final _passController = TextEditingController();

  bool _mailValidate = false;
  bool _passValidate = false;

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenViewModel viewModel =
        context.watch<OnboardingScreenViewModel>();

    if (viewModel.pageState == OnboardingPageState.login &&
        viewModel.hasPageChanged) {
      _mailController = null;
      _passController.clear();
      _mailValidate = false;
      _passValidate = false;
    }

    _mailController ??=
        TextEditingController(text: viewModel.mailInput);

    void logIn(String mail, String pass) {
      context.read<AuthenticationService>().signIn(
        mail.trim(),
        pass,
        onError: (message) => showAlertDialog(context, message: message),
        onNotVerified: () => showAlertDialog(
          context,
          message: "alertdialog.login-verification.message",
          title: "alertdialog.login-verification.title",
          actionTitle: "alertdialog.login-verification.action",
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr('onboarding_screen.login-lip-title'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onBackground,
                      blurRadius: 20.0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        key: const Key("loginEmailField"),
                        controller: _mailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              tr('onboarding_screen.login-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _mailValidate
                              ? tr('onboarding_screen.login-email-errorlabel')
                              : null,
                        ),
                        onTap: () {
                          viewModel
                              .setPageState(OnboardingPageState.login);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        key: const Key("loginPasswordField"),
                        obscureText: true,
                        controller: _passController,
                        keyboardType: TextInputType.visiblePassword,
                        //onSubmitted: (_) =>
                        //    logIn(_mailController!.text, _passController.text),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              tr('onboarding_screen.login-password-hintlabel'),
                          errorText: _passValidate
                              ? tr(
                                  'onboarding_screen.login-password-errorlabel',
                                )
                              : null,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.proportionateScreenHeight(32),
              ),
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     gradient: LinearGradient(
              //       colors: [
              //         Theme.of(context).colorScheme.primary,
              //         Theme.of(context).colorScheme.surface,
              //       ],
              //     ),
              //   ),
              //   child: Center(
              //     child: Text(
              //       'Einloggen',
              //       style: Theme.of(context).textTheme.labelLarge,
              //     ),
              //   ),
              // ),

              SignInSignUpButton(
                text: tr('onboarding_screen.login-lip-login-button'),
                callback: () {
                  setState(() {
                    _mailController!.text.isEmpty
                        ? _mailValidate = true
                        : _mailValidate = false;
                    _passController.text.isEmpty
                        ? _passValidate = true
                        : _passValidate = false;
                  });

                  if (_mailValidate == false && _passValidate == false) {
                    logIn(_mailController!.text, _passController.text);
                  }
                },
              ),
              SizedBox(
                height: context.proportionateScreenHeight(8),
              ),
              ForgotPasswordButton(ScreenKey.onboarding),
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
                  text: tr('onboarding_screen.apple-button'),
                  height: context.proportionateScreenHeight(40),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
