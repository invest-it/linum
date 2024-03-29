import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/bottom_app_bar.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/core/navigation/screen_routes.dart';
import 'package:linum/screens/enter_screen/presentation/utils/show_enter_screen.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// The Layout for every main screen in Linum.
/// The app bar and floating action button are defined here.
class ScreenLayout extends StatefulWidget {
  final ScreenKey currentScreen;
  final dynamic settings;
  const ScreenLayout({super.key, required this.currentScreen, this.settings});

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
    final PinCodeService pinCodeProvider =
        context.read<PinCodeService>();
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
    final CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');

    final routerDelegate = context.getMainRouterDelegate();


    // ignore: unused_local_variable
    final Widget loadingIndicator = Container(
      color: Colors.grey[300],
      width: context.proportionateScreenWidth(70.0),
      height: context.proportionateScreenWidth(70.0),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );


    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            // returns the page at the current index, or at the lock screen index if a) the PIN lock is active AND b) there is a code for the email used for login stored in sharedPreferences AND c) the pin code has not been recalled before
            return screenRoutes[widget.currentScreen]!;
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showEnterScreen(context);
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
            selected: widget.currentScreen == ScreenKey.home,
            onTap: () => routerDelegate.replaceLastRoute(MainRoute.home),
          ),
          BottomAppBarItem(
            iconData: Icons.savings_rounded,
            text: 'Budget',
            selected: widget.currentScreen == ScreenKey.budget,
            onTap: () => routerDelegate.replaceLastRoute(MainRoute.budget),
          ),
          BottomAppBarItem(
            iconData: Icons.bar_chart_rounded,
            text: 'Stats',
            selected: widget.currentScreen == ScreenKey.stats,
            onTap: () => routerDelegate.replaceLastRoute(MainRoute.stats),
          ),
          BottomAppBarItem(
            iconData: Icons.person,
            text: 'Account',
            selected: widget.currentScreen == ScreenKey.settings,
            onTap: () => routerDelegate.replaceLastRoute(MainRoute.settings),
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
}
