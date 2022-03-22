import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/silent_scroll.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

import 'package:provider/provider.dart';

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
