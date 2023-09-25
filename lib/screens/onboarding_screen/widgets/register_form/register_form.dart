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
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/register_form/register_email_field.dart';
import 'package:linum/screens/onboarding_screen/widgets/register_form/register_password_field.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';




class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();

  bool _mailValidated = false;
  bool _passValidated = false;

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenViewModel viewModel =
        context.watch<OnboardingScreenViewModel>();

    if (viewModel.pageState.isRegister() && viewModel.hasPageChanged) {
      _mailController.clear();
      _passController.clear();
      _mailValidated = false;
      _passValidated = false;
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr(translationKeys.onboardingScreen.registerLipTitle).toUpperCase(),
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
                    RegisterEmailField(
                      controller: _mailController,
                      validated: _mailValidated,
                    ),
                    RegisterPasswordField(
                      controller: _passController,
                      validated: _passValidated,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.proportionateScreenHeight(16),
              ),
              SignInSignUpButton(
                text: tr(translationKeys.onboardingScreen.registerLipSignupButton),
                callback: () {
                  setState(() {
                    _mailController.text.isEmpty
                        ? _mailValidated = true
                        : _mailValidated = false;
                    _passController.text.isEmpty
                        ? _passValidated = true
                        : _passValidated = false;
                  });

                  if (_mailValidated == false && _passValidated == false) {
                    _signUp(_mailController.text, _passController.text);
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
                  text: tr(translationKeys.onboardingScreen.appleButton),
                ),
              ],
              SizedBox(
                height: context.proportionateScreenHeight(32),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: tr(
                        translationKeys.onboardingScreen.registerPrivacy.labelLeading,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                    TextSpan(
                      text: tr(translationKeys.onboardingScreen.registerPrivacy.labelLink),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          launchURL(
                            'https://privacy.linum-app.de',
                          );
                        },
                      style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: tr(
                        translationKeys.onboardingScreen.registerPrivacy.labelTrailing,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
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
              //     style: theme.textTheme.labelLarge?.copyWith(
              //         color: theme.colorScheme.onSurface),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     elevation: 8,
              //     shadowColor: theme.colorScheme.onBackground,
              //     minimumSize: Size(
              //       double.infinity,
              //       proportionateScreenHeight(64),
              //     ),
              //     backgroundColor: theme.colorScheme.background,
              //     side: BorderSide(
              //       width: 2,
              //       color: theme.colorScheme.primary,
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

  void _signUp(String mail, String pass) {
    final OnboardingScreenViewModel viewModel =
      context.read<OnboardingScreenViewModel>();

    final authService = context.read<AuthenticationService>();

    authService.signUp(
      mail.trim(),
      pass,
      onError: (String message) {
        setState(() {
          showAlertDialog(context, message: message);
          _passController.clear();
          _mailValidated = false;
          _passValidated = false;
        });
      },
      onNotVerified: () {
        showAlertDialog(
          context,
          message: tr(translationKeys.alertdialog.signupVerification.message),
          title: tr(translationKeys.alertdialog.signupVerification.title),
          actionTitle: tr(translationKeys.alertdialog.signupVerification.action),
        );
        viewModel.setEmailLoginInputSilently(mail);
        _mailController.clear();
        _passController.clear();
        _mailValidated = false;
        _passValidated = false;
        viewModel.setPageState(OnboardingPageState.login);
      },
    );
  }
}
