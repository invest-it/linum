import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';

class CategoryStatistics<ID> {
  final ID categoryId;
  final EntryType type;
  final double amount;
  final Color color;
  final Color textColor;
  CategoryStatistics({
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.color,
    this.textColor = Colors.white,
  });
}


class CategoryStatsPieChart extends StatelessWidget {
  final List<CategoryStatistics> stats;
  const CategoryStatsPieChart({super.key, required this.stats});

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final formatter = NumberFormat("0.#%", context.locale.toString());
    final theme = Theme.of(context);

    final total = stats.fold(0.0, (previousValue, element) => previousValue+=element.amount);
    final sections = <PieChartSectionData>[];

    for (final stat in stats) {
      final value = stat.amount / total;
      final title = formatter.format(value);
      final section = PieChartSectionData(
        value: value,
        color: stat.color,
        title: title,
        titleStyle: theme.textTheme.labelMedium?.copyWith(
          color: stat.textColor,
        ),
      );
      sections.add(section);
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _buildSections(context),
      ),
    );
  }
}
