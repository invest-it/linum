import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:linum/types/change_notifier_provider_builder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProviderBuilder {
  final List<SingleChildWidget> _providers = <SingleChildWidget>[];
  final BuildContext _context;
  bool _testing = false;
  Key? _key;
  Widget? _child;

  MultiProviderBuilder({
    required BuildContext context,
    required Widget? child,
  }) : _context = context, _child = child;

  MultiProviderBuilder isTesting({bool testing = false}) {
    _testing = testing;
    return this;
  }

  MultiProviderBuilder useProvider<P extends ChangeNotifier>(
      ChangeNotifierProviderBuilder builder,
      ) {
    SingleChildWidget? provider;

    try {
      final service = Provider.of<P>(_context);
      provider = ChangeNotifierProvider<P>.value(value: service);
    } on ProviderNullException catch(_) {
      provider = builder(_context, testing: _testing);
    } on ProviderNotFoundException catch(_) {
      provider = builder(_context, testing: _testing);
    }

    // TODO: This piece of code needs a very thorough documentation

    _providers.add(provider); // TODO: Check if this is always true
    return this;
  }

  MultiProviderBuilder useExistingProvider<P extends ChangeNotifier>() {
    developer.log("Provider has Type: $P");
    if (P == ChangeNotifier) {
      developer.log("Generic type argument missing!");
      return this;
    }

    try {
      final service = Provider.of<P>(_context);
      final provider = ChangeNotifierProvider<P>.value(value: service);
      _providers.add(provider);
    } on ProviderNullException catch(_) {
      developer.log("Provider of ${P.runtimeType} does not exist in the Widget-Tree");
    }

    return this;
  }

  MultiProviderBuilder addProvider(SingleChildWidget provider) {
    _providers.add(provider);
    return this;
  }

  MultiProviderBuilder addProxyProvider<T, R extends ChangeNotifier?>
      (ChangeNotifierProxyProvider<T, R> provider) {
    _providers.add(provider);
    return this;
  }

  MultiProviderBuilder withKey(String key) {
    _key = Key(key);
    return this;
  }

  MultiProvider build() {
    return MultiProvider(providers: _providers, key: _key, child: _child,);
  }
}

/*
*
* return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<EnterScreenProvider>(
                          create: (_) {
                            return EnterScreenProvider(
                              balanceData: balanceData,
                              editMode: true,
                            );
                          },
                        ),
                        ChangeNotifierProvider<BalanceDataProvider>.value(
                          value: balanceDataProvider,
                        ),
                        ChangeNotifierProvider<AccountSettingsProvider>.value(
                          value: accountSettingsProvider,
                        ),
                      ],
                      child: const EnterScreen(),
                    );
*
*
* */



