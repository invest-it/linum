//  FirebaseWrapper - wraps firebase and provider instances around the Router
//
//  Author: damattl
//  Co-Author: n/a
//


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/loading_scaffold.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/exchange_rate_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/utilities/frontend/multi_provider_builder.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class ApplicationServices extends StatelessWidget {
  final Router router;
  final Store store;
  ApplicationServices({super.key, required this.store, required this.router});

  final Future<FirebaseApp> _initializedApp = Firebase.initializeApp();

  Scaffold buildErrorScaffold(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(tr("main.label-error")),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeGuide.init(context);
    
    return FutureBuilder(
      future: _initializedApp,
      builder: (innerContext, snapshot) {
        if (snapshot.hasError) {
          buildErrorScaffold(context);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProviderBuilder(context: context, child: router)
              .setKey("MainMultiProvider")
              .useProvider(AuthenticationService.builder())
              .useProvider(AccountSettingsProvider.builder())
              .useProvider(AlgorithmProvider.builder())
              .useProvider(ExchangeRateProvider.builder(store))
              .useProvider(BalanceDataProvider.builder())
              .useProvider(ActionLipStatusProvider.builder())
              .useProvider(PinCodeProvider.builder())
              .build();
        }
        return const LoadingScaffold();
      },
    );
  }
}
