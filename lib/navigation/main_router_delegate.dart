import 'package:flutter/material.dart';
import 'package:linum/navigation/main_route_path.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';





class MainRouterDelegate extends RouterDelegate<MainRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  bool show404 = false;


  List<Page> buildPageStackUnauthorized() {
    return <Page> [
      MaterialPage(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<OnboardingScreenProvider>(
              create: (_) => OnboardingScreenProvider(),
            ),
          ],
          child: const OnboardingPage(),
        ),
      ),
    ];
  }

  List<Page> buildPageStackAuthorized() {
    return <Page> [
      const MaterialPage(child: LayoutScreen())
    ];
  }

  List<Page> buildPageStack(BuildContext context) {
    final AuthenticationService auth = Provider.of<AuthenticationService>(context);
    if (auth.isLoggedIn) {
      return buildPageStackAuthorized();
    } else {
      return buildPageStackUnauthorized();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      // Add TransitionDelegate here
      pages: buildPageStack(context),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        notifyListeners();
        return true;
      },
    );
  }



  @override
  Future<void> setNewRoutePath(MainRoutePath path) async {
    if (path.isUnknown) {
      show404 = true;
      return;
    }

    show404 = false;
  }

}
