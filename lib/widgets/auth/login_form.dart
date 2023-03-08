//  Login Form - Form for signing the user in
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored)

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:linum/widgets/auth/sign_in_sign_up_button.dart';
import 'package:linum/widgets/auth/sign_in_with_google_button.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

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
    final OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(context);

    if (onboardingScreenProvider.pageState == OnboardingPageState.login &&
        onboardingScreenProvider.hasPageChanged) {
      _mailController = null;
      _passController.clear();
      _mailValidate = false;
      _passValidate = false;
    }

    _mailController ??=
        TextEditingController(text: onboardingScreenProvider.mailInput);

    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);

    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);

    final UserAlert userAlert = UserAlert(context: context);

    void logIn(String mail, String pass) {
      auth.signIn(
        mail.trim(),
        pass,
        onError: userAlert.showMyDialog,
        onNotVerified: () => userAlert.showMyDialog(
          "alertdialog.login-verification.message",
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
            style: Theme.of(context).textTheme.headline5,
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
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _mailValidate
                              ? tr('onboarding_screen.login-email-errorlabel')
                              : null,
                        ),
                        onTap: () {
                          onboardingScreenProvider
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
                              .bodyText1
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
                height: sizeGuideProvider.proportionateScreenHeight(32),
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
              //       style: Theme.of(context).textTheme.button,
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
                height: sizeGuideProvider.proportionateScreenHeight(8),
              ),
              ForgotPasswordButton(ProviderKey.onboarding),
              SizedBox(
                height: sizeGuideProvider.proportionateScreenHeight(8),
              ),
              SignInWithGoogleButton(
                onPressed: auth.signInWithGoogle,
              ),
              SizedBox(
                height: sizeGuideProvider.proportionateScreenHeight(8),
              ),
              if (Platform.isIOS) ...[
                // Works only on iOS at the moment (according to Google)
                SignInWithAppleButton(
                  onPressed: auth.signInWithApple,
                  text: tr('onboarding_screen.apple-button'),
                  height: sizeGuideProvider.proportionateScreenHeight(40),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
