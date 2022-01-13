import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/top_bar_action_item.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({Key? key}) : super(key: key);
  int volume = 0;

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
            ],
          ),
        ),
        isInverted: true);
  }
}
