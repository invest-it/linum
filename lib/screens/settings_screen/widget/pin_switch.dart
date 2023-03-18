//  Settings Screen Pin Switch - The toggle to open and activate the Pin Code
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Partly Refactored: TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class PinSwitch extends StatelessWidget {
  const PinSwitch({
    super.key,
    required this.pinCodeProvider,
  });

  final PinCodeService pinCodeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          key: const Key("pinActivationSwitch"),
          title: Text(
            tr("settings_screen.pin-lock.switch-label"),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          value: pinCodeProvider.pinSet,
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          onChanged: pinCodeProvider.pinSetStillLoading
              ? null
              : (_) {
                  pinCodeProvider.togglePINLock();
                },
        ),
        if (pinCodeProvider.pinSet)
          ListTile(
            key: const Key("pinChangeSwitch"),
            dense: true,
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            title: Text(
              tr("settings_screen.pin-lock.label-change-pin"),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              pinCodeProvider.triggerPINChange();
            },
          ),
      ],
    );
  }
}
