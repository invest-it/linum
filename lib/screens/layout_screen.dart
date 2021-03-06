//  Layout Screen - Basic Screen Switcher
//  NOTE: THIS SCREEN IS GOING TO BE REPLACED BY A NEW NAVIGATION SYSTEM SOON. //TODO @NightmindOfficial change this description once this has been performed.
//  Author: thebluebaronx
//  Co-Author: SoTBurst, NightmindOfficial
/// NO PAGE INDEX (This Screen is always invoked)

import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/screens.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen(Key? key) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final PinCodeProvider pinCodeProvider =
        Provider.of<PinCodeProvider>(context, listen: false);
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      pinCodeProvider.resetSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    final ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    final PinCodeProvider pinCodeProvider =
        Provider.of<PinCodeProvider>(context);

    final CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    // ignore: unused_local_variable
    final Widget loadingIndicator = Container(
      color: Colors.grey[300],
      width: proportionateScreenWidth(70.0),
      height: proportionateScreenWidth(70.0),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    return FutureBuilder(
      future: pinCodeProvider.initialIsPINActive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // dev.log(
          //   pinCodeProvider.sessionIsSafe
          //       ? "Session: SAFE"
          //       : "Session: NOT SAFE",
          // );
          if (pinCodeProvider.pinActive && !pinCodeProvider.sessionIsSafe) {
            // dev.log(
            //   "PIN ACTIVE for ${pinCodeProvider.lastEmail}, triggering recall",
            // );
            pinCodeProvider.triggerPINRecall();
          } else {
            // dev.log(
            //   "Checked if I should trigger a PIN recall, but either it is not active for ${pinCodeProvider.lastEmail} or the session is safe.",
            // );
          }
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: StreamBuilder(
              stream: balance.snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                //returns the page at the current index, or at the lock screen index if a) the PIN lock is active AND b) there is a code for the email used for login stored in sharedPreferences AND c) the pin code has not been recalled before
                return screens.elementAt(screenIndexProvider.pageIndex);
              },
            ),
          ),
          //floatingactionbutton with bottomnavbar
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (screenIndexProvider.pageIndex == 5 ||
                  (pinCodeProvider.pinActive &&
                      !pinCodeProvider
                          .sessionIsSafe)) //Check if the PIN lock is active
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    final BalanceDataProvider balanceDataProvider =
                        Provider.of<BalanceDataProvider>(
                      context,
                      listen: false,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (innerContext) {
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider<EnterScreenProvider>(
                                create: (_) {
                                  return EnterScreenProvider(
                                    category: _accountSettingsProvider.settings[
                                                'StandardCategoryExpense']
                                            as String? ??
                                        "None",
                                    secondaryCategory:
                                        _accountSettingsProvider.settings[
                                                    'StandardCategoryIncome']
                                                as String? ??
                                            "None",
                                  );
                                },
                              ),
                              ChangeNotifierProvider<BalanceDataProvider>(
                                create: (_) {
                                  return balanceDataProvider
                                    ..dontDisposeOneTime();
                                },
                              ),
                              ChangeNotifierProvider<AccountSettingsProvider>(
                                create: (_) {
                                  return _accountSettingsProvider
                                    ..dontDisposeOneTime();
                                },
                              ),
                            ],
                            child: const EnterScreen(),
                          );
                          // ChangeNotifierProvider.value(
                          // value: enterScreenProvider, child: EnterScreen());
                        },
                        //=> EnterScreen()),
                      ),
                    );
                  },
                  elevation: 2.0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.add),
                ),
          bottomNavigationBar: (screenIndexProvider.pageIndex == 5 ||
                  (pinCodeProvider.pinActive &&
                      !pinCodeProvider
                          .sessionIsSafe)) //Check if the PIN lock is active
              ? null
              : FABBottomAppBar(
                  items: [
                    BottomAppBarItem(iconData: Icons.home, text: 'Home'),
                    BottomAppBarItem(
                      iconData: Icons.savings_rounded,
                      text: 'Budget',
                    ),
                    BottomAppBarItem(
                      iconData: Icons.bar_chart_rounded,
                      text: 'Stats',
                    ),
                    BottomAppBarItem(iconData: Icons.person, text: 'Account'),
                  ],
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  centerItemText: '',
                  color: Theme.of(context).colorScheme.background,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  notchedShape: const CircularNotchedRectangle(),
                  //gives the pageIndex the value (the current selected index in the
                  //bottom navigation bar)
                  onTabSelected: (int value) {
                    screenIndexProvider.setPageIndex(value);
                  },
                ),
        );
      },
    );
  }

  Future<void> createRandomData(BuildContext context) async {
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context, listen: false);
    const List<String> categories = ["food", "clothing", "computer games"];
    final Random rand = Random();
    for (int i = 0; i < 365 * 5 * 4; i++) {
      final Timestamp time = Timestamp.fromDate(
        DateTime.now().subtract(Duration(days: rand.nextInt(365 * 5))),
      );
      balanceDataProvider.addSingleBalance(
        SingleBalanceData(
          amount: ((rand.nextDouble() * -10000).round()) / 100.0,
          category: categories[rand.nextInt(categories.length)],
          currency: "EUR",
          name: "Random Item Number: $i",
          time: time,
        ),
      );
      dev.log("$i. Hochgeladen");
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
// TODO: Refactor
