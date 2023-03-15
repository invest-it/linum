//  Layout Screen - Basic Screen Switcher
//  NOTE: THIS SCREEN IS GOING TO BE REPLACED BY A NEW NAVIGATION SYSTEM SOON. //TODO @NightmindOfficial change this description once this has been performed.
//  Author: thebluebaronx
//  Co-Author: SoTBurst, NightmindOfficial, damattl
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linum/enter_screen/enter_screen.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/navigation/main_router_delegate.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/screen_builders.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:linum/widgets/bottom_app_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ScreenLayout extends StatefulWidget {
  final MainRoute currentRoute;
  final dynamic settings;
  const ScreenLayout({super.key, required this.currentRoute, this.settings});

  @override
  State<ScreenLayout> createState() => _ScreenLayoutState();
}

class _ScreenLayoutState extends State<ScreenLayout>
    with WidgetsBindingObserver {
  late final Logger logger;
  _ScreenLayoutState() {
    logger = Logger();
  }

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
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    final firestore.CollectionReference balance =
        firestore.FirebaseFirestore.instance.collection('balance');


    // ignore: unused_local_variable
    final Widget loadingIndicator = Container(
      color: Colors.grey[300],
      width: context.proportionateScreenWidth(70.0),
      height: context.proportionateScreenWidth(70.0),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final router = Get.find<MainRouterDelegate>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
            //returns the page at the current index, or at the lock screen index if a) the PIN lock is active AND b) there is a code for the email used for login stored in sharedPreferences AND c) the pin code has not been recalled before
            return screens[
                widget.currentRoute]!; // TODO: Check if this can be kept
          },
        ),
      ),
      //floatingactionbutton with bottomnavbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const EnterScreen();
              },
          );




          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (innerContext) {
                final enterScreenProvider = ChangeNotifierProvider<EnterScreenProvider>(
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
                );
                return MultiProviderBuilder(context: context, child: const EnterScreen())
                    .useExistingProvider<BalanceDataProvider>()
                    .useExistingProvider<AccountSettingsProvider>()
                    .addProvider(enterScreenProvider)
                    .build();
                // ChangeNotifierProvider.value(
                // value: enterScreenProvider, child: EnterScreen());
              },
              //=> EnterScreen()),
            ),
          );
          */
        },
        elevation: 2.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: [
          BottomAppBarItem(
            iconData: Icons.home,
            text: 'Home',
            selected: widget.currentRoute == MainRoute.home,
            onTap: () => router.replaceLastRoute(MainRoute.home),
          ),
          BottomAppBarItem(
            iconData: Icons.savings_rounded,
            text: 'Budget',
            selected: widget.currentRoute == MainRoute.budget,
            onTap: () => router.replaceLastRoute(MainRoute.budget),
          ),
          BottomAppBarItem(
            iconData: Icons.bar_chart_rounded,
            text: 'Stats',
            selected: widget.currentRoute == MainRoute.statistics,
            onTap: () => router.replaceLastRoute(MainRoute.statistics),
          ),
          BottomAppBarItem(
            iconData: Icons.person,
            text: 'Account',
            selected: widget.currentRoute == MainRoute.settings,
            onTap: () => router.replaceLastRoute(MainRoute.settings),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerItemText: '',
        color: Theme.of(context).colorScheme.background,
        selectedColor: Theme.of(context).colorScheme.secondary,
        notchedShape: const CircularNotchedRectangle(),
        //gives the pageIndex the value (the current selected index in the
        //bottom navigation bar)
      ),
    );
  }

  Future<void> createRandomData(BuildContext context) async {
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context, listen: false);
    const List<String> categories = ["food", "clothing", "computer games"];
    final Random rand = Random();
    for (int i = 0; i < 365 * 5 * 4; i++) {
      final firestore.Timestamp time = firestore.Timestamp.fromDate(
        DateTime.now().subtract(Duration(days: rand.nextInt(365 * 5))),
      );
      balanceDataProvider.addTransaction(
        Transaction(
          amount: ((rand.nextDouble() * -10000).round()) / 100.0,
          category: categories[rand.nextInt(categories.length)],
          currency: "EUR",
          name: "Random Item Number: $i",
          time: time,
        ),
      );
      logger.v("$i. Hochgeladen");
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
// TODO: Refactor
