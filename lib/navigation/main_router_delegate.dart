import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/navigation/main_route_path.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/screens/onboarding_screen.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/multi_provider_builder.dart';
import 'package:provider/provider.dart';


class FirebaseWrapper extends StatelessWidget {
  final Navigator navigator;
  FirebaseWrapper({Key? key, required this.navigator}) : super(key: key);

  final Future<FirebaseApp> _initializedApp = Firebase.initializeApp();

  Scaffold buildErrorScaffold(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.translate("main/label-error"),
        ),
      ),
    );
  }

  Scaffold buildLoadingScaffold(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: CircularProgressIndicator(),
            ),
            Text(
              AppLocalizations.of(context)!.translate('main/label-loading'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializedApp,
      builder: (innerContext, snapshot) {
        if (snapshot.hasError) {
          buildErrorScaffold(context);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProviderBuilder(context: context, child: navigator)
              .setKey("MainMultiProvider")
              .useProvider(AuthenticationService.provider)
              .useProvider(AccountSettingsProvider.provider)
              .useProvider(AlgorithmProvider.provider)
              .useProvider(BalanceDataProvider.provider)
              .useProvider(ActionLipStatusProvider.provider)
              .useProvider(PinCodeProvider.provider)
              .build();
        }
        return buildLoadingScaffold(context);
      },
    );
  }
}


class MainRouterDelegate extends RouterDelegate<MainRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainRoutePath> {

  List<Page> buildInitialPages(BuildContext context) {
    final AuthenticationService auth = Provider.of<AuthenticationService>(context);
    if (auth.isLoggedIn) {
      return <Page> [
        const MaterialPage(child: LayoutScreen())
      ];
    } else {
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
        )
      ];
    }
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseWrapper(
        navigator: Navigator(
          key: navigatorKey,
          // Add TransitionDelegate here
          pages: buildInitialPages(context),
        ),
    );
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(MainRoutePath configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }

  @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => throw UnimplementedError();

}
