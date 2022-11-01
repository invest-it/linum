import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class DateTimeMap<K, V> extends DelegatingMap<K, V> {
  final Map<K, V> _map;
  DateTimeMap() : this._(<K, V>{});
  DateTimeMap._(super.map)
      : _map = map;

  factory DateTimeMap.fromMap(Map<K, V> map) {
    return DateTimeMap._(map);
  }

  @override
  V? operator [](Object? key) {
    if (key is DateTime) {
      return _map[Timestamp.fromDate(key).millisecondsSinceEpoch.toString()];
    }
    if (key is String) {
      return _map[key];
    }
    return null;
  }
}
