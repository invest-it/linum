import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/top_bar_action_item.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Stats',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBarActionItem(
              buttonIcon: Icons.build,
              onPressedAction: () => log('message'),
            ),
            Text('Work in progress. Please check back soon.'),
          ],
        ),
      ),
      isInverted: true,
    );
  }
}
