//  Filter Screen - Essential Pushed Screen that is able to search for and filter both individual and serial transactions by smart criteria.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/design/layout/widgets/top_bar_action_item.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenSkeleton(
        head: 'Filter',
        leadingAction: AppBarAction.fromPreset(DefaultAction.back),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TopBarActionItem(
                buttonIcon: Icons.build,
                onPressedAction: () => log('message'),
              ),
              Text(tr('main.label-wip')),
            ],
          ),
        ),
      ),
    );
  }
}
