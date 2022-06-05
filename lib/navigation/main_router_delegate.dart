//  MainRouterDelegate - Handles routing and exchanges Pages based on current route
//
//  Author: damattl
//

import 'package:flutter/material.dart';
import 'package:linum/loading_scaffold.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/navigation/main_routes_extensions.dart';
import 'package:linum/navigation/route_configuration.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
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

  List<Page> buildPinCodeStack(PinCodeProvider pinCodeProvider) {
    final pinCodeStack = <Page> [
      mainRoutes.pageFromRoute(MainRoute.lock),
    ];
    pinCodeProvider.setRecallIntent();
    return List.of(pinCodeStack);
  }

  List<Page> buildPageStackAuthorized(BuildContext context) {
    final PinCodeProvider pinCodeProvider = Provider.of<PinCodeProvider>(context);
    if (_pageStack.isEmpty) {
      _pageStack.add(mainRoutes.pageFromRoute(MainRoute.home));
    }
    if (pinCodeProvider.pinSet && !pinCodeProvider.sessionIsSafe) {
      return buildPinCodeStack(pinCodeProvider);
    }

    return List.of(_pageStack);
  }


  List<Page> buildPageStack(BuildContext context) {
    final AuthenticationService auth = Provider.of<AuthenticationService>(context);
    if (auth.isLoggedIn) {
      return buildPageStackAuthorized(context);
    } else {
      return buildPageStackUnauthorized();
    }
  }

  Navigator buildNavigator(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      // Add TransitionDelegate here
      pages: buildPageStack(context),
      onPopPage: _onPopPage,
    );
  }


  @override
  Widget build(BuildContext context) {
    final pinCodeProvider = Provider.of<PinCodeProvider>(context, listen: false);
    if (pinCodeProvider.pinSetStillLoading) {
      return FutureBuilder(
        future: pinCodeProvider.initializeIsPINSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildNavigator(context);
          }
          return const LoadingScaffold();
        },
      );
    } else {
      return buildNavigator(context);
    }
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

  void pushRoute<T>(MainRoute route, {T? settings}) {
    _pageStack.add(mainRoutes.pageFromRoute(route, settings: settings));
    notifyListeners();
  }

  void replaceLastRoute(MainRoute route) {
    _pageStack.removeLast();
    _pageStack.add(mainRoutes.pageFromRoute(route));

    notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(MainRoute route) async {

  }


}
