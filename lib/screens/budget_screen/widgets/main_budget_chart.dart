import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MainBudgetChart extends StatelessWidget {
  final double maxBudget;
  final double currentExpenses;
  const MainBudgetChart({super.key, required this.maxBudget, required this.currentExpenses});
  // TODO: add support for percentages
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SfRadialGauge(
      axes: [
        RadialAxis(
          maximum: maxBudget,
          showLabels: false,
          showTicks: false,

          ranges: [
            GaugeRange(
                startValue: 0,
                endValue: currentExpenses,
                color: theme.primaryColor,
            )
          ],
        )
      ],
    );
  }
}
