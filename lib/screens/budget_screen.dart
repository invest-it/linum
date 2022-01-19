import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/silent-scroll.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_listview.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    if (algorithmProvider.currentFilter != AlgorithmProvider.noFilter) {
      algorithmProvider.setCurrentFilterAlgorithm(AlgorithmProvider.noFilter);
    }
    return ScreenSkeleton(
      head: 'Budget',
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                    AppLocalizations.of(context)!
                        .translate('budget_screen/label-all-transactions'),
                    style: Theme.of(context).textTheme.headline5),
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
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
      isInverted: false,
    );
  }
}
