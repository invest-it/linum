import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class OnboardingLoginButton extends StatelessWidget {
  const OnboardingLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingScreenViewModel>();
    return CupertinoButton(
      child: Text(
        tr(translationKeys.onboardingScreen.loginButton),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onPressed: () => {
        viewModel.setPageState(OnboardingPageState.login),
      },
    );
  }
}
