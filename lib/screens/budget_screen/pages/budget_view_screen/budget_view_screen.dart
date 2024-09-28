import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:linum/screens/budget_screen/pages/budget_view_screen/widgets/sub_budget_tile.dart';
import 'package:linum/screens/budget_screen/widgets/main_budget_chart.dart';
import 'package:provider/provider.dart';

class BudgetViewScreen extends StatelessWidget {
  const BudgetViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BudgetScreenViewModel>();
    final theme = Theme.of(context);
    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context
          .watch<ICurrencySettingsService>()
          .getStandardCurrency()
          .symbol,
    );

    return FutureBuilder(
      future: Future.wait([
        viewModel.getBudgetViewData(DateTime.now()),
        viewModel.getMainBudgetChartData(DateTime.now()),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              MainBudgetChart(
                data: (snapshot.requireData[1] as MainBudgetChartData),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.requireData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SubBudgetTile(
                      budgetData: (snapshot.requireData[0]
                          as List<BudgetViewData>)[index],
                    );
                  },
                ),
              )
            ],
          );
        }
        return const LoadingSpinner();
      },
    );
  }
}
