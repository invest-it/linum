import 'dart:developer' as dev;
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/screens/academy_screen.dart';
import 'package:linum/screens/budget_screen.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/screens/statistics_screen.dart';
import 'package:linum/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen(Key? key) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications()
            .requestPermissionToSendNotifications()
            .then((_) => Navigator.pop(context));
      }
    });
  }

  Widget build(BuildContext context) {
    final AccountSettingsProvider _accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    final ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    final CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    //list with all the "screens"
    final List<Widget> _page = <Widget>[
      const HomeScreen(),
      const BudgetScreen(),
      const StatisticsScreen(),
      const SettingsScreen(),
      const AcademyScreen(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            //returns the page at the current index
            return _page.elementAt(screenIndexProvider.pageIndex);
          },
        ),
      ),
      //floatingactionbutton with bottomnavbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final BalanceDataProvider balanceDataProvider =
              Provider.of<BalanceDataProvider>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (innerContext) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider<EnterScreenProvider>(
                      create: (_) {
                        return EnterScreenProvider(
                          category: _accountSettingsProvider
                                      .settings['StandardCategoryExpense']
                                  as String? ??
                              "None",
                          secondaryCategory: _accountSettingsProvider
                                      .settings['StandardCategoryIncome']
                                  as String? ??
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
                        return _accountSettingsProvider..dontDisposeOneTime();
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
      bottomNavigationBar: FABBottomAppBar(
        items: [
          BottomAppBarItem(iconData: Icons.home, text: 'Home'),
          BottomAppBarItem(iconData: Icons.savings_rounded, text: 'Budget'),
          BottomAppBarItem(iconData: Icons.bar_chart_rounded, text: 'Stats'),
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
        amount: ((rand.nextDouble() * -10000).round()) / 100.0,
        category: categories[rand.nextInt(categories.length)],
        currency: "EUR",
        name: "Random Item Number: $i",
        time: time,
      );
      dev.log("$i. Hochgeladen");
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
