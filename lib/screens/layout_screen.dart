import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/screens/academy_screen.dart';
import 'package:linum/screens/lock_screen.dart';
import 'package:linum/screens/statistics_screen.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/screens/budget_screen.dart';
import 'package:linum/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  LayoutScreen(Key? key) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance?.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   PinCodeProvider pinCodeProvider =
  //       Provider.of<PinCodeProvider>(context, listen: false);
  //   super.didChangeAppLifecycleState(state);

  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.detached) {
  //     return;
  //   }

  //   final isBackground = state == AppLifecycleState.paused;

  //   if (isBackground) {
  //     pinCodeProvider.resetSession();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    PinCodeProvider pinCodeProvider = Provider.of<PinCodeProvider>(context);

    CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    //list with all the "screens"
    List<Widget> _page = <Widget>[
      HomeScreen(), //0
      BudgetScreen(), //1
      StatisticsScreen(), //2
      SettingsScreen(), //3
      AcademyScreen(), //4
      LockScreen(), //5
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            //returns the page at the current index, or at the lock screen index if a) the PIN lock is active AND b) there is a code for the email used for login stored in sharedPreferences AND c) the pin code has not been recalled before

            dev.log(pinCodeProvider.sessionIsSafe
                ? "Session: SAFE"
                : "Session: NOT SAFE");
            if (pinCodeProvider.pinActive && !pinCodeProvider.sessionIsSafe) {
              dev.log("PIN ACTIVE for " +
                  pinCodeProvider.lastEmail +
                  ", triggering recall");
              pinCodeProvider.triggerPINRecall();
            } else {
              dev.log(
                  "Checked if I should trigger a PIN recall, but either it is not active for " +
                      pinCodeProvider.lastEmail +
                      " or the session is safe.");
            }
            return _page.elementAt(screenIndexProvider.pageIndex);
          },
        ),
      ),
      //floatingactionbutton with bottomnavbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (screenIndexProvider.pageIndex == 5 ||
              (pinCodeProvider.pinActive &&
                  !pinCodeProvider
                      .sessionIsSafe)) //Check if the PIN lock is active
          ? null
          : FloatingActionButton(
              onPressed: () {
                BalanceDataProvider balanceDataProvider =
                    Provider.of<BalanceDataProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (innerContext) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<EnterScreenProvider>(
                          create: (_) {
                            return EnterScreenProvider(
                              category: _accountSettingsProvider
                                      .settings['StandardCategoryExpense'] ??
                                  "None",
                              secondaryCategory: _accountSettingsProvider
                                      .settings['StandardCategoryIncome'] ??
                                  "None",
                            );
                          },
                        ),
                        ChangeNotifierProvider<BalanceDataProvider>(
                          create: (_) {
                            return balanceDataProvider..dontDisposeOneTime();
                          },
                        ),
                        ChangeNotifierProvider<AccountSettingsProvider>(
                          create: (_) {
                            return _accountSettingsProvider
                              ..dontDisposeOneTime();
                          },
                        ),
                      ],
                      child: EnterScreen(),
                    );
                    // ChangeNotifierProvider.value(
                    // value: enterScreenProvider, child: EnterScreen());
                  }
                      //=> EnterScreen()),
                      ),
                );
              },
              child: Icon(Icons.add),
              elevation: 2.0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    iconData: Icons.savings_rounded, text: 'Budget'),
                BottomAppBarItem(
                    iconData: Icons.bar_chart_rounded, text: 'Stats'),
                BottomAppBarItem(iconData: Icons.person, text: 'Account'),
              ],
              backgroundColor: Theme.of(context).colorScheme.primary,
              centerItemText: '',
              color: Theme.of(context).colorScheme.background,
              selectedColor: Theme.of(context).colorScheme.secondary,
              notchedShape: CircularNotchedRectangle(),
              //gives the pageIndex the value (the current selected index in the
              //bottom navigation bar)
              onTabSelected: (int value) {
                screenIndexProvider.setPageIndex(value);
              },
            ),
    );
  }

  void createRandomData(BuildContext context) async {
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context, listen: false);
    const List<String> categories = ["food", "clothing", "computer games"];
    Random rand = Random();
    for (int i = 0; i < 365 * 5 * 4; i++) {
      Timestamp time = Timestamp.fromDate(
          DateTime.now().subtract(Duration(days: rand.nextInt(365 * 5))));
      balanceDataProvider.addSingleBalance(
        amount: ((rand.nextDouble() * -10000).round()) / 100.0,
        category: categories[rand.nextInt(categories.length)],
        currency: "EUR",
        name: "Random Item Number: " + i.toString(),
        time: time,
      );
      dev.log(i.toString() + ". Hochgeladen");
      await Future.delayed(Duration(milliseconds: 200));
    }
  }
}
