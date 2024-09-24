import 'package:collection/collection.dart';


class DateTimeMap<K, V> extends DelegatingMap<K, V> {
  final Map<K, V> _map;
  DateTimeMap() : this._(<K, V>{});
  DateTimeMap._(super.map)
      : _map = map;




  static DateTimeMap<K, V>? fromDynamicMap<K, V>(dynamic dynamicMap, {
    required K Function(dynamic) keyMapper,
    required V Function(dynamic) valueMapper,
  }) {
    if (dynamicMap == null) {
      return null;
    }
    final rawMap = dynamicMap as Map<String, dynamic>;
    final map = rawMap.map((key, value) => MapEntry<K, V>(keyMapper(key), valueMapper(value)));
    return DateTimeMap.fromMap(map);
  }

  factory DateTimeMap.fromMap(Map<K, V> map) {
    return DateTimeMap._(map);
  }

  V? get(Object? key) {
    return this[key];
  }

  @override
  V? operator [](Object? key) {
    if (key is DateTime) {
      return _map[key.millisecondsSinceEpoch.toString()];
    }
    if (key is String) {
      return _map[key];
    }
    return null;
  }
}
