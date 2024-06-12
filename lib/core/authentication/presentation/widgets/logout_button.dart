import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilledButton(
      key: const Key("logoutButton"),
      onPressed: () => context.read<AuthenticationService>()
          .signOut()
          .then((_) {
        context.getMainRouterDelegate().rebuild();
        context.read<PinCodeService>()
            .resetOnLogout();
      }),
      child: Text(
        tr(translationKeys.settingsScreen.systemSettings.buttonSignout),
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
