import 'package:flutter_test/flutter_test.dart';

class OnboardingOpenSignInRobot {
  const OnboardingOpenSignInRobot(this.tester);

  final WidgetTester tester;
  Future<void> fillInEmail(String email) async {
    find.byTooltip("Email address");
  }

  Future<void> fillInPassword(String pwd) async {}
}
