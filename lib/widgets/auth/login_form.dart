import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _mailController = TextEditingController();

  final _passController = TextEditingController();

  late final Function logIn;

  // hides developer login bypasses
  int devMode = 0;

  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);
    UserAlert userAlert = UserAlert(context: context);

    void logIn(String _mail, String _pass) {
      auth.signIn(_mail, _pass, onError: userAlert.showMyDialog);
    }

    return Column(
      children: [
        devMode >= 6
            ? Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      primary: Theme.of(context).colorScheme.onError,
                    ),
                    onPressed: () => {
                      auth.signIn("Soencke.Evers@investit-academy.de",
                          "tempPassword123"),
                    },
                    child: Text(
                      'Perform Normal Login',
                      style: Theme.of(context).textTheme.overline?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        primary: Theme.of(context).colorScheme.error),
                    onPressed: () => {
                      auth.signIn(
                        "linum.debug@investit-academy.de",
                        "F8q^5w!F9S4#!",
                      ),
                    },
                    child: Text(
                      'Perform Stress Test',
                      style: Theme.of(context).textTheme.overline?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              )
            : Wrap(),
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
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onBackground,
                        blurRadius: 20.0,
                        offset: Offset(0, 10),
                      ),
                    ]),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        controller: _mailController,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/login-email-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: TextField(
                        obscureText: true,
                        controller: _passController,
                        keyboardType: TextInputType.visiblePassword,
                        onSubmitted: (_) => {
                          setState(
                            () {
                              logIn(_mailController.text, _passController.text);
                            },
                          )
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.translate(
                              'onboarding_screen/login-password-hintlabel'),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
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
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_screen/login-lip-login-button'),
                  style: Theme.of(context).textTheme.button,
                ),
                callback: () => {
                  setState(
                    () {
                      logIn(_mailController.text, _passController.text);
                    },
                  )
                },
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    createMaterialColor(Color(0xFFC1E695)),
                  ],
                ),
                elevation: 0,
                increaseWidthBy: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              SizedBox(
                height: proportionateScreenHeight(8),
              ),
              ForgotPasswordButton(ProviderKey.ONBOARDING),
              IconButton(
                color: Colors.grey.shade200,
                onPressed: () {
                  setState(() {
                    devMode++;
                    log(
                      devMode < 6
                          ? 'OK, in ' +
                              (6 - devMode).toString() +
                              ' Schritten bist du Entwickler.'
                          : 'OK, du bist nun Entwickler.',
                    );
                  });
                },
                icon: Icon(Icons.developer_board_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
