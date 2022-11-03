//  Category Map - Mapper that ties all Categories Specified in settings_enums.dart to their specifications in the respective files and outputs a map
//
//  Author: damattl
//  Co-Author: SoTBurst
//

import 'package:collection/collection.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/models/entry_currency.dart';

/// New type of Map where the [] operator was overwritten for better access of
/// the underlying values via String keys
/// Use .fromMap() constructor if you want to assign a predefined list
class CategoryMapCurrency<T> extends DelegatingMap<T, EntryCurrency> {
  final Map<T, EntryCurrency> _map;
  CategoryMapCurrency() : this._(<T, EntryCurrency>{});
  CategoryMapCurrency._(super.map) : _map = map;

  factory CategoryMapCurrency.fromMap(Map<T, EntryCurrency> map) {
    return CategoryMapCurrency._(map);
  }

  @override
  EntryCurrency? operator [](Object? key) {
    if (key is String) {
      final StandardCurrency? standardCurrency =
          EnumToString.fromString(StandardCurrency.values, key);
      return _map[standardCurrency];
    } else {
      return _map[key];
    }
  }
}
