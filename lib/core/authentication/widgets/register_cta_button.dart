import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class RegisterCtaButton extends StatelessWidget {
  const RegisterCtaButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = theme.textTheme.bodyLarge
        ?.copyWith(color: theme.colorScheme.onPrimary);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: GestureDetector(
        onTap: () {
          final viewModel = context.read<OnboardingScreenViewModel>();
          viewModel.setPageState(OnboardingPageState.register);
        },
        child: Container(
          width: double.infinity,
          height: context.proportionateScreenHeight(42),
          color: theme.colorScheme.primary,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  tr(translationKeys.onboardingScreen.ctaRegister),
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
