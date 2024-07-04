//  MainRouterDelegate - Handles routing and exchanges Pages based on current route
//
//  Author: damattl
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linum/common/interfaces/service_interface.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/core/navigation/main_routes_extensions.dart';
import 'package:linum/core/navigation/main_transition_delegate.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:linum/screens/onboarding_screen/onboarding_screen.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

Future notifyReady(List<NotifyReady> service) {
  return Future.wait(service.map((service) => service.ready()));
}

class MainRouterDelegate extends RouterDelegate<MainRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoute> {
  @override
  late final GlobalKey<NavigatorState> navigatorKey;
  late final Logger logger;
  bool _servicesReady = false;
  final MainRoute defaultRoute;

  String? lastUid;

  MainRouterDelegate({required this.defaultRoute}) {
    navigatorKey = GlobalKey<NavigatorState>();
    logger = Logger();
  }

  Page? _replacedRoute;
  final _pageStack = <Page>[];

  final Map<String, void Function()> _onPopListeners = {};
  void Function()? _singleOnPopOverwrite;
  void Function()? _onPopOverwrite;
  /* MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch(routeSettings.name) {

    }
  } */


  void setSingleOnPopOverwrite(void Function()? onPop) {
    _singleOnPopOverwrite = onPop;
  }
  void removeSingleOnPopOverwrite() {
    _singleOnPopOverwrite = null;
  }

  void setOnPopOverwrite(void Function()? onPop) {
    _onPopOverwrite = onPop;
  }
  void removeOnPopOverwrite() {
    _onPopOverwrite = null;
  }

  void addOnPopListener(String name, void Function() onPop) {
    _onPopListeners[name] = onPop;
  }

  void removeOnPopListener(String name) {
    _onPopListeners.remove(name);
  }

  List<Page> _buildPageStackUnauthorized() {
    return <Page>[
      const MaterialPage(
        child: OnboardingScreen(),
      ),
    ];
  }

  List<Page> _buildPinCodeStack(PinCodeService pinCodeService) {
    final pinCodeStack = <Page>[
      mainRoutes.pageFromRoute(MainRoute.lock),
    ];
    pinCodeService.setRecallIntent();
    return List.of(pinCodeStack);
  }

  List<Page> _buildPageStackAuthorized(BuildContext context) {
    final PinCodeService pinCodeService =
        context.watch<PinCodeService>();
    const designModeEnabled = bool.fromEnvironment("DESIGN_MODE_ENABLED");
    if (designModeEnabled) {
      _pageStack.add(mainRoutes.pageFromRoute(MainRoute.sandbox));
    }
    if (_pageStack.isEmpty) {
      _pageStack.add(mainRoutes.pageFromRoute(defaultRoute));
    }
    if (pinCodeService.pinSet && !pinCodeService.sessionIsSafe) {
      return _buildPinCodeStack(pinCodeService);
    }

    // TODO: Wait for services to finish


    return List.of(_pageStack);
  }

  List<Page> _buildPageStack(BuildContext context, AuthenticationService auth) {
    if (auth.isLoggedIn) {
      return _buildPageStackAuthorized(context);
    } else {
      return _buildPageStackUnauthorized();
    }
  }

  Widget _buildNavigator(BuildContext context) {

    final transitionDelegate = MainTransitionDelegate();

    return Navigator(
      key: navigatorKey,
      // Add TransitionDelegate here
      pages: _buildPageStack(context, context.read<AuthenticationService>()),
      transitionDelegate: transitionDelegate,
      onPopPage: _onPopPage,
    );

  }

  Widget _awaitServicesReady(BuildContext context, Widget Function(BuildContext context) callback) {
    if (_servicesReady) {
      return callback(context);
    }

    return FutureBuilder(
      future: notifyReady([
        context.read<ICurrencySettingsService>(),
        context.read<ILanguageSettingsService>(),
        context.read<ICategorySettingsService>(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _servicesReady = true;
          return callback(context);
        }
        return const LoadingScaffold();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationService auth = context.watch<AuthenticationService>();

    if (lastUid == null && auth.currentUser?.uid != null) {
      _pageStack.clear();
    }
    if (lastUid != auth.currentUser?.uid) {
      _servicesReady = false;
    }
    lastUid = auth.currentUser?.uid;

    if (_showLoadingScreen) {
      return const LoadingScaffold();
    }

    final pinCodeProvider =
        context.read<PinCodeService>();
    if (pinCodeProvider.pinSetStillLoading) {
      return FutureBuilder(
        future: pinCodeProvider.initializeIsPINSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _awaitServicesReady(context, _buildNavigator);
          }
          return const LoadingScaffold();
        },
      );
    } else {
      return _awaitServicesReady(context, _buildNavigator);
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    logger.i("Route: $route");
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  /// Pop the current route from the MainRouter's Stack.
  /// If there is only one route left, the app will close.
  @override
  Future<bool> popRoute() async {
    logger.i("Stack: $_pageStack");

    if (_singleOnPopOverwrite != null) {
      _singleOnPopOverwrite!.call();
      _singleOnPopOverwrite = null;
      return Future.value(true);
    }

    if (_onPopOverwrite != null) {
      _onPopOverwrite!.call();
      return Future.value(true);
    }

    for (final listener in _onPopListeners.values) {
      listener();
    }

    if (_replacedRoute != null) {
      _pageStack.removeLast();
      _pageStack.add(_replacedRoute!);
      _replacedRoute = null;
      return Future.value(true);
    }

    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      notifyListeners();

      return Future.value(true);
    }
    return Future.value(true);
  }

  bool _showLoadingScreen = false;

  Future<void> showLoadingScreen({Duration duration = const Duration(seconds: 2)}) async {
    _showLoadingScreen = true;
    notifyListeners();
    await Future.delayed(duration);
    _showLoadingScreen = false;
    notifyListeners();
  }

  /// Push a route to the MainRouter's Stack.
  /// Notifies all listening widgets.
  void pushRoute<T>(MainRoute route, {T? settings}) {
    _pageStack.add(mainRoutes.pageFromRoute(route, settings: settings));
    notifyListeners();
  }

  /// Replace the last route on the MainRouter's Stack with a new one.
  /// Notifies all listening widgets.
  void replaceLastRoute(MainRoute route, {bool rememberReplacedRoute = false}) {
    final replaced = _pageStack.removeLast();
    _replacedRoute = rememberReplacedRoute ? replaced : null;
    _pageStack.add(mainRoutes.pageFromRoute(route));

    notifyListeners();
  }

  /// Rebuild the current stack.
  /// Use this function to update the UI after a change in the apps state.
  /// (For example after the user signed out)
  void rebuild() {
    notifyListeners();
  }


  @override
  Future<void> setNewRoutePath(MainRoute route) async {}
}
