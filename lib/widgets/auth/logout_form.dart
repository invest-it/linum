import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/materialcolor_creator.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:provider/provider.dart';

class LogoutForm extends StatefulWidget {
  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  @override
  Widget build(BuildContext context) {
    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: proportionateScreenHeight(16),
          ),
          child: Text(
            AppLocalizations.of(context)!
                    .translate('logout_form/label-current-email') +
                auth.userEmail,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
        GradientButton(
          key: const Key("logoutButton"),
          increaseHeightBy: proportionateScreenHeight(16),
          callback: () => auth.signOut().then((_) {
            Provider.of<ScreenIndexProvider>(context, listen: false)
                .setPageIndex(0);
            Provider.of<PinCodeProvider>(context, listen: false).resetSession();
          }),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              createMaterialColor(const Color(0xFFC1E695)),
            ],
          ),
          elevation: 0,
          increaseWidthBy: double.infinity,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Text(
            AppLocalizations.of(context)!
                .translate('settings_screen/system-settings/button-signout'),
            style: Theme.of(context).textTheme.button,
          ),
        ),
        SizedBox(
          height: proportionateScreenHeight(8),
        ),
      ],
    );
  }
}
