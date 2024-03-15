import 'package:flutter/material.dart';
import 'package:linum/common/widgets/stat_slide.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_details_view.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_pie_chart.dart';

class CategoryStatsSlide extends StatelessWidget {
  final List<CategoryStatistics<String>> stats;
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
              child: GestureDetector(
                onTap: () => _openBottomSheet(context),
                child: CategoryStatsPieChart(
                  stats: stats,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return SizedBox(
            height: context.proportionateScreenHeightFraction(ScreenFraction.threequearters),
            child: CategoryStatsDetailsView(
              stats: stats,
            ),
          );
        },
    );
  }
}
