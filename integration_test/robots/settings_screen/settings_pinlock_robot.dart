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
    await pressVisibleButtonByString(
      "1",
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      "2",
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      "3",
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      "4",
      settleDuration: const Duration(milliseconds: 100),
    );
  }
}
