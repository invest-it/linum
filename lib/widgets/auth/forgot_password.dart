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
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);

    final AuthenticationService authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    final UserAlert userAlert = UserAlert(context: context);

    void forgotPWactionLip() {
      // lip if the user is not logged in
      if (!authenticationService.isLoggedIn) {
        actionLipStatusProvider.setActionLip(
          providerKey: providerKey,
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
                    AppLocalizations.of(context)!.translate(
                      'action_lip/forgot-password/logged-out/label-description',
                    ),
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
                                  onError: userAlert.showMyDialog,
                                  onComplete: userAlert.showMyDialogCreator(
                                    title: "alertdialog/reset-password/title",
                                    actionTitle:
                                        "alertdialog/reset-password/action",
                                  ),
                                ),
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-email-hintlabel',
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
                      height: proportionateScreenHeight(32),
                    ),
                    GradientButton(
                      increaseHeightBy: proportionateScreenHeight(16),
                      // Logged Out onPressed
                      callback: () {
                        authenticationService.resetPassword(
                          _inputController.text,
                          onError: userAlert.showMyDialog,
                          onComplete: (String message) {
                            userAlert.showMyDialog(
                              message,
                              title: "alertdialog/reset-password/title",
                              actionTitle: "alertdialog/reset-password/action",
                            );
                            actionLipStatusProvider.setActionLipStatus(
                              providerKey: ProviderKey.onboarding,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        );
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
                        AppLocalizations.of(context)!.translate(
                          'action_lip/forgot-password/logged-out/button-submit',
                        ),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actionLipStatus: ActionLipStatus.ONVIEWPORT,
          actionLipTitle: AppLocalizations.of(context)!.translate(
            'action_lip/forgot-password/logged-out/label-title',
          ),
        );
      }
      // lip if the user has already authenticated themself
      else {
        actionLipStatusProvider.setActionLip(
          providerKey: providerKey,
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
                    AppLocalizations.of(context)!.translate(
                      'action_lip/forgot-password/logged-in/label-description',
                    ),
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
                                  onError: userAlert.showMyDialog,
                                  onComplete: userAlert.showMyDialogCreator(
                                    title: "alertdialog/update-password/title",
                                    actionTitle:
                                        "alertdialog/update-password/action",
                                  ),
                                ),
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    AppLocalizations.of(context)!.translate(
                                  'onboarding_screen/login-password-hintlabel',
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
                      height: proportionateScreenHeight(32),
                    ),
                    GradientButton(
                      increaseHeightBy: proportionateScreenHeight(16),
                      //Logged in onPressed
                      callback: () => {
                        authenticationService.updatePassword(
                          _inputController.text,
                          onError: userAlert.showMyDialog,
                          onComplete: (String message) {
                            userAlert.showMyDialog(
                              message,
                              title: "alertdialog/update-password/title",
                              actionTitle: "alertdialog/update-password/action",
                            );
                            actionLipStatusProvider.setActionLipStatus(
                              providerKey: ProviderKey.settings,
                            );
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
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
                        AppLocalizations.of(context)!.translate(
                          'action_lip/forgot-password/logged-in/button-submit',
                        ),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          actionLipStatus: ActionLipStatus.ONVIEWPORT,
          actionLipTitle: AppLocalizations.of(context)!
              .translate('action_lip/forgot-password/logged-in/label-title'),
        );
      }
    }

    return OutlinedButton(
      onPressed: forgotPWactionLip,
      style: OutlinedButton.styleFrom(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size(
          double.infinity,
          proportionateScreenHeight(48),
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
            ? AppLocalizations.of(context)!.translate(
                "settings_screen/system-settings/button-forgot-password",
              )
            : AppLocalizations.of(context)!.translate(
                'onboarding_screen/login-lip-forgot-password-button',
              ),
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
