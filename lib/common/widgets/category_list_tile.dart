import 'package:flutter/material.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/categories/utils/translate_category.dart';


class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    this.labelTitle,
    this.trailingIconColor,
    this.trailingIcon,
    this.onTap,
    this.selected = false,
  });
  final String? labelTitle;
  final Category? category;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final void Function()? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${labelTitle ?? ""}${translateCategory(category)}",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: trailingIcon != null ? Icon(
        trailingIcon,
        color: trailingIconColor,
      ) : null,
      leading: Icon(
        category?.icon ?? Icons.error,
      ),
      onTap: onTap,
      selected: selected,
    );
  }
}
