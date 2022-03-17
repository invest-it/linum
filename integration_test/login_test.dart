import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:linum/main.dart' as app;

import 'robots/home_robot.dart';
import 'robots/onboarding_screen/onboarding_open_sign_in.dart';
import 'robots/onboarding_screen/onboarding_open_sign_up.dart';
import 'robots/onboarding_screen/onboarding_robot.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  HomeRobot homeRobot;
  OnboardingRobot onboardingRobot;
  OnboardingOpenSignUpRobot onboardingOpenSignUpRobot;
  OnboardingOpenSignInRobot onboardingOpenSignInRobot;

  group('e2e test', () {
    testWidgets('whole app', (WidgetTester tester) async {
      app.main();

      homeRobot = HomeRobot(tester);
      onboardingRobot = OnboardingRobot(tester);
      onboardingOpenSignUpRobot = OnboardingOpenSignUpRobot(tester);
      onboardingOpenSignInRobot = OnboardingOpenSignInRobot(tester);

      // For recording perf
      // await tester.pumpAndSettle();
      // final listFinder = find.byKey(const Key('singleChildScrollView'));
      // await binding.watchPerformance(() async {
      //   await tester.fling(listFinder, const Offset(0, -500), 10000);
      //   await tester.pumpAndSettle();
      // });

      await tester.pumpAndSettle();

      await onboardingRobot.pressSignUpNow();

      /*
      await homeRobot.findTitle();

      await homeRobot.scrollThePage();

      await homeRobot.clickFirstButton();
      await secondScreenRobot.findTitle();
      await secondScreenRobot.scrollThePage();
      await secondScreenRobot.scrollThePage(scrollUp: true);
      await secondScreenRobot.goBack();

      await homeRobot.clickSecondButton();
      await thirdScreenRobot.findTitle();
      await thirdScreenRobot.scrollThePage();
      await thirdScreenRobot.scrollThePage(scrollUp: true);
      await thirdScreenRobot.clickTile(2);
      await thirdScreenRobot.goBack();

      await homeRobot.scrollThePage(scrollUp: true);

      */
    });
  });
}
