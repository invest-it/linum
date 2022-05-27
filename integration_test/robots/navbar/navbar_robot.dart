//  Navbar Robot - A Robot specifically designed to perform tasks on the Global Navigation Bar.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class NavbarRobot extends GeneralRobot {
  const NavbarRobot(WidgetTester tester) : super(tester);

  Future<void> pressHomeButton() async {
    return pressVisibleButtonByString("Home", buttonType: InkWell);
  }

  Future<void> pressBudgetButton() async {
    return pressVisibleButtonByString("Budget", buttonType: InkWell);
  }

  Future<void> pressStatsButton() async {
    return pressVisibleButtonByString("Stats", buttonType: InkWell);
  }

  Future<void> pressSettingsButton() async {
    return pressVisibleButtonByString("Account", buttonType: InkWell);
  }
}
