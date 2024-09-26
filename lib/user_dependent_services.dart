import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/service_container.dart';
import 'package:linum/core/authentication/domain/services/authentication_service.dart';
import 'package:linum/core/balance/domain/repository_impl/balance_data_repository_impl.dart';
import 'package:linum/core/balance/ports/firebase/firebase_balance_adapter.dart';
import 'package:linum/core/balance/presentation/algorithm_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service.dart';
import 'package:linum/core/balance/presentation/balance_data_service_impl.dart';
import 'package:linum/core/budget/domain/repositories/budget_repository_impl.dart';
import 'package:linum/core/budget/domain/service_impl/budget_service_impl.dart';
import 'package:linum/core/budget/ports/adapter/firebase_budget_adapter.dart';
import 'package:linum/core/budget/presentation/budget_service.dart';
import 'package:linum/core/categories/core/domain/service_impl/category_service_standard_impl.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';
import 'package:linum/core/categories/settings/data/category_settings.dart';
import 'package:linum/core/categories/settings/data/category_settings_mapper.dart';
import 'package:linum/core/categories/settings/domain/category_settings_service_impl.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/localization/settings/data/language_settings.dart';
import 'package:linum/core/localization/settings/data/language_settings_mapper.dart';
import 'package:linum/core/localization/settings/data/language_settings_pref_adapter.dart';
import 'package:linum/core/localization/settings/domain/language_settings_service_impl.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/settings/data/settings_repository_impl.dart';
import 'package:linum/core/settings/data/settings_storage_impl.dart';
import 'package:linum/core/stats/domain/service_impl/statistic_service.dart';
import 'package:linum/core/stats/presentation/statistics_service.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

/// All services that depend on a signed in user are defined here.
class UserDependentServices extends StatefulWidget {
  final Store store;
  final User? user;
  final SharedPreferences preferences;
  final Widget child;
  const UserDependentServices({
    super.key, 
    required this.store, 
    required this.child, 
    required this.preferences, 
    required this.user,
  });

  @override
  State<UserDependentServices> createState() => _UserDependentServicesState();
}

class _UserDependentServicesState extends State<UserDependentServices> {
  SettingsStorageImpl? settingsStorage;
  final ServiceContainer _container = ServiceContainer();
  late Widget _serviceWidget;

  @override
  void initState() {
    // print("State init");
    settingsStorage = SettingsStorageImpl(FirebaseFirestore.instance, widget.user?.uid);
    _buildServices(context.read<EventService>());
    super.initState();
  }

  @override
  void didUpdateWidget(UserDependentServices oldWidget) {
    // print("didUpdateWidget");
    if (oldWidget.user != widget.user) {
      settingsStorage?.dispose();
      settingsStorage = SettingsStorageImpl(FirebaseFirestore.instance, widget.user?.uid);
      _buildServices(context.read<EventService>());
      super.didUpdateWidget(oldWidget);
    }
  }

  void _buildServices(EventService eventService) {
    _container.clear();

    final categoryService = CategoryServiceStandardImpl();

    final languageSettingsRepository = SettingsRepositoryImpl<LanguageSettings>(
      adapter: settingsStorage!,
      mapper: LanguageSettingsMapper(),
      prefAdapter: LanguageSettingsPrefAdapter(preferences: widget.preferences),
    );

    final categorySettingsRepository = SettingsRepositoryImpl<CategorySettings>(
      adapter: settingsStorage!,
      mapper: CategorySettingsMapper(
        categoryService: categoryService,
      ),
    );

    final currencySettingsRepository = SettingsRepositoryImpl<CurrencySettings>(
      adapter: settingsStorage!,
      mapper: CurrencySettingsMapper(),
    );

    final exchangeRateStorage = ExchangeRateStorageImpl(widget.store);
    final exchangeRateSynchronizer = ExchangeRateSynchronizer(widget.store);

    final exchangeRateRepository = ExchangeRateRepositoryImpl(
      exchangeRateStorage, exchangeRateSynchronizer,
    );

    final exchangeRateFetcher = ExchangeRateFetcher(
      exchangeRateRepository,
    );

    final currencySettingsService = CurrencySettingsServiceImpl(
      currencySettingsRepository,
    );

    final categorySettingsService = CategorySettingsServiceImpl(
      categorySettingsRepository,
    );

    final languageSettingsService = LanguageSettingsServiceImpl(
      languageSettingsRepository,
      eventService,
    );


    final exchangeRateService = ExchangeRateServiceImpl(
      currencySettingsService,
      exchangeRateFetcher,
    );

    final firebaseBalanceAdapter = FirebaseBalanceAdapter(userId: widget.user?.uid ?? "");
    final balanceDataRepo = BalanceDataRepositoryImpl(
        adapter: firebaseBalanceAdapter,
        transactionProcessors: [
          exchangeRateService.addExchangeRatesToTransactions,
        ],
    );

    final balanceDataService = BalanceDataServiceImpl(
      repo: balanceDataRepo,
    );


    final statisticService = StatisticServiceImpl(
        balanceDataService: balanceDataService,
        exchangeRateService: exchangeRateService,
        algorithmService: context.read<AlgorithmService>(),
    );


    final budgetRepository = BudgetRepositoryImpl(
      adapter: FirebaseBudgetAdapter(widget.user?.uid ?? ""),
    );

    final budgetService = BudgetServiceImpl(repository: budgetRepository);
    final pinCodeService = PinCodeService(context.read<AuthenticationService>());

    _container.registerProvidableService<ICategoryService>(categoryService);
    _container.registerProvidableService<ICurrencySettingsService>(currencySettingsService);
    _container.registerProvidableService<ICategorySettingsService>(categorySettingsService);
    _container.registerProvidableService<ILanguageSettingsService>(languageSettingsService);
    _container.registerProvidableService<IBalanceDataService>(balanceDataService);
    _container.registerProvidableService<IExchangeRateService>(exchangeRateService);
    _container.registerProvidableService<IStatisticsService>(statisticService);
    _container.registerProvidableService<IBudgetService>(budgetService);
    _container.registerProvidableService<PinCodeService>(pinCodeService);


    _serviceWidget = _container.build(context, widget.child);
  }

  @override
  Widget build(BuildContext context) {
    // print("Rebuild: ");
    // print(widget.user?.uid);
    return _serviceWidget;
  }

  @override
  void dispose() {
    settingsStorage?.dispose();
    _container.dispose();
    super.dispose();
  }
}
