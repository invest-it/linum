//  Lock Screen - PIN Lock Screen that prevents unauthorized access to sensitive user data if activated by the user
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst, damattl

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/lock_screen/models/lock_screen_action.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:linum/screens/lock_screen/widgets/peripherals_field.dart';
import 'package:linum/screens/lock_screen/widgets/pin_field.dart';
import 'package:provider/provider.dart';

/// Page Index: 5
class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pinCodeService =
        context.watch<PinCodeService>();
    //final ScreenIndexProvider sip = context.watch<ScreenIndexProvider>();
    final LockScreenAction screenIntent = pinCodeService.recallPINLockIntent(context);

    return ScreenSkeleton(
      head: 'Linum',
      body: Column(
        children: [
          /// WELCOME TEXT
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  tr(screenIntent.screenTitle),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 4.0,
                    bottom: context.proportionateScreenHeightFraction(
                      ScreenFraction.quantile,
                    ),
                  ),
                  child: Consumer<AuthenticationService>(
                    builder: (context, authService, _) {
                      return Text(
                        authService.userEmail.isNotEmpty
                            ? authService.userEmail
                            : pinCodeService.lastEmail,
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// PIN FIELD
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PinField(1, pinCodeService.pinSlot, pinCodeService.ringColor),
                PinField(2, pinCodeService.pinSlot, pinCodeService.ringColor),
                PinField(3, pinCodeService.pinSlot, pinCodeService.ringColor),
                PinField(4, pinCodeService.pinSlot, pinCodeService.ringColor),
              ],
            ),
          ),

          /// PERIPHERALS FIELD
          const PeripheralsField(),

          /// Action Switch
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
              ),
              child: TextButton(
                key: const Key("pinActionSwitch"),
                child: Text(tr(screenIntent.actionTitle)),
                onPressed: () {
                  // ignore: avoid_dynamic_calls
                  screenIntent.function();
                },
              ),
            ),
          ),
        ],
      ),
      isInverted: true,
    );
  }
}
