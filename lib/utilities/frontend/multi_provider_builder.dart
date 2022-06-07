//  MultiProviderBuilder - used to easily provide multiple providers
//
//  Author: damattl
//

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
  final Widget? _child;

  MultiProviderBuilder({
    required BuildContext context,
    required Widget? child,
  }) : _context = context, _child = child;

  MultiProviderBuilder isTesting({bool testing = false}) {
    _testing = testing;
    return this;
  }


  /// Add a Provider to the MultiProvider via a ChangeNotifierProviderBuilder-Method. <br>
  /// <br>
  /// If a provider of this type already exists in the widget-tree it will be
  /// used instead. <br>
  /// <br>
  /// If no generic type argument is specified, the method will default to using
  /// the provided build-Method. <br>
  /// <br>
  /// **IMPORTANT:** Without a generic type argument the function cannot check
  /// if a provider of the same type already exists.
  /// A duplicate Provider might crash the app! <br>
  /// <br>
  /// Be careful with ProxyProviders, because they depend on other providers
  /// which might no be initialized yet.
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

    _providers.add(provider);
    return this;
  }

  /// Add a existing Provider to the MultiProvider. <br>
  /// <br>
  /// The generic type argument **IS REQUIRED** - otherwise the function will be skipped. <br>
  /// <br>
  /// If the Provider does not already exist in the widget-tree, the function will be skipped.
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

  /// Add a entirely new Provider to the MultiProvider. <br>
  /// <br>
  /// The generic type argument is not required.
  MultiProviderBuilder addProvider<T extends ChangeNotifier>(ChangeNotifierProvider<T> provider) {
    _providers.add(provider);
    return this;
  }

  /// Add a entirely new ProxyProvider to the MultiProvider. <br>
  /// <br>
  /// The generic type argument is not required.
  /// <br>
  /// Will throw an error if no ChangeNotifier of the second generic type
  /// argument can be found.
  MultiProviderBuilder addProxyProvider<T, R extends ChangeNotifier?>
      (ChangeNotifierProxyProvider<T, R> provider) {
    _providers.add(provider);
    return this;
  }

  /// Set the Key for the MultiProvider.
  ///
  /// Using the Method twice will override the previous key.
  MultiProviderBuilder setKey(String key) {
    _key = Key(key);
    return this;
  }

  /// Call this method to build the MultiProvider after setting up its configuration
  MultiProvider build() {
    return MultiProvider(providers: _providers, key: _key, child: _child,);
  }
}







