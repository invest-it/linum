//  Login Screen - A specialized ActionLip specifically designed to accommodate the LoginForm on the OnboardingScreen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/login_cta_button.dart';
import 'package:linum/screens/onboarding_screen/widgets/login_form/login_form.dart';
import 'package:linum/screens/onboarding_screen/widgets/register_cta_button.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  // double windowWidth = realScreenWidth();
  // double windowHeight = realScreenHeight();
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingScreenViewModel = context.watch<OnboardingScreenViewModel>();
    final pageState = onboardingScreenViewModel.pageState;

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        onboardingScreenViewModel.setPageState(OnboardingPageState.login);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AnimatedContainer(
        width: _width(context, pageState),
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 1200),
        transform: Matrix4.translationValues(
            _xOffset(pageState),
            _yOffset(context, pageState),
            1,
        ),
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 10000),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface
              .withOpacity(_opacity(pageState)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: _boxShadowColor(context, pageState),
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
                  child: LoginCtaButton(pageState: pageState),
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
              child: const RegisterCtaButton(),
            ),
          ],
        ),
      ),
    );
  }

  Color _boxShadowColor(BuildContext context, OnboardingPageState pageState) {
    final baseColor = Theme.of(context).colorScheme.onSurface;

    if (pageState.isNone()) {
      return baseColor.withAlpha(0);
    }
    return baseColor.withAlpha(135);
  }

  double _width(BuildContext context, OnboardingPageState pageState) {
    switch (pageState) {
      case OnboardingPageState.none:
        return useScreenHeight(context);
      case OnboardingPageState.login:
        return useScreenWidth(context);
      case OnboardingPageState.register:
        return useScreenWidth(context) - 40;
    }
  }

  double _opacity(OnboardingPageState pageState) {
    switch (pageState) {
      case OnboardingPageState.none:
        return 1;
      case OnboardingPageState.login:
        return 1;
      case OnboardingPageState.register:
        return 0.80;
    }
  }
  
  double _xOffset(OnboardingPageState pageState) {
    switch (pageState) {
      case OnboardingPageState.none:
        return 0;
      case OnboardingPageState.login:
        return 0;
      case OnboardingPageState.register:
        return 20;
    }
  }
  
  double _yOffset(BuildContext context, OnboardingPageState pageState) {
    double yOffset = 0;
    switch (pageState) {
      case OnboardingPageState.none:
        yOffset = useScreenHeight(context);
      case OnboardingPageState.login:
        yOffset = _loginYOffset(context);
      case OnboardingPageState.register:
        yOffset = _registerYOffset(context);
    }
    return yOffset;
  }
  
  double _loginYOffset(BuildContext context) {
    if (context.isKeyboardOpen()) {
      final screenHeight = context.proportionateScreenHeightFraction(
        ScreenFraction.twofifths,
      );
      return screenHeight - (useKeyBoardHeight(context) / 2);
    }
    return context.proportionateScreenHeightFraction(ScreenFraction.twofifths);
  }
  
  double _registerYOffset(BuildContext context) {
    return _loginYOffset(context) - 32;
  }
}
