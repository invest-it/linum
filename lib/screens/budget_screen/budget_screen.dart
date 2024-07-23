import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/filters.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/home_screen/widgets/home_screen_listview.dart';
import 'package:provider/provider.dart';

///  Budget Screen
///  Screen listing all Balances ever made without any filtering (future entries not recognized).
///  Page Index: 1
class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AlgorithmService algorithmService = context.watch<AlgorithmService>();

    if (algorithmService.state.filter != Filters.noFilter) {
      algorithmService.setCurrentFilterAlgorithm(Filters.noFilter);
    }
    return ScreenSkeleton(
      head: 'Budget',
      leadingAction: AppBarAction.fromPreset(DefaultAction.academy),
      actions: [
        AppBarAction.fromPreset(
          DefaultAction.bugreport,
        ),
      ],
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  tr(translationKeys.budgetScreen.labelAllTransactions),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    tr(translationKeys.budgetScreen.buttonFilter).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: ScrollConfiguration(
                behavior: SilentScroll(),
                child: HomeScreenListView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
