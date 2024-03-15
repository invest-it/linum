//  Statistics Screen - Screen allowing basic as well as complex visualization of transaction statistics
//
//  Author: thebluebaronx (In the Future)
//  Co-Author: n/a

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/statistics_screen/expense_tab.dart';
import 'package:linum/screens/statistics_screen/income_tab.dart';

/// Page Index: 2
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Stats',
      body: Column(
        children: [
          TabBar(
            padding: const EdgeInsets.symmetric(vertical: 12),
            dividerHeight: 0,
            controller: _tabController,
            tabs: const [
              Tab(
                text: "Income",
              ),
              Tab(
                text: "Expense",
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                IncomeTab(),
                ExpenseTab(),
              ],
            ),
          ),
        ],
      ),
      isInverted: true,
    );
  }
}
