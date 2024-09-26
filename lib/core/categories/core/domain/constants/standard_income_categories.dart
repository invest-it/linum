import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/generated/translation_keys.g.dart';

final standardIncomeCategories = Map<String, Category>.unmodifiable(
  <String, Category> {
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
    "misc-income": Category(
      label: translationKeys.settingsScreen.standardIncomeSelector.misc,
      id: "misc-income",
      icon: Icons.inventory_2,
      entryType: EntryType.income,
      suggestable: false,
    ),
    "none-income": Category(
      label: translationKeys.settingsScreen.standardsSelectorNone,
      id: "none-income",
      icon: Icons.check_box_outline_blank_rounded,
      entryType: EntryType.income,
      suggestable: false,
    ),
  },
);
