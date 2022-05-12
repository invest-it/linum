import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback callback;
  const RegisterButton({Key? key, required this.callback}) : super(key: key);

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
        AppLocalizations.of(context)!.translate(
          'onboarding_screen/register-lip-signup-button',
        ),
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
