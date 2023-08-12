import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/account/data/mappers/category_settings_mapper.dart';
import 'package:linum/core/account/data/mappers/language_settings_mapper.dart';
import 'package:linum/core/account/data/models/category_settings.dart';
import 'package:linum/core/account/data/models/language_settings.dart';
import 'package:linum/core/account/data/settings_adapter_impl.dart';
import 'package:linum/core/account/data/settings_repository_impl.dart';
import 'package:linum/core/account/domain/category_settings_service_impl.dart';
import 'package:linum/core/account/domain/language_settings_service_impl.dart';
import 'package:linum/core/account/presentation/services/category_settings_service.dart';
import 'package:linum/core/account/presentation/services/language_settings_service.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:linum/features/currencies/settings/data/currency_settings.dart';
import 'package:linum/features/currencies/settings/data/currency_settings_mapper.dart';
import 'package:linum/features/currencies/settings/domain/currency_settings_service_impl.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';

class UserDependentServices extends StatelessWidget {
  final Store store;
  final Widget child;
  const UserDependentServices({super.key, required this.store, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    final eventService = context.read<EventService>();

    final firestoreAdapter = SettingsAdapterImpl(FirebaseFirestore.instance);

    final languageSettingsRepository = SettingsRepositoryImpl<LanguageSettings>(
      userId: authService.currentUser?.uid,
      adapter: firestoreAdapter,
      mapper: LanguageSettingsMapper(),
    );

    final categorySettingsRepository = SettingsRepositoryImpl<CategorySettings>(
      userId: authService.currentUser?.uid,
      adapter: firestoreAdapter,
      mapper: CategorySettingsMapper(),
    );

    final currencySettingsRepository = SettingsRepositoryImpl<CurrencySettings>(
      userId: authService.currentUser?.uid,
      adapter: firestoreAdapter,
      mapper: CurrencySettingsMapper(),
    );


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ICurrencySettingsService>(
          create: (context) => CurrencySettingsServiceImpl(
              currencySettingsRepository,
          ),
        ),
        ChangeNotifierProvider<ICategorySettingsService>(
          create: (context) => CategorySettingsServiceImpl(
              categorySettingsRepository,
          ),
        ),
        ChangeNotifierProvider<ILanguageSettingsService>(
          create: (context) => LanguageSettingsServiceImpl(
            languageSettingsRepository,
            eventService,
          ),
        ),
        ChangeNotifierProvider<BalanceDataService>(
          create: (context) => BalanceDataService(
              authService.currentUser?.uid ?? "",
          ),
        ),
        ChangeNotifierProvider<ExchangeRateService>(
          create: (context) => ExchangeRateService(
              context.read<ICurrencySettingsService>(),
              store,
          ),
        ),
        ChangeNotifierProvider<PinCodeService>(
          create: (context) => PinCodeService(authService, context),
        ),
      ],
      child: child,
    );
  }
}
