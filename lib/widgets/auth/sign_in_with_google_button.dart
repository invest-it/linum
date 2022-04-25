import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
                style: GoogleFonts.roboto(
                  fontSize: 44 * 0.43, // 14,
                  color: Colors.black54,
                  // fontWeight: FontWeight.w600,
                  letterSpacing: -0.41,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
