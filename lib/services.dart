//  FirebaseWrapper - wraps firebase and provider instances around the Router
//
//  Author: damattl
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:linum/core/account/app_settings.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:linum/firebase/firebase_options.g.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';



class UserIndependentServices extends StatelessWidget {
  final Widget child;
  const UserIndependentServices({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthenticationService(
      FirebaseAuth.instance,
      languageCode: context.locale.languageCode,
    );

    final algorithmService = AlgorithmService();


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationService>.value(
          value: authService,
        ),
        ChangeNotifierProvider<AlgorithmService>.value(
            value: algorithmService,
        ),
        ChangeNotifierProvider<ActionLipViewModel>(
          create: (_) => ActionLipViewModel(),
        ),

      ],
      child: child,
    );
  }
}

class UserDependentServices extends StatelessWidget {
  final Store store;
  final Widget widget;
  const UserDependentServices({super.key, required this.store, required this.widget});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthenticationService>();

    print(authService.currentUser);
    final appSettings = AppSettings(
        context: context,
        user: authService.currentUser,
    );


    final exchangeRateService = ExchangeRateService(appSettings, store);
    final balanceDataService = BalanceDataService(authService.currentUser?.uid ?? "");

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppSettings>.value(
            value: appSettings,
          ),
          ChangeNotifierProvider<BalanceDataService>.value(
            value: balanceDataService,
          ),
          ChangeNotifierProvider<ExchangeRateService>.value(
              value: exchangeRateService,
          ),
          ChangeNotifierProvider<PinCodeService>(
            create: (context) => PinCodeService(authService, context),
          ),
        ],
        child: widget,
    );
  }
}



class ApplicationServices extends StatelessWidget {
  final Router router;
  final Store store;
  ApplicationServices({super.key, required this.store, required this.router});

  final Future<FirebaseApp> _initializedApp = Firebase.initializeApp(
    name: "Linum",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Scaffold buildErrorScaffold(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(tr(translationKeys.main.labelError)),
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
          return UserIndependentServices(
            child: UserDependentServices(
              store: store,
              widget: router,
            ),
          );
        }
        return const LoadingScaffold();
      },
    );
  }
}
