//  Lock Screen - PIN Lock Screen that prevents unauthorized access to sensitive user data if activated by the user
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst, damattl
/// PAGE INDEX 5

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/lock_screen_action.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/lock_screen/numeric_field.dart';
import 'package:linum/widgets/lock_screen/pin_field.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

/// Page Index: 5
class LockScreen extends StatefulWidget {
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  List<NumericField> _generateNumericFields(
    List<int> numbers,
    PinCodeProvider pinCodeProvider,
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
    final AuthenticationService auth =
        Provider.of<AuthenticationService>(context);
    final PinCodeProvider pinCodeProvider =
        Provider.of<PinCodeProvider>(context);
    //final ScreenIndexProvider sip = Provider.of<ScreenIndexProvider>(context);
    final LockScreenAction screenIntent = pinCodeProvider.recallPINLockIntent();

    final sizeGuideProvider = Provider.of<SizeGuideProvider>(context);

    //TODO check if we need this or not
    // ignore: unused_local_variable
    final void Function(int) addDigit = pinCodeProvider.addDigit;

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
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 4.0,
                    bottom: sizeGuideProvider.proportionateScreenHeightFraction(
                      ScreenFraction.quantile,
                    ),
                  ),
                  child: Text(
                    auth.userEmail.isNotEmpty
                        ? auth.userEmail
                        : pinCodeProvider.lastEmail,
                    style: Theme.of(context).textTheme.headline5,
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
                PinField(1, pinCodeProvider.pinSlot, pinCodeProvider.ringColor),
                PinField(2, pinCodeProvider.pinSlot, pinCodeProvider.ringColor),
                PinField(3, pinCodeProvider.pinSlot, pinCodeProvider.ringColor),
                PinField(4, pinCodeProvider.pinSlot, pinCodeProvider.ringColor),
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
                      ..._generateNumericFields([1, 4, 7], pinCodeProvider),
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
                                pinCodeProvider.removeLastDigit();
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
                        _generateNumericFields([2, 5, 8, 0], pinCodeProvider),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ..._generateNumericFields([3, 6, 9], pinCodeProvider),
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
