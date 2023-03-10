///
///
///
/// generate Mockfile command:
/// flutter pub run build_runner build

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/utilities/frontend/layout_helpers.dart';
import 'package:linum/widgets/auth/login_form.dart';
import 'package:linum/widgets/onboarding/login_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<OnboardingScreenProvider>()])
@GenerateNiceMocks([MockSpec<AuthenticationService>()])
import 'login_screen_test.mocks.dart';

void main() {
  group('LoginScreen', () {
    late MockOnboardingScreenProvider mockOnboardingScreenProvider;
    late MockAuthenticationService mockAuthenticationService;
    late MultiProvider baseMultiProvider;

    setUp(() {
      mockOnboardingScreenProvider = MockOnboardingScreenProvider();
      when(mockOnboardingScreenProvider.pageState)
          .thenReturn(OnboardingPageState.none);

      mockAuthenticationService = MockAuthenticationService();

      baseMultiProvider = MultiProvider(
        providers: [
          ChangeNotifierProvider<OnboardingScreenProvider>(
            create: (_) => mockOnboardingScreenProvider,
          ),
          ChangeNotifierProvider<AuthenticationService>(
            create: (_) => mockAuthenticationService,
          ),
          ChangeNotifierProvider<ActionLipStatusProvider>(
            create: (_) => ActionLipStatusProvider(),
          ),
        ],
        child: const LoginScreen(),
      );
    });

    testWidgets('renders all children', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: baseMultiProvider,
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(AnimatedContainer), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(ClipRRect), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
    });
  });
}
