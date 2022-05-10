import 'package:flutter/material.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/login_form.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _loginWidth = 0;

  double _loginOpacity = 1;
  double windowWidth = realScreenWidth();
  double windowHeight = realScreenHeight();

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(
      context,
    );

    switch (onboardingScreenProvider.pageState) {
      case OnboardingPageState.none:
        _loginYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case OnboardingPageState.login:
        _loginYOffset = SizeGuide.keyboardIsOpened
            ? proportionateScreenHeightFraction(ScreenFraction.twofifths) -
                (SizeGuide.keyboardHeight / 2)
            : proportionateScreenHeightFraction(ScreenFraction.twofifths);

        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case OnboardingPageState.register:
        _loginYOffset = SizeGuide.keyboardIsOpened
            ? proportionateScreenHeightFraction(ScreenFraction.twofifths) -
                (SizeGuide.keyboardHeight / 2) -
                32
            : proportionateScreenHeightFraction(ScreenFraction.twofifths) - 32;
        _loginXOffset = 20;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.80;
    }

    return GestureDetector(
      onTap: () {
        onboardingScreenProvider.setPageState(OnboardingPageState.login);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AnimatedContainer(
        width: _loginWidth,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1200),
        transform: Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .background
              .withOpacity(_loginOpacity),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(
                    onboardingScreenProvider.pageState ==
                            OnboardingPageState.none
                        ? 0
                        : 135,
                  ),
              blurRadius: 16,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedSize(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 800),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: onboardingScreenProvider.pageState ==
                              OnboardingPageState.register
                          ? const Radius.circular(32)
                          : Radius.zero,
                      topRight: onboardingScreenProvider.pageState ==
                              OnboardingPageState.register
                          ? const Radius.circular(32)
                          : Radius.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: onboardingScreenProvider.pageState ==
                              OnboardingPageState.register
                          ? 32 * 1.2
                          : 0,
                      color: Theme.of(context).colorScheme.primary,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                'onboarding_screen/cta-login',
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //CONTENTS OF LOGIN HERE
                LoginForm(),
              ],
            ),
            Positioned(
              left: 0,
              bottom: SizeGuide.keyboardIsOpened
                  ? 0
                  : proportionateScreenHeightFraction(
                      ScreenFraction.twofifths,
                    ),
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: GestureDetector(
                  onTap: () {
                    onboardingScreenProvider
                        .setPageState(OnboardingPageState.register);
                  },
                  child: Container(
                    width: double.infinity,
                    height: proportionateScreenHeight(42),
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.translate(
                              'onboarding_screen/cta-register',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
