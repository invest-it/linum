import 'package:flutter/material.dart';
import 'package:linum/common/widgets/elevated_gradient_button.dart';




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
    return ElevatedGradientButton(
      onPressed: callback,
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.tertiary,
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
