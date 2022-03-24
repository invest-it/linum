import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class SettingsPinlockRobot extends GeneralRobot {
  const SettingsPinlockRobot(WidgetTester tester) : super(tester);

  // Activate the PIN lock
  Future<void> togglePINLock() async {
    await pressVisibleButtonByKey("pinActivationSwitch");
  }

  // ALWAYS set 1234 as standard PIN
  Future<void> dialInPIN() async {
    await pressVisibleButtonByString("1");
    await pressVisibleButtonByString("2");
    await pressVisibleButtonByString("3");
    await pressVisibleButtonByString("4");
  }
}
