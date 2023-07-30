import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/authentication/login_view.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/authentication/widgets/login_form/login_form.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateNiceMocks([MockSpec<OnboardingScreenViewModel>()])
@GenerateNiceMocks([MockSpec<AuthenticationService>()])
import 'login_screen_test.mocks.dart';

/// generate Mockfile command:
/// flutter pub run build_runner build
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
          ChangeNotifierProvider<OnboardingScreenViewModel>(
            create: (_) => mockOnboardingScreenProvider,
          ),
          ChangeNotifierProvider<AuthenticationService>(
            create: (_) => mockAuthenticationService,
          ),
          ChangeNotifierProvider<ActionLipViewModel>(
            create: (_) => ActionLipViewModel(),
          ),
        ],
        child: const LoginView(),
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
