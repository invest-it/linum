import 'package:flutter/material.dart';
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
        body: Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: balanceDataProvider.fillListViewWithData(
              HomeScreenListView(),
              context: context,
            ),
          ),
        ),
        isInverted: false);
  }
}
