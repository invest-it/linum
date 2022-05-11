import 'package:flutter_test/flutter_test.dart';

import '../general/general_robot.dart';

class HomeRobot extends GeneralRobot {
  const HomeRobot(WidgetTester tester) : super(tester);

  Future<void> pressPINLockButton() async {
    return pressVisibleButtonByKey("pinRecallButton");
  }
}
