import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/login_form.dart';
import 'package:linum/widgets/onboarding/login_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<BuildContext>()])
@GenerateNiceMocks([MockSpec<DiagnosticsNode>()])
@GenerateNiceMocks([MockSpec<MediaQueryData>()])
@GenerateNiceMocks([MockSpec<MediaQuery>()])
@GenerateNiceMocks([MockSpec<OnboardingScreenProvider>()])
import 'login_screen_test.mocks.dart';

void main() {
  group('LoginScreen', () {
    late MockOnboardingScreenProvider mockProvider;
    late MockBuildContext mockBuildContext;
    late MockMediaQuery mockMediaQuery;
    late MockMediaQueryData mockMediaQueryData;
    late MockDiagnosticsNode mockDiagnosticsNode;

    const screenHeight = 812.0;
    const screenWidth = 375.0;

    setUp(() {
      mockProvider = MockOnboardingScreenProvider();
      when(mockProvider.pageState).thenReturn(OnboardingPageState.none);

      mockMediaQueryData = MockMediaQueryData();
      when(mockMediaQueryData.size)
          .thenReturn(const Size(screenWidth, screenHeight));
      when(mockMediaQueryData.orientation).thenReturn(Orientation.portrait);
      when(mockMediaQueryData.viewInsets)
          .thenReturn(const EdgeInsets.fromLTRB(0, 0, 0, 100));

      mockMediaQuery = MockMediaQuery();
      when(mockMediaQuery.data).thenReturn(mockMediaQueryData);

      mockDiagnosticsNode = MockDiagnosticsNode();

      mockBuildContext = MockBuildContext();
      when(mockBuildContext.dependOnInheritedWidgetOfExactType<MediaQuery>())
          .thenReturn(mockMediaQuery);
      when(mockBuildContext.describeWidget(any))
          .thenReturn(mockDiagnosticsNode);
      when(mockBuildContext.describeOwnershipChain(any))
          .thenReturn(mockDiagnosticsNode);

      // SizeGuide.init(mockBuildContext);
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockProvider,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(LoginForm), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
      expect(find.byType(ClipRRect), findsNWidgets(2));
    });
  });
}
