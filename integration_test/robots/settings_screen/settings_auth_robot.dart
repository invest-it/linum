import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class SettingsAuthRobot extends GeneralRobot {
  const SettingsAuthRobot(super.tester);

  Future<void> pressLogoutButton() async {
    await dragToKey("forgotPasswordButton", "settingsListView");
    await pressVisibleButtonByKey("logoutButton");
  }
}
