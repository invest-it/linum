import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';

// TODO: Currently unused, may be deleted
class SubCategory extends Category {
  final String parentId;

  SubCategory({
    required this.parentId,
    required super.id,
    required super.label,
    super.entryType = EntryType.expense,
  });
}
