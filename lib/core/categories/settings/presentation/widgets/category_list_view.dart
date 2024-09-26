import 'package:flutter/material.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/presentation/widgets/category_list_tile.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class CategoryListView extends StatelessWidget {
  final List<Category> categories;
  final String defaultCategoryId;
  final void Function(Category category) onCategorySelection;

  const CategoryListView({
    required this.categories,
    required this.defaultCategoryId,
    required this.onCategorySelection,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          bottom: context.proportionateScreenHeightFraction(ScreenFraction.onefifth),
        ),
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];

          return CategoryListTile(
            category: category,
            selected: category.id == defaultCategoryId,
            onTap: () {
              onCategorySelection(category);
            },
          );
        },
      ),
    );
  }
}
