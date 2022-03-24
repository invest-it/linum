import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class NavbarRobot extends GeneralRobot {
  const NavbarRobot(WidgetTester tester) : super(tester);

  Future<void> pressHomeButton() async {
    await pressVisibleUniqueButton("Home", buttonType: InkWell);
  }

  Future<void> pressBudgetButton() async {
    await pressVisibleUniqueButton("Budget", buttonType: InkWell);
  }

  Future<void> pressStatsButton() async {
    await pressVisibleUniqueButton("Stats", buttonType: InkWell);
  }

  Future<void> pressSettingsButton() async {
    await pressVisibleUniqueButton("Account", buttonType: InkWell);
  }
}
