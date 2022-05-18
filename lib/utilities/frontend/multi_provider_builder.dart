import 'package:flutter/material.dart';
import 'package:linum/types/change_notifier_provider_builder.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProviderBuilder {
  final List<SingleChildWidget> _providers = <SingleChildWidget>[];
  final BuildContext _context;
  bool _testing = false;
  Key? _key;

  MultiProviderBuilder({required BuildContext context}) : _context = context;

  MultiProviderBuilder isTesting({bool testing = false}) {
    _testing = testing;
    return this;
  }

  MultiProviderBuilder useProvider<P extends ChangeNotifier, BuildableProvider>(
      ChangeNotifierProviderBuilder builder,
      ) {
    SingleChildWidget? provider;
    try {
      final service = Provider.of<P>(_context);
      provider = ChangeNotifierProvider<P>.value(value: service);
    } on ProviderNullException catch(_) {
      provider = builder(_context, testing: _testing);
    }


    _providers.add(provider); // TODO: Check if this is always true
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
    return MultiProvider(providers: _providers, key: _key,);
  }
}





