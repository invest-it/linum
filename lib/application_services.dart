//  FirebaseWrapper - wraps firebase and provider instances around the Router
//
//  Author: damattl
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/firebase/firebase_options.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/providers/account_settings_service_provider.dart';
import 'package:linum/providers/action_lip_viewmodel_provider.dart';
import 'package:linum/providers/algorithm_service_provider.dart';
import 'package:linum/providers/authentication_service_provider.dart';
import 'package:linum/providers/balance_data_service_provider.dart';
import 'package:linum/providers/exchange_rate_service_provider.dart';
import 'package:linum/providers/pin_code_service_provider.dart';
import 'package:provider/provider.dart';

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
        child: Text(tr("main.label-error")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: remove after sure it works: SizeGuide.init(context);

    return FutureBuilder(
      future: _initializedApp,
      builder: (innerContext, snapshot) {
        if (snapshot.hasError) {
          buildErrorScaffold(context);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            key: const Key("MainMultiProvider"),
            providers: [
              const AuthenticationServiceProvider(),
              const AccountSettingsServiceProvider(),
              const AlgorithmServiceProvider(),
              ExchangeRateServiceProvider(store: store),
              const BalanceDataServiceProvider(),
              const ActionLipViewModelProvider(),
              const PinCodeServiceProvider(),
            ],
            child: router,

          );
        }
        return const LoadingScaffold();
      },
    );
  }
}
