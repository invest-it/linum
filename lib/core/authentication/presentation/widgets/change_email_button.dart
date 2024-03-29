//  Forgot Password - Button that provides functionalities to reset the user password
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/presentation/utils/show_change_email_action_lip.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/generated/translation_keys.g.dart';

class ChangeEmailButton extends StatelessWidget {
  final ScreenKey screenKey;

  const ChangeEmailButton(this.screenKey);


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: const Key("changeEmailButton"),
      onPressed: () => showChangeEmailActionLip(context, screenKey),
      style: OutlinedButton.styleFrom(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size(
          double.infinity,
          context.proportionateScreenHeight(48),
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
      child: Text(
        tr(translationKeys.settingsScreen.systemSettings.buttonChangeEmail),
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
