import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/categories/settings/data/category_settings.dart';
import 'package:linum/core/categories/settings/data/category_settings_mapper.dart';
import 'package:linum/core/categories/settings/domain/category_settings_service_impl.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/localization/settings/data/language_settings.dart';
import 'package:linum/core/localization/settings/data/language_settings_mapper.dart';
import 'package:linum/core/localization/settings/domain/language_settings_service_impl.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/settings/data/settings_repository_impl.dart';
import 'package:linum/core/settings/data/settings_storage_impl.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_repository_impl.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_storage_impl.dart';
import 'package:linum/features/currencies/core/data/exchange_rate_synchronizer.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_fetcher.dart';
import 'package:linum/features/currencies/core/domain/exchange_rate_service_impl.dart';
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';
import 'package:linum/features/currencies/settings/data/currency_settings.dart';
import 'package:linum/features/currencies/settings/data/currency_settings_mapper.dart';
import 'package:linum/features/currencies/settings/domain/currency_settings_service_impl.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';

/// All services that depend on a signed in user are defined here.
class UserDependentServices extends StatelessWidget {
  final Store store;
  final Widget child;
  const UserDependentServices({super.key, required this.store, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    final eventService = context.read<EventService>();

    final settingsStorage = SettingsStorageImpl(FirebaseFirestore.instance);

    final languageSettingsRepository = SettingsRepositoryImpl<LanguageSettings>(
      userId: authService.currentUser?.uid,
      adapter: settingsStorage,
      mapper: LanguageSettingsMapper(),
    );

    final categorySettingsRepository = SettingsRepositoryImpl<CategorySettings>(
      userId: authService.currentUser?.uid,
      adapter: settingsStorage,
      mapper: CategorySettingsMapper(),
    );

    final currencySettingsRepository = SettingsRepositoryImpl<CurrencySettings>(
      userId: authService.currentUser?.uid,
      adapter: settingsStorage,
      mapper: CurrencySettingsMapper(),
    );

    final exchangeRateStorage = ExchangeRateStorageImpl(store);
    final exchangeRateSynchronizer = ExchangeRateSynchronizer(store);

    final exchangeRateRepository = ExchangeRateRepositoryImpl(
      exchangeRateStorage, exchangeRateSynchronizer,
    );

    final exchangeRateFetcher = ExchangeRateFetcher(
      exchangeRateRepository,
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
        ChangeNotifierProvider<IExchangeRateService>(
          create: (context) => ExchangeRateServiceImpl(
            context.read<ICurrencySettingsService>(),
            exchangeRateFetcher,
          ),
        ),
        ChangeNotifierProvider<PinCodeService>(
          create: (context) => PinCodeService(authService),
        ),
      ],
      child: child,
    );
  }
}
