import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/widgets/screen_tab.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_pie_chart.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_slide.dart';

class IncomeTab extends StatelessWidget {
  const IncomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTab(
      child: Column(
        children: [
          CategoryStatsSlide(
            stats: [
              CategoryStatistics(
                categoryId: "salary",
                type: EntryType.income,
                amount: 2000,
                color: Colors.redAccent,
              ),
              CategoryStatistics(
                categoryId: "allowance",
                type: EntryType.income,
                amount: 600,
                color: Colors.green,
              ),
              CategoryStatistics(
                categoryId: "interest",
                type: EntryType.income,
                amount: 100,
                color: Colors.indigo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
