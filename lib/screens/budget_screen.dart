import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
        head: 'Budget',
        body: Center(
          child: Text('Budget Screen coming soon'),
        ),
        isInverted: false);
  }
}
