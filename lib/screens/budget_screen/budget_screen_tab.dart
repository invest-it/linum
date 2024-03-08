import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';

class BudgetScreenTab extends StatelessWidget {
  final Widget child;
  const BudgetScreenTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollConfiguration(
        behavior: const SilentScroll(),
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
