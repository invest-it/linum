import 'package:flutter/material.dart';

class Category {
  final String id; // Standard Categories got a name, user defined categories an id
  final String label;
  final IconData? icon;
  final bool isIncome;

  const Category({required this.id, required this.label, this.icon, this.isIncome = false});
}

class SubCategory extends Category {
  final String parentId;

  SubCategory({
    required this.parentId,
    required super.id,
    required super.label,
    super.isIncome = false,
  });
}
