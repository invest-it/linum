//  Login Screen - A specialized ActionLip specifically designed to accommodate the LoginForm on the OnboardingScreen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//


// TODO DEPRECATED

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/widgets/login_form.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _loginWidth = 0;

  double _loginOpacity = 1;
  // double windowWidth = realScreenWidth();
  // double windowHeight = realScreenHeight();

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenViewModel onboardingScreenProvider =
        Provider.of<OnboardingScreenViewModel>(
      context,
    );

    switch (onboardingScreenProvider.pageState) {
      case OnboardingPageState.none:
        _loginYOffset = useScreenWidth(context);
        _loginXOffset = 0;
        _loginWidth = useScreenHeight(context);
        _loginOpacity = 1;
      case OnboardingPageState.login:
        _loginYOffset = context.isKeyboardOpen()
            ? context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ) -
                (useKeyBoardHeight(context) / 2)
            : context
                .proportionateScreenHeightFraction(ScreenFraction.twofifths);

        _loginXOffset = 0;
        _loginWidth = useScreenWidth(context);
        _loginOpacity = 1;
      case OnboardingPageState.register:
        _loginYOffset = context.isKeyboardOpen()
            ? context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ) -
                (useKeyBoardHeight(context) / 2) -
                32
            : context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ) -
                32;
        _loginXOffset = 20;
        _loginWidth = useScreenWidth(context) - 40;
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
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 10000),
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
                              tr('onboarding_screen.cta-login'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
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
              bottom: context.isKeyboardOpen()
                  ? 0
                  : context.proportionateScreenHeightFraction(
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
                    height: context.proportionateScreenHeight(42),
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            tr('onboarding_screen.cta-register'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
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
