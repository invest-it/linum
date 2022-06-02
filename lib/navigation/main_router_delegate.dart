//  MainRouterDelegate - Handles routing and exchanges Pages based on current route
//
//  Author: damattl
//

import 'package:flutter/material.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/main_routes_extensions.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;


class MainRouterDelegate extends RouterDelegate<MainRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoute> {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  final _pageStack = <Page> [];
  /* MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch(routeSettings.name) {

    }
  } */

  List<Page> buildPageStackUnauthorized() {
    return <Page> [ // TODO: Might not work (List.of)
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


  List<Page> buildPageStack(BuildContext context) {
    final AuthenticationService auth = Provider.of<AuthenticationService>(context);
    if (auth.isLoggedIn) {
      if (_pageStack.isEmpty) {
        _pageStack.add(mainRoutes.builderFromRoute(MainRoute.home)());
      }
      return List.of(_pageStack);
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
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, dynamic result) {
    dev.log("Route: $route");
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() async {
    dev.log("Stack: ${_pageStack.toString()}");
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      notifyListeners();

      return Future.value(true);
    }
    return Future.value(true); // TODO: Check if this makes sense
  }

  void pushRoute(MainRoute route) {
    _pageStack.add(mainRoutes.builderFromRoute(route)()); // TODO: Replace with pageFromRoute ???
    notifyListeners();
  }

  void replaceLastRoute(MainRoute route) {
    _pageStack.removeLast();
    _pageStack.add(mainRoutes.builderFromRoute(route)());

    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MainRoute route) async {

  }


}
