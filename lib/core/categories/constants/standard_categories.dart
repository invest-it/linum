import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/generated/translation_keys.g.dart';

final standardCategories = <String, Category>{
  "income": Category(
    label: translationKeys.settingsScreen.standardIncomeSelector.salary,
    id: "income",
    icon: Icons.work_rounded,
    entryType: EntryType.income,
  ),
  "allowance": Category(
    label: translationKeys.settingsScreen.standardIncomeSelector.allowance,
    id: "allowance",
    icon: Icons.savings_rounded,
    entryType: EntryType.income,
  ),
  "sidejob": Category(
    label: translationKeys.settingsScreen.standardIncomeSelector.sidejob,
    id: "sidejob",
    icon: Icons.add_business_rounded,
    entryType: EntryType.income,
  ),
  "investments": Category(
    label: translationKeys.settingsScreen.standardIncomeSelector.investments,
    id: "investments",
    icon: Icons.auto_graph_rounded,
    entryType: EntryType.income,
  ),
  "childsupport": Category(
      label: translationKeys.settingsScreen.standardIncomeSelector.childsupport,
      id: "childsupport",
      icon: Icons.family_restroom_rounded,
      entryType: EntryType.income,
  ),
  "interest": Category(
      label: translationKeys.settingsScreen.standardIncomeSelector.interest,
      id: "interest",
      icon: Icons.attach_money_rounded,
      entryType: EntryType.income,
  ),
  "food": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.food,
    id: "food",
    icon: Icons.local_dining_rounded,
  ),
  "freetime": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.freetime,
    id: "freetime",
    icon: Icons.beach_access_rounded,
  ),
  "house": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.house,
    id: "house",
    icon: Icons.home_rounded,
  ),
  "lifestyle": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.lifestyle,
    id: "lifestyle",
    icon: Icons.local_fire_department_outlined,
  ),
  "car": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.car,
    id: "car",
    icon: Icons.directions_car_rounded,
  ),
  "misc-income": Category(
    label: translationKeys.settingsScreen.standardIncomeSelector.misc,
    id: "misc-income",
    icon: Icons.inventory_2,
    entryType: EntryType.income,
  ),
  "misc-expense": Category(
    label: translationKeys.settingsScreen.standardExpenseSelector.misc,
    id: "misc-expense",
    icon: Icons.inventory_2,
  ),
};


Category? getCategory(String? name, {EntryType? entryType}) {
  final category = standardCategories[name];
  if (entryType == null) {
    return category;
  }
  if (category?.entryType != entryType) {
    return null;
  }
  return category;
}
