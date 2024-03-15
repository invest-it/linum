import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/widgets/screen_tab.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_pie_chart.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_slide.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenTab(
      child: Column(
        children: [
          CategoryStatsSlide(
            stats: [
              CategoryStatistics(
                categoryId: "food",
                type: EntryType.expense,
                amount: 200,
                color: Colors.redAccent,
              ),
              CategoryStatistics(
                categoryId: "house",
                type: EntryType.expense,
                amount: 600,
                color: Colors.green,
              ),
              CategoryStatistics(
                categoryId: "freetime",
                type: EntryType.expense,
                amount: 1000,
                color: Colors.indigo,
              ),
              CategoryStatistics(
                categoryId: "lifestyle",
                type: EntryType.expense,
                amount: 200,
                color: Colors.lightBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
