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
  late AccountSettingsProvider _settings;
  ExchangeRateProvider(BuildContext context, this._store) {
    _repository = ExchangeRateRepository(_store);
    _settings = Provider.of<AccountSettingsProvider>(context, listen: false);


  }

  Currency get standardCurrency => _settings.getStandardCurrency();

  Future addExchangeRatesToTransactions(List<Transaction> transactions) async {
    // Get dates for transactions that need exchange rates (currency != standardCurrency)
    final dates = transactions
        .where((transaction) => transaction.currency != standardCurrency.name)
        .map((e) => e.time.toDate()).toList();
    final ratesMap = await _repository.getExchangeRatesForDates(dates);

    if (ratesMap.isEmpty) {
      return;
    }

    ExchangeRatesForDate lastSuccessful = ratesMap.values.first;

    for (final transaction in transactions) {
      if (transaction.currency == standardCurrency.name) {
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

      // Always compared to EUR
      final transactionCurrencyRate = exchangeRates.rates?[transaction.currency]
        ?? (transaction.currency == "EUR" ? "1" : null); // FOR NOW
      final standardCurrencyRate = exchangeRates.rates?[standardCurrency.name];

      // TODO: Check if entry exists and re-fetch
      // TODO: Make call to another API to get rate
      // TODO: If the exchange rate is not found but needed it should be guessed
      if (transactionCurrencyRate != null) {
        transaction.rateInfo = ExchangeRateInfo(
            num.parse(transactionCurrencyRate),
            num.parse(standardCurrencyRate ?? "1"),
            firestore.Timestamp.fromMillisecondsSinceEpoch(exchangeRates.date),
            isOtherDate: key != exchangeRates.date,
        );
        continue;
      }


    }
  }

  void update(AccountSettingsProvider settings) {
    _settings = settings;
    // TODO: Do this better
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
