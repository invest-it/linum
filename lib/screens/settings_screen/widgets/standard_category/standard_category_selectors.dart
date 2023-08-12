//  Settings Screen Standard Category - The selector for the standard categories
//
//  Author: aronzimmermann
//  Co-Author: SoTBurst, NightmindOfficial
//  Refactored: TheBlueBaron

import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/screens/settings_screen/widgets/standard_category/standard_category_selector.dart';

class StandardCategorySelectors extends StatefulWidget {
  const StandardCategorySelectors({super.key});

  @override
  State<StandardCategorySelectors> createState() => _StandardCategorySelectorsState();
}

class _StandardCategorySelectorsState extends State<StandardCategorySelectors> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        StandardCategorySelector(categoryType: EntryType.expense),
        StandardCategorySelector(categoryType: EntryType.income),
      ],
    );
  }
}
