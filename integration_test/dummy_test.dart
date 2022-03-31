// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:linum/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  group('dummy test', () {
    testWidgets('this test cant fail and only resets your session',
        (WidgetTester tester) async {
      await app.main(testing: true);
      sleep(const Duration(seconds: 2));

      await tester.pumpAndSettle(const Duration(seconds: 2));
    });
  });
}
