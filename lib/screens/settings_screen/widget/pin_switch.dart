//  Settings Screen Pin Switch - The toggle to open and activate the Pin Code
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Partly Refactored: TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';




class PinSwitch extends StatelessWidget {
  const PinSwitch({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final pinCodeService = context.watch<PinCodeService>();
    return Column(
      children: [
        SwitchListTile(
          key: const Key("pinActivationSwitch"),
          title: Text(
            tr(translationKeys.settingsScreen.pinLock.switchLabel),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          value: pinCodeService.pinSet,
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          onChanged: pinCodeService.pinSetStillLoading
              ? null
              : (_) {
                  pinCodeService.togglePINLock();
                },
        ),
        if (pinCodeService.pinSet)
          ListTile(
            key: const Key("pinChangeSwitch"),
            dense: true,
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            title: Text(
              tr(translationKeys.settingsScreen.pinLock.labelChangePin),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              pinCodeService.triggerPINChange();
            },
          ),
      ],
    );
  }
}
