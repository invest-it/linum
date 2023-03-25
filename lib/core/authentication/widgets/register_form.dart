//  Register Form - Form for signing the user up
//
//  Author: NightmindOfficial
//  Co-Author: damattl, SoTBurst
//

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/authentication/widgets/sign_in_sign_up_button.dart';
import 'package:linum/core/authentication/widgets/sign_in_with_google_button.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/navigation/url_handler.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();

  bool _mailValidate = false;
  bool _passValidate = false;

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenViewModel viewModel =
        context.watch<OnboardingScreenViewModel>();

    if (viewModel.pageState == OnboardingPageState.register &&
        viewModel.hasPageChanged) {
      _mailController.clear();
      _passController.clear();
      _mailValidate = false;
      _passValidate = false;
    }

    void signUp(String mail, String pass) {
      context.read<AuthenticationService>().signUp(
        mail.trim(),
        pass,
        onError: (String message) {
          setState(() {
            showAlertDialog(context, message: message);
            _passController.clear();
            _mailValidate = false;
            _passValidate = false;
          });
        },
        onNotVerified: () {
          showAlertDialog(
            context,
            message: tr("alertdialog.signup-verification.message"),
            title: tr("alertdialog.signup-verification.title"),
            actionTitle: tr("alertdialog.signup-verification.action"),
          );
          viewModel.setEmailLoginInputSilently(mail);
          _mailController.clear();
          _passController.clear();
          _mailValidate = false;
          _passValidate = false;
          viewModel.setPageState(OnboardingPageState.login);
        },
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr('onboarding_screen.register-lip-title').toUpperCase(),
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
                        key: const Key("registerEmailField"),
                        controller: _mailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              tr('onboarding_screen.register-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _mailValidate
                              ? tr(
                                  'onboarding_screen.register-email-errorlabel',
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
                        key: const Key("registerPasswordField"),
                        obscureText: true,
                        controller: _passController,
                        keyboardType: TextInputType.visiblePassword,
                        // onSubmitted: (_) => {
                        //   setState(
                        //     () {
                        //       signUp(
                        //           _mailController.text, _passController.text);
                        //     },
                        //   )
                        // },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: tr(
                            'onboarding_screen.register-password-hintlabel',
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _passValidate
                              ? tr(
                                  'onboarding_screen.register-password-errorlabel',
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.proportionateScreenHeight(16),
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
                text: tr('onboarding_screen.register-lip-signup-button'),
                callback: () {
                  setState(() {
                    _mailController.text.isEmpty
                        ? _mailValidate = true
                        : _mailValidate = false;
                    _passController.text.isEmpty
                        ? _passValidate = true
                        : _passValidate = false;
                  });

                  if (_mailValidate == false && _passValidate == false) {
                    signUp(_mailController.text, _passController.text);
                  }
                },
              ),
              SizedBox(
                height: context.proportionateScreenHeight(12),
              ),
              SignInWithGoogleButton(
                onPressed: context.read<AuthenticationService>()
                    .signInWithGoogle,
              ),
              SizedBox(
                height: context.proportionateScreenHeight(6),
              ),
              if (Platform.isIOS) ...[
                // Works only on iOS at the moment (according to Google)
                SignInWithAppleButton(
                  onPressed: context.read<AuthenticationService>()
                      .signInWithApple,
                  text: tr('onboarding_screen.apple-button'),
                )
              ],
              SizedBox(
                height: context.proportionateScreenHeight(32),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: tr(
                        'onboarding_screen.register-privacy.label-leading',
                      ),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    TextSpan(
                      text: tr('onboarding_screen.register-privacy.label-link'),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          launchURL(
                            'https://privacy.linum-app.de',
                          );
                        },
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: tr(
                        'onboarding_screen.register-privacy.label-trailing',
                      ),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              /*
              // TODO: Remove in prod
               SignInWithAppleButton(
                onPressed: auth.signInWithApple,
              ) */
// SAVE THIS SPACE FOR ALTERNATE SIGNUP FUNCTIONS

              // OutlinedButton(
              //   //to-do: implement this functionality
              //   onPressed: null,
              //   child: Text(
              //     AppLocalizations.of(context)!.translate(
              //         'onboarding_screen/login-lip-forgot-password-button'),
              //     style: Theme.of(context).textTheme.button?.copyWith(
              //         color: Theme.of(context).colorScheme.onSurface),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     elevation: 8,
              //     shadowColor: Theme.of(context).colorScheme.onBackground,
              //     minimumSize: Size(
              //       double.infinity,
              //       proportionateScreenHeight(64),
              //     ),
              //     backgroundColor: Theme.of(context).colorScheme.background,
              //     side: BorderSide(
              //       width: 2,
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
