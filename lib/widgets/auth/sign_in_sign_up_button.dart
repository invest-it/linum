import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

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
      increaseHeightBy: context.proportionateScreenHeight(16),
      callback: callback,
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          const Color(0xFFC1E695),
        ],
      ),
      elevation: 0,
      increaseWidthBy: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
