import 'package:flutter/material.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';





class MainRouterDelegate extends RouterDelegate<MainRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoute> {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  bool show404 = false;
  MainRoute currentRoute = MainRoute.home;

  final _pageStack = <Page> [];

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  /* MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch(routeSettings.name) {

    }
  } */

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
    final pageStack = <Page> [];

    pageStack.add(mainRoutes[currentRoute]!.builder());

    return pageStack;
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
  Future<bool> popRoute() {
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      notifyListeners();

      return Future.value(true);
    }
    return Future.value(true); // TODO: Check if this makes sense
  }


  @override
  Future<void> setNewRoutePath(MainRoute route) async {
    currentRoute = route;

  }

}
