//  Register Screen - A specialized ActionLip specifically designed to accommodate the RegisterForm on the OnboardingScreen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flutter/material.dart';
import 'package:linum/constants/screen_fraction_enum.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:linum/utilities/frontend/media_query_accessors.dart';
import 'package:linum/widgets/auth/register_form.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double _registerYOffset = 0;
  // double windowWidth = realScreenWidth();
  // double windowHeight = realScreenHeight();

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(
      context,
    );

    switch (onboardingScreenProvider.pageState) {
      case OnboardingPageState.none:
        _registerYOffset = useScreenHeight(context);
        break;
      case OnboardingPageState.login:
        _registerYOffset = useScreenHeight(context);
        break;
      case OnboardingPageState.register:
        _registerYOffset = context.isKeyboardOpen()
            ? context.proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ) -
                (useKeyBoardHeight(context) / 2)
            : context
                .proportionateScreenHeightFraction(ScreenFraction.twofifths);
    }

    return GestureDetector(
      onTap: () {
        onboardingScreenProvider.setPageState(OnboardingPageState.register);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        duration: const Duration(milliseconds: 800),
        transform: Matrix4.translationValues(0, _registerYOffset, 0),
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
}
