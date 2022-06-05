import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class SignInSignUpButton extends StatelessWidget {
  final Function() callback;
  final String text;
  const SignInSignUpButton({Key? key, required this.text, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      increaseHeightBy: proportionateScreenHeight(16),
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
