//  Settings Screen Standard Category - The selector for the standard categories
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/settings/presentation/widgets/standard_category_selector.dart';
import 'package:linum/generated/translation_keys.g.dart';

class StandardCategorySelectors extends StatefulWidget {
  const StandardCategorySelectors({super.key});

  @override
  State<StandardCategorySelectors> createState() => _StandardCategorySelectorsState();
}

class _StandardCategorySelectorsState extends State<StandardCategorySelectors> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StandardCategorySelector(
          entryType: EntryType.income,
          icon: Icons.north_east,
          iconColor: Colors.green,
          buttonTitle: tr(translationKeys.settingsScreen.standardIncomeSelector.labelTitle),
          title: tr(translationKeys.actionLip.standardCategory.income.labelTitle),
        ),
        StandardCategorySelector(
          entryType: EntryType.expense,
          icon: Icons.south_east,
          iconColor: Colors.redAccent,
          buttonTitle: tr(translationKeys.settingsScreen.standardExpenseSelector.labelTitle),
          title: tr(translationKeys.actionLip.standardCategory.expenses.labelTitle),
        ),
      ],
    );
  }
}
