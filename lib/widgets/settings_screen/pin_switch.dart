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
          value: pinCodeProvider.pinActive,
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          onChanged: pinCodeProvider.pinActiveStillLoading
              ? null
              : (_) {
                  pinCodeProvider.togglePINLock();
                },
        ),
        if (pinCodeProvider.pinActive)
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
