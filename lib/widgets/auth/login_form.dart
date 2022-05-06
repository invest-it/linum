import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:linum/widgets/auth/sign_in_with_google_button.dart';
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
    final UserAlert userAlert = UserAlert(context: context);

    void logIn(String _mail, String _pass) {
      auth.signIn(
        _mail.trim(),
        _pass,
        onError: userAlert.showMyDialog,
        onNotVerified: () => userAlert.showMyDialog(
          "alertdialog/login-verification/message",
          title: "alertdialog/login-verification/title",
          actionTitle: "alertdialog/login-verification/action",
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('onboarding_screen/login-lip-title'),
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
                          hintText: AppLocalizations.of(context)!.translate(
                            'onboarding_screen/login-email-hintlabel',
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _mailValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-email-errorlabel',
                                )
                              : null,
                        ),
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
                          hintText: AppLocalizations.of(context)!.translate(
                            'onboarding_screen/login-password-hintlabel',
                          ),
                          errorText: _passValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-password-errorlabel',
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
                height: proportionateScreenHeight(32),
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

              GradientButton(
                increaseHeightBy: proportionateScreenHeight(16),
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
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    createMaterialColor(const Color(0xFFC1E695)),
                  ],
                ),
                elevation: 0,
                increaseWidthBy: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_screen/login-lip-login-button'),
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              SizedBox(
                height: proportionateScreenHeight(8),
              ),
              ForgotPasswordButton(ProviderKey.onboarding),
              SizedBox(
                height: proportionateScreenHeight(8),
              ),
              // const GoogleSignInButton()
              SignInWithGoogleButton(
                onPressed: auth.signInWithGoogle,
              ),
              SizedBox(
                height: proportionateScreenHeight(6),
              ),
              if (Platform.isIOS)...[ // Works only on iOS at the moment (according to Google)
                SignInWithAppleButton(
                  onPressed: auth.signInWithApple,
                  text: AppLocalizations.of(context)!.translate(
                    'onboarding_screen/apple-button',
                  ),
                )
              ],
            ],
          ),
        ),
      ],
    );
  }
}
