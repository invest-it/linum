//  Lock Screen - PIN Lock Screen that prevents unauthorized access to sensitive user data if activated by the user
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst, damattl

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/lock_screen/models/lock_screen_action.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:linum/screens/lock_screen/widgets/numeric_field.dart';
import 'package:linum/screens/lock_screen/widgets/pin_field.dart';
import 'package:provider/provider.dart';

/// Page Index: 5
class LockScreen extends StatefulWidget {
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  List<NumericField> _generateNumericFields(
    List<int> numbers,
    PinCodeService pinCodeProvider,
  ) {
    final fields = <NumericField>[];
    for (final number in numbers) {
      final field = NumericField(number, pinCodeProvider.addDigit);
      fields.add(field);
    }
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    final PinCodeService pinCodeService =
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
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ..._generateNumericFields([1, 4, 7], pinCodeService),
                      //Backspace
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: Material(
                            child: IconButton(
                              key: const Key("pinlockBackspace"),
                              icon: Icon(
                                Icons.backspace_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: () {
                                pinCodeService.removeLastDigit();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children:
                        _generateNumericFields([2, 5, 8, 0], pinCodeService),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ..._generateNumericFields([3, 6, 9], pinCodeService),
                      // If Fingerprint is enabled, trigger dialog here
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: const Material(
                            child: IconButton(
                              icon: Icon(Icons.fingerprint_rounded),
                              onPressed: null,
                              // Alternatively, we could display a toast here. Uncomment this if simply disabling the button displeases too many people in the dev team.
                              // onPressed: () {
                              // Fluttertoast.showToast(
                              //     msg: AppLocalizations.of(context)!.translate(
                              //         'home_screen_card/home-screen-card-toast'),
                              //     toastLength: Toast.LENGTH_SHORT);
                              // },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
