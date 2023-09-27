import 'dart:async';

import 'package:flutter/material.dart';


/// Classes that implement the subscription handler,
/// can listen to a single stream without the need to handle stream cancellation
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
