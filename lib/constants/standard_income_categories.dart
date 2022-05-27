//  Standard Income Categories - Contains Styles of EntryCategories for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/types/category_map.dart';

/// List of Categories the User can declare as a Standard when tracking INCOME.
/// e.g. Otis works as a freelancer, so the income he tracks is mostly in the category SIDE JOB, therefore he can choose SIDE JOB
/// as his Standard Category for Income so he does not have to choose SIDE JOB as a category when adding an income.
// TODO: RENAME? => StandardIncomeCategories
final CategoryMap<StandardCategoryIncome> standardCategoryIncomes =
    CategoryMap.fromMap({
  StandardCategoryIncome.none: const EntryCategory(
    label: "settings_screen/standards-selector-none",
    icon: Icons.check_box_outline_blank_rounded,
  ),
  StandardCategoryIncome.income: const EntryCategory(
    label: "settings_screen/standard-income-selector/salary",
    icon: Icons.work_rounded,
  ),
  StandardCategoryIncome.allowance: const EntryCategory(
    label: "settings_screen/standard-income-selector/allowance",
    icon: Icons.savings_rounded,
  ),
  StandardCategoryIncome.sideJob: const EntryCategory(
    label: "settings_screen/standard-income-selector/sidejob",
    icon: Icons.add_business_rounded,
  ),
  StandardCategoryIncome.investments: const EntryCategory(
    label: "settings_screen/standard-income-selector/investments",
    icon: Icons.auto_graph_rounded,
  ),
  StandardCategoryIncome.childSupport: const EntryCategory(
    label: "settings_screen/standard-income-selector/childsupport",
    icon: Icons.family_restroom_rounded,
  ),
  StandardCategoryIncome.interest: const EntryCategory(
    label: "settings_screen/standard-income-selector/interest",
    icon: Icons.attach_money_rounded,
  ),
  StandardCategoryIncome.miscellaneous: const EntryCategory(
    label: "settings_screen/standard-income-selector/misc",
    icon: Icons.inventory_2,
  ),
});
