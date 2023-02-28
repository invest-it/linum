import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/auth/login_form.dart';
import 'package:linum/widgets/onboarding/login_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<OnboardingScreenProvider>()])
@GenerateNiceMocks([MockSpec<BuildContext>()])
@GenerateNiceMocks([MockSpec<MediaQueryData>()])
@GenerateNiceMocks([MockSpec<MediaQuery>()])
import 'login_screen_test.mocks.dart';

void main() {
  group('LoginScreen', () {
    late MockOnboardingScreenProvider mockProvider;
    late MockBuildContext mockBuildContext;
    late MockMediaQuery mockMediaQuery;
    late MockMediaQueryData mockMediaQueryData;

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

      mockBuildContext = MockBuildContext();
      when(mockBuildContext.dependOnInheritedWidgetOfExactType<MediaQuery>())
          .thenReturn(mockMediaQuery);

      SizeGuide.init(mockBuildContext);
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

    testWidgets('sets the state when onTap is called',
        (WidgetTester tester) async {
      when(mockProvider.setPageState(OnboardingPageState.login))
          .thenReturn(null);
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockProvider,
            child: const LoginScreen(),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector));
      verify(mockProvider.setPageState(OnboardingPageState.login)).called(1);
    });

    testWidgets('renders the login page', (WidgetTester tester) async {
      when(mockProvider.pageState).thenReturn(OnboardingPageState.login);
      when(mockProvider.setPageState(OnboardingPageState.login))
          .thenReturn(null);
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: mockProvider,
            child: const LoginScreen(),
          ),
        ),
      );
      final loginYOffset =
          proportionateScreenHeightFraction(ScreenFraction.twofifths);
      const loginXOffset = 0.0;
      final loginWidth = screenWidth;
      const loginOpacity = 1.0;
      const loginFormYOffset = 0.0;
      const loginFormHeight = 742.0;

      expect(
          tester
              .widget<GestureDetector>(
                find.byType(GestureDetector),
              )
              .onTap,
          isNotNull);

      expect(
        tester
            .widget<AnimatedContainer>(
              find.byType(AnimatedContainer),
            )
            .duration,
        const Duration(milliseconds: 1200),
      );
      expect(
        tester
            .widget<AnimatedContainer>(
              find.byType(AnimatedContainer),
            )
            .curve,
        Curves.fastLinearToSlowEaseIn,
      );
      expect(
        tester
            .widget<AnimatedContainer>(
              find.byType(AnimatedContainer),
            )
            .transform,
        Matrix4.translationValues(loginXOffset, loginYOffset, 1),
      );
      expect(
          tester
              .widget<AnimatedContainer>(
                find.byType(AnimatedContainer),
              )
              .decoration,
          const BoxDecoration(
            color: Colors.black, // TODO
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x7f000000),
                offset: Offset(0, 5),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ));

      expect(
        tester
            .widget<SizedBox>(
              find.byType(SizedBox),
            )
            .height,
        loginFormHeight,
      );
      // expect(
      //   tester.widget<AnimatedContainer>(
      //     find.byType(AnimatedContainer),
      //   ).width,
      //   loginWidth,
      // );
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.byType(AnimatedOpacity),
            )
            .opacity,
        loginOpacity,
      );
    });
  });
}
