import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class NavbarRobot extends GeneralRobot {
  const NavbarRobot(WidgetTester tester) : super(tester);

  Future<void> pressHomeButton() async {
    await pressVisibleButtonByString("Home", buttonType: InkWell);
  }

  Future<void> pressBudgetButton() async {
    await pressVisibleButtonByString("Budget", buttonType: InkWell);
  }

  Future<void> pressStatsButton() async {
    await pressVisibleButtonByString("Stats", buttonType: InkWell);
  }

  Future<void> pressSettingsButton() async {
    await pressVisibleButtonByString("Account", buttonType: InkWell);
  }
}
