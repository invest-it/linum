//  Home Screen - The Home Screen of the App containing Statistical Info in the HomeScreenCard as well as a list of transactions in a specified month.
//
//  Author: SoTBurst, thebluebaronx, NightmindOfficial
//  Co-Author: damattl
/// PAGE INDEX 0

import 'package:flutter/material.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

/// Page Index: 0
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    final PinCodeProvider pinCodeProvider =
        Provider.of<PinCodeProvider>(context);

    // AlgorithmProvider algorithmProvider =
    //     Provider.of<AlgorithmProvider>(context, listen: false);

    // if (!algorithmProvider.currentFilter(
    //     {"time": Timestamp.fromDate(DateTime.now().add(Duration(days: 1)))})) {
    //   algorithmProvider.setCurrentFilterAlgorithm(
    //       AlgorithmProvider.olderThan(Timestamp.fromDate(DateTime.now())));
    // }

    return ScreenSkeleton(
      head: 'Home',
      isInverted: true,
      hasHomeScreenCard: true,
      leadingAction: AppBarAction.fromPreset(DefaultAction.academy),
      actions: [
        if (pinCodeProvider.pinActive)
          (BuildContext context) => AppBarAction.fromParameters(
                icon: Icons.lock_rounded,
                ontap: () {
                  pinCodeProvider.resetSession();
                },
                key: const Key("pinRecallButton"),
              ),
        AppBarAction.fromPreset(DefaultAction.settings),
      ],
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 25, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          'home_screen/label-recent-transactions',
                        ),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        screenIndexProvider.setPageIndex(1);
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('home_screen/button-show-more'),
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: ScrollConfiguration(
                    behavior: SilentScroll(),
                    child: balanceDataProvider.fillListViewWithData(
                      HomeScreenListView(),
                      context: context,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
