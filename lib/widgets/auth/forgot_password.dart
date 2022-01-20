import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class ForgotPasswordButton extends StatelessWidget {
  ForgotPasswordButton(this.providerKey);

  final ProviderKey providerKey;
  final _mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);

    AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    UserAlert userAlert = UserAlert(context: context);

    void forgotPWactionLip() {
      actionLipStatusProvider.setActionLip(
          providerKey: providerKey,
          actionLipBody: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                        'action_lip/forgot-password/label-description'),
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
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
                              onEditingComplete: () => {
                                authenticationService.resetPassword(
                                    _mailController.text,
                                    onError: userAlert.showMyDialog),
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)!.translate(
                                    'onboarding_screen/login-email-hintlabel'),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: proportionateScreenHeight(32),
                    ),
                    GradientButton(
                      increaseHeightBy: proportionateScreenHeight(16),
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                            'action_lip/forgot-password/button-submit'),
                        style: Theme.of(context).textTheme.button,
                      ),
                      callback: () => {
                        authenticationService.resetPassword(
                            _mailController.text,
                            onError: userAlert.showMyDialog),
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
                  ],
                ),
              )
            ],
          ),
          actionLipStatus: ActionLipStatus.ONVIEWPORT,
          actionLipTitle: AppLocalizations.of(context)!
              .translate('action_lip/forgot-password/label-title'));
    }

    return OutlinedButton(
      onPressed: forgotPWactionLip,
      child: Text(
        AppLocalizations.of(context)!
            .translate('onboarding_screen/login-lip-forgot-password-button'),
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
      style: OutlinedButton.styleFrom(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size(
          double.infinity,
          proportionateScreenHeight(64),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
