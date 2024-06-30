import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/widgets/elevated_gradient_button.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class OnboardingRegisterButton extends StatelessWidget {
  const OnboardingRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingScreenViewModel>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedGradientButton(
          onPressed: () => viewModel
              .setPageState(OnboardingPageState.register),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
          child: Text(
            tr(translationKeys.onboardingScreen.registerButton),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}
