import 'dart:async';

import 'package:flutter/material.dart';

class SubscriptionHandler with ChangeNotifier {
  final List<StreamSubscription> _subscriptions = [];

  void subscribe<T>(Stream<T> stream, void Function(T event) callback) {
    _subscriptions.add(stream.listen(callback));
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    for (final value in _subscriptions) {
      value.cancel();
    }
  }
}
