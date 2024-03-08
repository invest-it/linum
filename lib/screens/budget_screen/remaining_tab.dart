import 'package:flutter/material.dart';
import 'package:linum/screens/budget_screen/budget_screen_tab.dart';
import 'package:linum/screens/budget_screen/widgets/category_budget_chart.dart';
import 'package:linum/screens/budget_screen/widgets/main_budget_chart_slide.dart';

class RemainingTab extends StatelessWidget {
  const RemainingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetScreenTab(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: MainBudgetChartSlide(),
          ),
          CategoryBudgetChart(
              color: Colors.amber,
              label: "Lifestyle",
              expenses: 45.02,
              budget: 90,
          ),
          CategoryBudgetChart(
            color: Colors.indigoAccent,
            label: "Food & Drinks",
            expenses: 120.03,
            budget: 300,
          ),
        ],
      ),
    );
  }
}
