import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';

class LoginCtaButton extends StatelessWidget {
  final OnboardingPageState pageState;

  const LoginCtaButton({super.key, required this.pageState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final radius = pageState.isRegister()
        ? const Radius.circular(32)
        : Radius.zero;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: radius,
        topRight: radius,
      ),
      child: Container(
        width: double.infinity,
        height: _height(),
        color: theme.colorScheme.primary,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                tr(translationKeys.onboardingScreen.ctaLogin),
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _height() {
    if (pageState.isRegister()) {
      return 32 * 1.2;
    }
    return 0;
  }
}
