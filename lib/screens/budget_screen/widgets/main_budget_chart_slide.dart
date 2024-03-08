import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:linum/screens/budget_screen/widgets/main_budget_chart.dart';
import 'package:provider/provider.dart';

class MainBudgetChartSlide extends StatelessWidget {
  const MainBudgetChartSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final algorithms = context.watch<AlgorithmService>();
    
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

    final viewModel = context.read<BudgetScreenViewModel>();

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                algorithms.previousMonth(notify: true);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
              ),
            ),
            Expanded(
              child: MainBudgetChart(
                  maxBudget: 1000,
                  currentExpenses: -viewModel.calculations.sumCosts.toDouble(),
              ),
            ),
            IconButton(
              onPressed: () {
                algorithms.nextMonth(notify: true);
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ),
        Text(dateFormat.format(algorithms.state.shownMonth)),
      ],
    );
  }
}
