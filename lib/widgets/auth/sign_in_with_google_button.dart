import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(
          double.infinity,
          proportionateScreenHeight(40),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          width: 1.5,
          color: Theme.of(context).colorScheme.secondary.withAlpha(64),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("assets/images/btn_google.png"),
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                AppLocalizations.of(context)!
                    .translate('onboarding_screen/google-button'),
                style: Theme.of(context).textTheme.button?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                      letterSpacing: -0.41,
                      fontFamily: 'Roboto',
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
