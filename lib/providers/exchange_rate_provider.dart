import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/cupertino.dart';
import 'package:linum/models/currency.dart';
import 'package:linum/models/exchange_rate_info.dart';
import 'package:linum/models/exchange_rates_for_date.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/objectbox.g.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/types/change_notifier_provider_builder.dart';
import 'package:linum/utilities/backend/exchange_rate_repository.dart';
import 'package:provider/provider.dart';

class ExchangeRateProvider extends ChangeNotifier {
  late final ExchangeRateRepository _repository;
  final Store _store;
  late Currency _standardCurrency;
  ExchangeRateProvider(BuildContext context, this._store) {
    _repository = ExchangeRateRepository(_store);
    final settings = Provider.of<AccountSettingsProvider>(context, listen: false);
    _standardCurrency = settings.getStandardCurrency();
  }

  Currency get standardCurrency => _standardCurrency;

  Future addExchangeRatesToTransactions(List<Transaction> transactions) async {
    // Get dates for transactions that need exchange rates (currency != standardCurrency)
    final dates = transactions
        .where((transaction) => transaction.currency != _standardCurrency.name)
        .map((e) => e.time.toDate()).toList();
    final ratesMap = await _repository.getExchangeRatesForDates(dates);

    if (ratesMap.isEmpty) {
      return;
    }

    ExchangeRatesForDate lastSuccessful = ratesMap.values.first;

    for (final transaction in transactions) {
      if (transaction.currency == _standardCurrency.name) {
        continue;
      }

      final dateTime = transaction.time.toDate();
      final key = DateTime(dateTime.year, dateTime.day).millisecondsSinceEpoch;
      var exchangeRates = ratesMap[key];

      if (exchangeRates == null || exchangeRates.rates == null) {
        // TODO: Handle null case
        exchangeRates = lastSuccessful;
      } else {
        lastSuccessful = exchangeRates;
      }

      final exchangeRate = exchangeRates.rates?[transaction.currency];

      // TODO: Check if entry exists and re-fetch
      // TODO: Make call to another API to get rate
      // TODO: If the exchange rate is not found but needed it should be guessed
      if (exchangeRate != null) {
        transaction.rateInfo = ExchangeRateInfo(
            int.parse(exchangeRate),
            firestore.Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
            isOtherDate: key != exchangeRates.date,
        );
        continue;
      }


    }
  }

  void update(AccountSettingsProvider settings) {
    if (settings.getStandardCurrency() == _standardCurrency) {
      _standardCurrency = settings.getStandardCurrency();
    }
  }

  static ChangeNotifierProviderBuilder builder(Store store) {
        return (context, {bool testing = false}) {
          return ChangeNotifierProxyProvider<AccountSettingsProvider, ExchangeRateProvider>(
            key: const Key("ExchangeRateChangeNotifierProvider"),
            create: (ctx) {
              return ExchangeRateProvider(ctx, store);
            },
            update: (ctx, settings, provider) {
              if (provider != null) {
                return provider..update(settings);
              } else {
                return ExchangeRateProvider(context, store);
              }
            },
            lazy: false,
          );
    };
  }

}
