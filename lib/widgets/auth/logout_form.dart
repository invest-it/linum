import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';

class LogoutForm extends StatefulWidget {
  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);

    return Column(
      children: [
        GradientButton(
          increaseHeightBy: proportionateScreenHeight(16),
          child: Text(
            AppLocalizations.of(context)!
                .translate('settings_screen/system-settings/button-signout'),
            style: Theme.of(context).textTheme.button,
          ),
          callback: () => {
            setState(
              () {
                auth.signOut();
              },
            )
          },
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              createMaterialColor(Color(0xFFC1E695)),
            ],
          ),
          elevation: 0,
          increaseWidthBy: double.infinity,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        SizedBox(
          height: proportionateScreenHeight(8),
        ),
        OutlinedButton(
          //TODO implement this functionality
          onPressed: null,
          child: Text(
            AppLocalizations.of(context)!.translate(
                'onboarding_screen/login-lip-forgot-password-button'),
            style: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          style: OutlinedButton.styleFrom(
            elevation: 8,
            shadowColor: Theme.of(context).colorScheme.onBackground,
            minimumSize: Size(
              double.infinity,
              proportionateScreenHeight(64),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            side: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
