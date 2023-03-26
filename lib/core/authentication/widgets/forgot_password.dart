//  Forgot Password - Button that provides functionalities to reset the user password
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/common/components/dialogs/show_alert_dialog.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class ForgotPasswordButton extends StatelessWidget {
  ForgotPasswordButton(this.screenKey);

  final ScreenKey screenKey;
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ActionLipViewModel actionLipStatusProvider =
        context.read<ActionLipViewModel>();

    final AuthenticationService authenticationService =
        context.read<AuthenticationService>();

    void forgotPasswordActionLip() {
      // lip if the user is not logged in
      if (!authenticationService.isLoggedIn) {
        actionLipStatusProvider.setActionLip(
          context: context,
          screenKey: screenKey,
          actionLipBody: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    tr('action_lip.forgot-password.logged-out.label-description'),
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
                              controller: _inputController,
                              keyboardType: TextInputType.emailAddress,
                              onEditingComplete: () => {
                                authenticationService.resetPassword(
                                  _inputController.text,
                                  onError: (message) => showAlertDialog(
                                    context,
                                    message: message,
                                  ),
                                  onComplete: (message) => showAlertDialog(
                                    context,
                                    message: message,
                                    title: "alertdialog.reset-password.title",
                                    actionTitle: "alertdialog.reset-password.action",
                                    userMustDismissWithButton: true,
                                  ),
                                ),
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: tr(
                                  'onboarding_screen.login-email-hintlabel',
                                ),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                    GradientButton(
                      increaseHeightBy:
                          context.proportionateScreenHeight(16),
                      // Logged Out onPressed
                      callback: () {
                        authenticationService.resetPassword(
                          _inputController.text,
                          onError: (message) => showAlertDialog(
                            context,
                            message:message,
                          ),
                          onComplete: (String message) {
                            showAlertDialog(
                              context,
                              message: message,
                              title: "alertdialog.reset-password.title",
                              actionTitle: "alertdialog.reset-password.action",
                            );
                            actionLipStatusProvider.setActionLipStatus(
                              context: context,
                              screenKey: ScreenKey.onboarding,
                              status: ActionLipVisibility.hidden,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        );
                      },
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          const Color(0xFFC1E695),
                        ],
                      ),
                      elevation: 0,
                      increaseWidthBy: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tr('action_lip.forgot-password.logged-out.button-submit'),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actionLipStatus: ActionLipVisibility.onviewport,
          actionLipTitle:
              tr('action_lip.forgot-password.logged-out.label-title'),
        );
      }
      // lip if the user has already authenticated themself
      else {
        actionLipStatusProvider.setActionLip(
          context: context,
          screenKey: screenKey,
          actionLipBody: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    tr('action_lip.forgot-password.logged-in.label-description'),
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
                              obscureText: true,
                              controller: _inputController,
                              keyboardType: TextInputType.visiblePassword,
                              onEditingComplete: () => {
                                authenticationService.updatePassword(
                                  _inputController.text,
                                  onError: (message) => showAlertDialog(
                                    context,
                                    message: message,
                                  ),
                                  onComplete: (message) => showAlertDialog(
                                    context,
                                    message: message,
                                    title: "alertdialog.update-password.title",
                                    actionTitle:
                                      "alertdialog.update-password.action",
                                    userMustDismissWithButton: true,
                                  ),
                                ),
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: tr(
                                  'onboarding_screen.login-password-hintlabel',
                                ),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
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
                    GradientButton(
                      increaseHeightBy:
                          context.proportionateScreenHeight(16),
                      //Logged in onPressed
                      callback: () => {
                        authenticationService.updatePassword(
                          _inputController.text,
                          onError: (message) => showAlertDialog(
                            context,
                            message: message,
                          ),
                          onComplete: (String message) {
                            showAlertDialog(
                              context,
                              message: message,
                              title: "alertdialog.update-password.title",
                              actionTitle: "alertdialog.update-password.action",
                            );
                            actionLipStatusProvider.setActionLipStatus(
                              context: context,
                              screenKey: ScreenKey.settings,
                              status: ActionLipVisibility.hidden,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      },
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          const Color(0xFFC1E695),
                        ],
                      ),
                      elevation: 0,
                      increaseWidthBy: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tr('action_lip.forgot-password.logged-in.button-submit'),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actionLipStatus: ActionLipVisibility.onviewport,
          actionLipTitle:
              tr('action_lip.forgot-password.logged-in.label-title'),
        );
      }
    }

    return OutlinedButton(
      key: const Key("forgotPasswordButton"),
      onPressed: forgotPasswordActionLip,
      style: OutlinedButton.styleFrom(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size(
          double.infinity,
          context.proportionateScreenHeight(48),
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
      child: Text(
        authenticationService.isLoggedIn
            ? tr("settings_screen.system-settings.button-forgot-password")
            : tr('onboarding_screen.login-lip-forgot-password-button'),
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
