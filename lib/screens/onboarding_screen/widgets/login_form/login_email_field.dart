import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginEmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool validated;

  const LoginEmailField({
    super.key,
    required this.controller,
    required this.validated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: TextField(
        key: const Key("loginEmailField"),
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:
          tr(translationKeys.onboardingScreen.loginEmailHintlabel),
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
          errorText: _errorText(validated),
        ),
        onTap: () {
          final viewModel = context.read<OnboardingScreenViewModel>();
          viewModel.setPageState(OnboardingPageState.login);
        },
      ),
    );
  }

  String? _errorText(bool validated) {
    if (validated) {
      return tr(translationKeys.onboardingScreen.loginEmailErrorlabel);
    }
    return null;
  }
}
