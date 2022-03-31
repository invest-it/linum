import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class PinlockRobot extends GeneralRobot {
  const PinlockRobot(WidgetTester tester) : super(tester);

  // Activate the PIN lock
  Future<void> togglePINLock() async {
    return pressVisibleButtonByKey("pinActivationSwitch");
  }

  Future<void> togglePINChange() async {
    return pressVisibleButtonByKey("pinChangeSwitch");
  }

  Future<void> togglePINReset() async {
    return pressVisibleButtonByKey("pinActionSwitch");
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

  Future<void> dialInPINWithIntentionalErrors(
    int one,
    int two,
    int three,
    int four,
  ) async {
    final int dummx = Random().nextInt(10);
    final int dummy = Random().nextInt(10);

    await pressVisibleButtonByString(
      dummx.toString(),
      settleDuration: const Duration(milliseconds: 800),
    );
    await pressVisibleButtonByKey(
      "pinlockBackspace",
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      one.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      two.toString(),
      settleDuration: const Duration(milliseconds: 100),
    );
    await pressVisibleButtonByString(
      dummy.toString(),
      settleDuration: const Duration(milliseconds: 800),
    );
    await pressVisibleButtonByKey(
      "pinlockBackspace",
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
