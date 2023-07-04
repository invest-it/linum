
import 'package:flutter/material.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:linum/generated/objectbox/objectbox.g.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ExchangeRateServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  final Store store;
  const ExchangeRateServiceProvider({
    super.key,
    required this.store,
    this.testing = false,
  });

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProxyProvider<AccountSettingsService, ExchangeRateService>(
      key: const Key("ExchangeRateChangeNotifierProvider"),
      create: (ctx) {
        return ExchangeRateService(ctx, store);
      },
      update: (ctx, settings, provider) {
        if (provider != null) {
          return provider..update(settings);
        } else {
          return ExchangeRateService(context, store);
        }
      },
      lazy: false,
      child: child,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return build(context, child: child);
  }

}
