import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';

typedef CategoryMap = Map<String, Category>;

extension CategoryMapExtensions on CategoryMap {
  Category? getCategory(String? name, {EntryType? entryType}) {
    final category = this[name];
    if (entryType == null) {
      return category;
    }
    if (category?.entryType != entryType) {
      return null;
    }
    return category;
  }
}

typedef CategoryMapIterable = Iterable<MapEntry<String, Category>>;
