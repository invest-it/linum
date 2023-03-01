//  Logout Form - Widget that displays the current FirebaseAuth UserCredentials and provides Logout-Functionality
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/navigation/get_delegate.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
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

    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: sizeGuideProvider.proportionateScreenHeight(16),
          ),
          child: Text(
            tr('logout_form.label-current-email') + auth.userEmail,
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
        GradientButton(
          key: const Key("logoutButton"),
          increaseHeightBy: sizeGuideProvider.proportionateScreenHeight(16),
          callback: () => auth.signOut().then((_) {
            getRouterDelegate().rebuild();
            Provider.of<PinCodeProvider>(context, listen: false)
                .resetOnLogout();
          }),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color(0xFFC1E695),
            ],
          ),
          elevation: 0,
          increaseWidthBy: double.infinity,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Text(
            tr('settings_screen.system-settings.button-signout'),
            style: Theme.of(context).textTheme.button,
          ),
        ),
        SizedBox(
          height: sizeGuideProvider.proportionateScreenHeight(8),
        ),
      ],
    );
  }
}
