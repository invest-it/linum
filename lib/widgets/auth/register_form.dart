//  Register Form - Form for signing the user up
//
//  Author: NightmindOfficial
//  Co-Author: damattl, SoTBurst
//

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/backend/url_handler.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/utilities/frontend/user_alert.dart';
import 'package:linum/widgets/auth/sign_in_sign_up_button.dart';
import 'package:linum/widgets/auth/sign_in_with_google_button.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
    final OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(context);

    if (onboardingScreenProvider.pageState == OnboardingPageState.register &&
        onboardingScreenProvider.hasPageChanged) {
      _mailController.clear();
      _passController.clear();
      _mailValidate = false;
      _passValidate = false;
    }

    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);
    final UserAlert userAlert = UserAlert(context: context);

    void signUp(String _mail, String _pass) {
      auth.signUp(
        _mail.trim(),
        _pass,
        onError: (String message) {
          setState(() {
            userAlert.showMyDialog(message);
            _passController.clear();
            _mailValidate = false;
            _passValidate = false;
          });
        },
        onNotVerified: () {
          userAlert.showMyDialog(
            'alertdialog/signup-verification/message',
            title: 'alertdialog/signup-verification/title',
            actionTitle: 'alertdialog/signup-verification/action',
          );
          onboardingScreenProvider.setEmailLoginInputSilently(_mail);
          _mailController.clear();
          _passController.clear();
          _mailValidate = false;
          _passValidate = false;
          onboardingScreenProvider.setPageState(OnboardingPageState.login);
        },
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            AppLocalizations.of(context)!
                .translate('onboarding_screen/register-lip-title'),
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
                          hintText: AppLocalizations.of(context)!
                              .translate('onboarding_screen/register-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _mailValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/register-email-errorlabel',
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
                          hintText: AppLocalizations.of(context)!.translate(
                            'onboarding_screen/register-password-hintlabel',
                          ),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          errorText: _passValidate
                              ? AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/register-password-errorlabel',
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: proportionateScreenHeight(16),
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
                text: AppLocalizations.of(context)!
                  .translate('onboarding_screen/register-lip-signup-button'),
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
                height: proportionateScreenHeight(12),
              ),
              SignInWithGoogleButton(
                onPressed: auth.signInWithGoogle,
              ),
              SizedBox(
                height: proportionateScreenHeight(6),
              ),
              if (Platform.isIOS) ...[
                // Works only on iOS at the moment (according to Google)
                SignInWithAppleButton(
                  onPressed: auth.signInWithApple,
                  text: AppLocalizations.of(context)!.translate(
                    'onboarding_screen/apple-button',
                  ),
                )
              ],
              SizedBox(
                height: proportionateScreenHeight(32),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.translate(
                        'onboarding_screen/register-privacy/label-leading',
                      ),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.translate(
                        'onboarding_screen/register-privacy/label-link',
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          launchURL('https://investit-academy.de/privacy');
                        },
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.translate(
                        'onboarding_screen/register-privacy/label-trailing',
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
