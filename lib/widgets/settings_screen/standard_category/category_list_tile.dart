import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/category.dart';
import 'package:linum/utilities/frontend/translate_catogory.dart';
// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class CategoryListTile extends StatelessWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.labelTitle,
    required this.defaultLabel,
    required this.trailingIconColor,
    required this.trailingIcon,
  });
  final String labelTitle;
  final String defaultLabel;
  final Category? category;
  final IconData trailingIcon;
  final Color trailingIconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        labelTitle +
            // Translates the value from firebase
            translateCategory(category),
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Icon(
        trailingIcon,
        color: trailingIconColor,
      ),
      leading: Icon(
        category?.icon ?? Icons.error,
      ),
    );
  }
}
