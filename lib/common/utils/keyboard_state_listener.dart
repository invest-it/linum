enum KeyboardStateEvent {
  // open, // TODO: Not implemented
  // closed, // TODO: Not implemented
  changed,
}

class KeyboardStateListener {
  double _keyboardSize = 0.0;
  int _counter = 0;
  final Map<int, (KeyboardStateEvent, void Function())> _subscriptions = {};

  void inform(double keyboardSize) {
    if (_keyboardSize == keyboardSize) {
      return;
    }
    _keyboardSize = keyboardSize;

    for (final element in _subscriptions.values) {
      if (element.$1 == KeyboardStateEvent.changed) {
        element.$2.call();
      }
    }
  }

  int subscribe(KeyboardStateEvent event, void Function() callback) {
    _subscriptions[_counter] = (event, callback);
    _counter ++;
    return _counter - 1;
  }

  void unsubscribe(int subscriptionId) {
    _subscriptions.remove(subscriptionId);
  }

}
