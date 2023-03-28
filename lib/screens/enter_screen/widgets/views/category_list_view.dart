import 'package:flutter/material.dart';
import 'package:linum/common/widgets/category_list_tile.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key, required this.categories});

  final List<Category> categories;
  
  @override
  Widget build(BuildContext context) {
    final formViewModel = context.read<EnterScreenFormViewModel>();
    
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
            selected: formViewModel.data.category?.id == category.id,
            onTap: () {
              formViewModel.data = formViewModel.data.copyWith(
                category: category,
              );
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
