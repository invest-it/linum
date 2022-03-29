import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class SettingsPinlockRobot extends GeneralRobot {
  const SettingsPinlockRobot(WidgetTester tester) : super(tester);

  // Activate the PIN lock
  Future<void> togglePINLock() async {
    await pressVisibleButtonByKey("pinActivationSwitch");
  }

  // ALWAYS set 1234 as standard PIN
  Future<void> dialInPIN(int one, int two, int three, int four) async {
    await pressVisibleButtonByString(
      one.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      two.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      three.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      four.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
  }
}
