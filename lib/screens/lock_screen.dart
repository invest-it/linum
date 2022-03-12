import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/widgets/lock_screen/numeric_field.dart';
import 'package:linum/widgets/lock_screen/pin_field.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

import '../backend_functions/local_app_localizations.dart';

/// Page Index: 5
class LockScreen extends StatefulWidget {
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    PinCodeProvider pinCodeProvider = Provider.of<PinCodeProvider>(context);

    return ScreenSkeleton(
      head: 'Linum',
      body: Column(
        children: [
          /// WELCOME TEXT
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bitte PIN eingeben',
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 4.0,
                      bottom: proportionateScreenHeightFraction(
                        ScreenFraction.QUANTILE,
                      )),
                  child: Text(
                    'mail@otismohr.de',
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
                PinField(1, pinCodeProvider.pinSlot),
                PinField(2, pinCodeProvider.pinSlot),
                PinField(3, pinCodeProvider.pinSlot),
                PinField(4, pinCodeProvider.pinSlot),
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
                      NumericField(1, () {}),
                      NumericField(4, () {}),
                      NumericField(7, () {}),
                      //Backspace
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: Material(
                            child: IconButton(
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
                    children: [
                      NumericField(2, () {}),
                      NumericField(5, () {}),
                      NumericField(8, () {}),
                      NumericField(0, () {}),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      NumericField(3, () {}),
                      NumericField(6, () {}),
                      NumericField(9, () {}),
                      // If Fingerprint is enabled, trigger dialog here
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity,
                          ),
                          child: Material(
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

          /// KILLSWITCH
          Expanded(
            flex: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
              ),
              child: TextButton(
                child: Text('Abmelden'),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      isInverted: true,
    );
  }
}
