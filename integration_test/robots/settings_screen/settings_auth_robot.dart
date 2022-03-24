import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class SettingsAuthRobot extends GeneralRobot {
  const SettingsAuthRobot(WidgetTester tester) : super(tester);

  Future<void> pressLogoutButton() async {
    await pressVisibleButtonByKey("logoutButton");
  }
}
