//  FirebaseWrapper - wraps firebase and provider instances around the Router
//
//  Author: damattl
//  Co-Author: n/a
//


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/multi_provider_builder.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

class FirebaseWrapper extends StatelessWidget {
  final Router router;
  FirebaseWrapper({Key? key, required this.router}) : super(key: key);

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
