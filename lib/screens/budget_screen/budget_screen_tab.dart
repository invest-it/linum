import 'package:flutter/material.dart';

class BudgetScreenTab extends StatelessWidget {
  final Widget child;
  const BudgetScreenTab({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: child,
    );
  }
}
