import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/url_handler.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/frontend_functions/user_alert.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/google_sign_in_btn.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _mailController = TextEditingController();
  final _passController = TextEditingController();

  bool _agbCheck = false;
  bool _agbNullCheck = false;
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
      _agbCheck = false;
      _agbNullCheck = false;
      _mailValidate = false;
      _passValidate = false;
    }

    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);
    final UserAlert userAlert = UserAlert(context: context);

    void signUp(String _mail, String _pass) {
      auth.signUp(
        _mail,
        _pass,
        onError: (String message) {
          setState(() {
            userAlert.showMyDialog(message);
            _passController.clear();
            _agbCheck = false;
            _agbNullCheck = false;
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
          _agbNullCheck = false;
          _agbCheck = false;
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
                          hintText: AppLocalizations.of(context)!.translate(
                            'onboarding_screen/register-email-hintlabel',
                          ),
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
              CheckboxListTile(
                // title: Text(
                //     'Ich habe die AGB und die Erklärung zum Datenschutz gelesen und akzeptiere sie.',
                //     style: Theme.of(context).textTheme.bodyText2?.copyWith(
                //         fontWeight: FontWeight.w600,
                //         color: Theme.of(context).colorScheme.onSurface)),
                title: RichText(
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
                ),
                value: _agbCheck,
                onChanged: (newVal) {
                  setState(() {
                    _agbCheck = newVal!;
                    newVal == true
                        ? _agbNullCheck = false
                        : _agbNullCheck = true;
                  });
                },
                controlAffinity: ListTileControlAffinity.trailing,
                checkColor: Theme.of(context).colorScheme.onPrimary,
                activeColor: Theme.of(context).colorScheme.primaryContainer,
                secondary: const Icon(Icons.verified_user_rounded),
                visualDensity: const VisualDensity(
                  horizontal: -4,
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
              Text(
                _agbNullCheck
                    ? AppLocalizations.of(context)!.translate(
                        "onboarding_screen/register-privacy/label-error",
                      )
                    : '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              GradientButton(
                increaseHeightBy: proportionateScreenHeight(16),
                callback: _agbCheck
                    ? () {
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
                      }
                    : () => setState(() {
                          _mailController.text.isEmpty
                              ? _mailValidate = true
                              : _mailValidate = false;
                          _passController.text.isEmpty
                              ? _passValidate = true
                              : _passValidate = false;
                          _agbNullCheck = true;
                        }),
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
                    'onboarding_screen/register-lip-signup-button',
                  ),
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              SizedBox(
                height: proportionateScreenHeight(8),
              ),
              // ignore: prefer_const_constructors
              GoogleSignInButton() // Won't reload on Language-Switch if const
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
