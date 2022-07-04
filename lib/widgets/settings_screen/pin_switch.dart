//  Settings Screen Pin Switch - The toggle to open and activate the Pin Code
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  Partly Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';

class PinSwitch extends StatelessWidget {
  const PinSwitch({
    Key? key,
    required this.pinCodeProvider,
  }) : super(key: key);

  final PinCodeProvider pinCodeProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          key: const Key("pinActivationSwitch"),
          title: Text(
            AppLocalizations.of(context)!
                .translate("settings_screen/pin-lock/switch-label"),
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
              AppLocalizations.of(context)!.translate(
                "settings_screen/pin-lock/label-change-pin",
              ),
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
