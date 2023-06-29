import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';

class Category {
  final String id; // Standard Categories got a name, user defined categories an id
  final String label;
  final IconData? icon;
  final EntryType entryType;

  const Category({
    required this.id,
    required this.label,
    this.icon,
    this.entryType = EntryType.expense,
  });

  @override
  String toString() {
    return 'Category(id: $id, label: $label, icon: $icon, entryType: $entryType)';
  }

}
