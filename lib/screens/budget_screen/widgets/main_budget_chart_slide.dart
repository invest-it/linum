import 'package:flutter/material.dart';
import 'package:linum/common/widgets/month_slide.dart';
import 'package:linum/screens/budget_screen/budget_screen_viewmodel.dart';
import 'package:linum/screens/budget_screen/widgets/main_budget_chart.dart';
import 'package:provider/provider.dart';

class MainBudgetChartSlide extends StatelessWidget {
  const MainBudgetChartSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<BudgetScreenViewModel>();

    return MonthSlide(
      child: MainBudgetChart(
        maxBudget: 1000,
        currentExpenses: -viewModel.calculations.sumCosts.toDouble(),
      ),
    );
  }
}
