import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/top_bar_action_item.dart';

/// Page Index: 2
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

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
            Text(AppLocalizations.of(context)!.translate('main/label-wip')),
          ],
        ),
      ),
      isInverted: true,
    );
  }
}
