import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/categories/core/presentation/widgets/category_list_tile.dart';
import 'package:linum/core/categories/settings/presentation/category_settings_service.dart';
import 'package:linum/core/categories/settings/presentation/utils/show_change_standard_category_action_lip.dart';
import 'package:provider/provider.dart';

class StandardCategorySelector extends StatelessWidget {
  final EntryType entryType;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String buttonTitle;

  const StandardCategorySelector({
    super.key,
    required this.entryType,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showChangeStandardCategoryBottomSheet(
            context,
            entryType: entryType,
            title: title,
        );
      },
      child: Selector<ICategorySettingsService, Category?>(
        selector: (_, settings) => settings.getEntryCategory(entryType),
        builder: (context, category, _) {
          return CategoryListTile(
            labelTitle:buttonTitle,
            category: category,
            trailingIcon: icon,
            trailingIconColor: iconColor,
          );
        },
      ),
    );
  }
}
