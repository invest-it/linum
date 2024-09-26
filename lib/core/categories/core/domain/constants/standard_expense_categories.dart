import 'package:flutter/material.dart';
import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/generated/translation_keys.g.dart';

final standardExpenseCategories = Map<String, Category>.unmodifiable(
    <String, Category> {
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

      "misc-expense": Category(
        label: translationKeys.settingsScreen.standardExpenseSelector.misc,
        id: "misc-expense",
        icon: Icons.inventory_2,
        suggestable: false,
      ),
      "none-expense": Category(
        label: translationKeys.settingsScreen.standardsSelectorNone,
        id: "none-expense",
        icon: Icons.check_box_outline_blank_rounded,
        suggestable: false,
      ),
    },
);
