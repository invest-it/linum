import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
        head: 'Budget',
        body: Center(
          child: Text('It works!'),
        ),
        isInverted: false);
  }
}
