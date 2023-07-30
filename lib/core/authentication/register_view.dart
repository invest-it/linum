//  Register Screen - A specialized ActionLip specifically designed to accommodate the RegisterForm on the OnboardingScreen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flutter/material.dart';
import 'package:linum/common/utils/execute.dart';
import 'package:linum/core/authentication/widgets/register_form/register_form.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {

  // double windowWidth = realScreenWidth();
  // double windowHeight = realScreenHeight();
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingScreenViewModel = context.watch<OnboardingScreenViewModel>();
    final pageState = onboardingScreenViewModel.pageState;

    return GestureDetector(
      onTap: () {
        onboardingScreenViewModel.setPageState(OnboardingPageState.register);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 800),
        transform: Matrix4.translationValues(0, _yOffset(context, pageState), 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
              blurRadius: 16,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // CONTENTS OF REGISTER HERE
                RegisterForm(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _yOffset(BuildContext context, OnboardingPageState pageState) {
    switch (pageState) {
      case OnboardingPageState.none:
        return useScreenHeight(context);
      case OnboardingPageState.login:
        return useScreenHeight(context);
      case OnboardingPageState.register:
        return calculate(() {
          final screenHeight = context.proportionateScreenHeightFraction(
            ScreenFraction.twofifths,
          );
          if (context.isKeyboardOpen()) {
            return screenHeight - (useKeyBoardHeight(context) / 2);
          }
          return screenHeight;
        });
    }
  }
}
