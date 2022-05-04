import 'package:collection/collection.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_category.dart';

/// New type of Map where the [] operator was overwritten for better access of
/// the underlying values via String keys
/// Use .fromMap() constructor if you want to assign a predefined list
class CategoryMap<T> extends DelegatingMap<T, EntryCategory> {
  final Map<T, EntryCategory> _map;
  CategoryMap() : this._(<T, EntryCategory>{});
  CategoryMap._(Map<T, EntryCategory> map) : _map = map,  super(map);

  factory CategoryMap.fromMap(Map<T, EntryCategory> map) {
    return CategoryMap._(map);
  }

  @override
  EntryCategory? operator [](Object? key) {
    if (key is String) {
      if (T == StandardCategoryExpense) {
        final StandardCategoryExpense? standardCategoryExpense = EnumToString
            .fromString(StandardCategoryExpense.values, key);
        return _map[standardCategoryExpense];
      }
      if (T == StandardCategoryIncome) {
        final StandardCategoryIncome? standardCategoryIncome = EnumToString
            .fromString(StandardCategoryIncome.values, key);
        return _map[standardCategoryIncome];
      }
      return null;
    } else {
      return _map[key];
    }
  }
}
