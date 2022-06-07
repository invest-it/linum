//  Budget Screen - Screen listing all Balances ever made without any filtering (future entries not recognized)
//  NOTE: THE SCOPE OF THIS SCREEN IS GOING TO CHANGE SOON. //TODO @thebluebaronx pleas change this description once the change has been fulfilled.
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
/// PAGE INDEX 1

import 'package:flutter/material.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/filters.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

/// Page Index: 1
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    if (algorithmProvider.currentFilter != Filters.noFilter) {
      algorithmProvider.setCurrentFilterAlgorithmSilently(Filters.noFilter);
    }
    return ScreenSkeleton(
      head: 'Budget',
      leadingAction: AppBarAction.fromPreset(DefaultAction.academy),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('budget_screen/label-all-transactions'),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('budget_screen/button-filter'),
                    style: Theme.of(context).textTheme.overline?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            ],
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
    );
  }
}
