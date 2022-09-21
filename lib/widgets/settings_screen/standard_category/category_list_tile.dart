import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/entry_category.dart';

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.labelTitle,
    required this.defaultLabel,
  });
  final String labelTitle;
  final String defaultLabel;
  final EntryCategory? category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        labelTitle +
            // Translates the value from firebase
            tr(category?.label ?? defaultLabel),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: const Icon(
        Icons.north_east,
        color: Color(0xFF97BC4E),
      ),
      leading: Icon(
        category?.icon ?? Icons.error,
      ),
    );
  }

}
