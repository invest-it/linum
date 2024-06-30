import 'package:flutter/material.dart';
import 'package:linum/common/widgets/gradient_button.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';


class SignInSignUpButton extends StatelessWidget {
  final Function() callback;
  final String text;
  const SignInSignUpButton({
    super.key,
    required this.text,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      onPressed: callback,
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.tertiary,
        ],
      ),
      minimumSize: Size(
        double.infinity,
        context.proportionateScreenHeight(48),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
