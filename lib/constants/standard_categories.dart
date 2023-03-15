import 'package:flutter/material.dart';
import 'package:linum/models/category.dart';

const standardCategories = <String, Category>{
  "income": Category(
    label: "settings_screen.standard-income-selector.salary",
    id: "income",
    icon: Icons.work_rounded,
    isIncome: true,
  ),
  "allowance": Category(
    label: "settings_screen.standard-income-selector.allowance",
    id: "allowance",
    icon: Icons.savings_rounded,
    isIncome: true,
  ),
  "sidejob": Category(
    label: "settings_screen.standard-income-selector.sidejob",
    id: "sidejob",
    icon: Icons.add_business_rounded,
    isIncome: true,
  ),
  "investments": Category(
    label: "settings_screen.standard-income-selector.investments",
    id: "investments",
    icon: Icons.auto_graph_rounded,
    isIncome: true,
  ),
  "childsupport": Category(
      label: "settings_screen.standard-income-selector.childsupport",
      id: "childsupport",
      icon: Icons.family_restroom_rounded,
      isIncome: true,
  ),
  "interest": Category(
      label: "settings_screen.standard-income-selector.interest",
      id: "interest",
      icon: Icons.attach_money_rounded,
      isIncome: true,
  ),
  "food": Category(
    label: "settings_screen.standard-expense-selector.food",
    id: "food",
    icon: Icons.local_dining_rounded,
  ),
  "freetime": Category(
    label: "settings_screen.standard-expense-selector.freetime",
    id: "freetime",
    icon: Icons.beach_access_rounded,
  ),
  "house": Category(
    label: "settings_screen.standard-expense-selector.house",
    id: "house",
    icon: Icons.home_rounded,
  ),
  "lifestyle": Category(
    label: "settings_screen.standard-expense-selector.lifestyle",
    id: "lifestyle",
    icon: Icons.local_fire_department_outlined,
  ),
  "car": Category(
    label: "settings_screen.standard-expense-selector.car",
    id: "car",
    icon: Icons.directions_car_rounded,
  ),
  "misc-income": Category(
    label: "settings_screen.standard-income-selector.misc",
    id: "misc-income",
    icon: Icons.inventory_2,
    isIncome: true,
  ),
  "misc-expense": Category(
    label: "settings_screen.standard-expense-selector.misc",
    id: "misc-expense",
    icon: Icons.inventory_2,
  ),
};
