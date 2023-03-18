//  Register Screen - A specialized ActionLip specifically designed to accommodate the RegisterForm on the OnboardingScreen.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:flutter/material.dart';
import 'package:linum/core/authentication/widgets/register_form.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  double _registerYOffset = 0;
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
