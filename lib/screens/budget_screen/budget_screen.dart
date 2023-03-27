//  Budget Screen - Screen listing all Balances ever made without any filtering (future entries not recognized)
//  NOTE: THE SCOPE OF THIS SCREEN IS GOING TO CHANGE SOON. //TODO @thebluebaronx pleas change this description once the change has been fulfilled.
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
/// PAGE INDEX 1

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/filters.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/home_screen/widgets/home_screen_listview.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

/// Page Index: 1
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AlgorithmService algorithmService =
        context.watch<AlgorithmService>();

    if (algorithmService.state.filter != Filters.noFilter) {
      algorithmService.setCurrentFilterAlgorithm(Filters.noFilter);
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
                  tr('budget_screen.label-all-transactions'),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    tr('budget_screen.button-filter').toUpperCase(),
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
                child: const HomeScreenListView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
