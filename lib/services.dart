import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/loading_scaffold.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_types.dart';
import 'package:linum/core/localization/settings/constants/supported_locales.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/localization/settings/utils/locale_utils.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/firebase/firebase_options.g.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/global_event_handler.dart';
import 'package:linum/user_dependent_services.dart';
import 'package:linum/user_independent_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Place were all application services are defined.
/// Differentiates between user dependent services and user independent services
/// To define user dependent services use the UserDependentServices widget
/// To define user independent services use the UserIndependentServices widget
class ApplicationServices extends StatelessWidget {
  final Router router;
  final Store store;
  final SharedPreferences preferences;
  ApplicationServices({super.key, required this.store, required this.router, required this.preferences});

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
            builder: (context, user, child) {
              return UserDependentServices(
                store: store,
                user: user,
                preferences: preferences,
                child: EventListener(
                  streamName: "global",
                  listeners: {
                    EventType.languageChange: [
                      _handleLanguageChangeEvent,
                    ],
                  },
                  child: router, // TODO: Move child outside
                ),
              );
            },
          );
        }
        return const LoadingScaffold();
      },
    );
  }

  // TODO: find a place for this
  Future _handleLanguageChangeEvent(IEvent event, BuildContext context) async {
    final languageSettingsService = context.read<ILanguageSettingsService>();
    final String? localeStr = event.message;
    final locale = supportedLocales.firstWhereOrNull((l) => l.toLanguageTag() == localeStr);
    // print(localeStr);
    // print(languageSettingsService.useSystemLanguage);


    if (context.locale.toLanguageTag() == localeStr && !languageSettingsService.useSystemLanguage) {
      return;
    }

    final delegate = router.routerDelegate as MainRouterDelegate;
    delegate.showLoadingScreen(duration: const Duration(milliseconds: 750));
    delegate.resetServicesLoadingState();
    
    if (localeStr != null && locale != null && !languageSettingsService.useSystemLanguage) {
      // print("Set App Locale");
      context.setAppLocale(locale);
    } else {
      context.setLocaleToDeviceLocale();
    }
  }

}
