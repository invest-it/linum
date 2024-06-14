//  Logout Form - Widget that displays the current FirebaseAuth UserCredentials and provides Logout-Functionality
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:provider/provider.dart';


class LogoutForm extends StatefulWidget {
  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ],
    );
  }
}
