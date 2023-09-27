//  Logout Form - Widget that displays the current FirebaseAuth UserCredentials and provides Logout-Functionality
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';


class LogoutForm extends StatefulWidget {
  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.proportionateScreenHeight(16),
          ),
          child: Consumer<AuthenticationService>(
            builder: (context, authService, _) {
              return Text(
                tr(translationKeys.logoutForm.labelCurrentEmail) + authService.userEmail,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
        GradientButton(
          key: const Key("logoutButton"),
          increaseHeightBy: context.proportionateScreenHeight(16),
          callback: () => context.read<AuthenticationService>()
              .signOut()
              .then((_) {
                context.getMainRouterDelegate().rebuild();
                context.read<PinCodeService>()
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
            tr(translationKeys.settingsScreen.systemSettings.buttonSignout),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        SizedBox(
          height: context.proportionateScreenHeight(8),
        ),
      ],
    );
  }
}
