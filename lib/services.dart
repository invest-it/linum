//  FirebaseWrapper - wraps firebase and provider instances around the Router
//
//  Author: damattl
//  Co-Author: n/a
//

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/localization/settings/utils/locale_utils.dart';
import 'package:linum/firebase/firebase_options.g.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/global_event_handler.dart';
import 'package:linum/user_dependent_services.dart';
import 'package:linum/user_independent_services.dart';
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
              child: GlobalEventListener(
                listeners: [
                  _handleLanguageChangeEvent
                ],
                child: router,
              ),
            ),
          );
        }
        return const LoadingScaffold();
      },
    );
  }

  // TODO: find a place for this
  void _handleLanguageChangeEvent(IEvent event, BuildContext context) {
    final languageSettingsService = context.read<ILanguageSettingsService>();
    final String? langCode = languageSettingsService.getLanguageCode();
    Locale? locale;
    if (!languageSettingsService.useSystemLanguage && langCode != null) {
      final List<String> langArray = langCode.split("-");
      locale = Locale(langArray[0], langArray[1]);
      context.setAppLocale(locale);
    } else {
      context.setLocaleToDeviceLocale();
    }
  }
}
