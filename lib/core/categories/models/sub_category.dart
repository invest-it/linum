import 'package:linum/core/categories/models/category.dart';

class SubCategory extends Category {
  final String parentId;

  SubCategory({
    required this.parentId,
    required super.id,
    required super.label,
    super.isIncome = false,
  });
}
