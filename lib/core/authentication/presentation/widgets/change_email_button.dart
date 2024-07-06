//  Forgot Password - Button that provides functionalities to reset the user password
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/presentation/utils/show_change_email_action_lip.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/generated/translation_keys.g.dart';

class ChangeEmailButton extends StatelessWidget {
  final ScreenKey screenKey;

  const ChangeEmailButton(this.screenKey);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      key: const Key("changeEmailButton"),
      onPressed: () => showChangeEmailBottomSheet(context, screenKey),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: theme.colorScheme.primary,
        ),
      ),
      child: Text(
        tr(translationKeys.settingsScreen.systemSettings.buttonChangeEmail),
        style: theme.textTheme.labelMedium
            ?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }
}
