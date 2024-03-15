import 'package:flutter/material.dart';
import 'package:linum/common/widgets/stat_slide.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_pie_chart.dart';

class CategoryStatsSlide extends StatelessWidget {
  final List<CategoryStatistics> stats;
  const CategoryStatsSlide({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return StatSlide(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CategoryStatsPieChart(
                stats: stats,
              ),
            ),
          );
        },
      ),
    );
  }
}
