//  Standard Expense Categories - Contains Styles of EntryCategories for all Enums specified in settings_enums.dart
//
//  Author: NightmindOfficial, thebluebaronx
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/material.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/types/category_map.dart';

/// List of Categories the User can declare as a Standard when tracking an EXPENSE.
/// e.g. Söncke usually incurs expenses for WATER, therefore he can choose FOOD
/// as his Standard Category for Expenses so he does not have to choose FOOD as a category when adding as an expense.
final CategoryMap<StandardCategoryExpense> standardExpenseCategories =
    CategoryMap.fromMap({
  StandardCategoryExpense.none: const EntryCategory(
    label: 'settings_screen.standards-selector-none',
    icon: Icons.check_box_outline_blank_rounded,
  ),
  StandardCategoryExpense.food: const EntryCategory(
    label: "settings_screen.standard-expense-selector.food",
    icon: Icons.local_dining_rounded,
  ),
  StandardCategoryExpense.freeTime: const EntryCategory(
    label: "settings_screen.standard-expense-selector.freetime",
    icon: Icons.beach_access_rounded,
  ),
  StandardCategoryExpense.house: const EntryCategory(
    label: "settings_screen.standard-expense-selector.house",
    icon: Icons.home_rounded,
  ),
  StandardCategoryExpense.lifestyle: const EntryCategory(
    label: "settings_screen.standard-expense-selector.lifestyle",
    icon: Icons.local_fire_department_outlined,
  ),
  StandardCategoryExpense.car: const EntryCategory(
    label: "settings_screen.standard-expense-selector.car",
    icon: Icons.directions_car_rounded,
  ),
  StandardCategoryExpense.miscellaneous: const EntryCategory(
    label: "settings_screen.standard-expense-selector.misc",
    icon: Icons.inventory_2,
  ),
});
