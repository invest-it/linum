//  Settings Enums - Contains all enums used in the Settings Screen (Different Settings)
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)


enum StandardCategoryIncome {
  none,
  income,
  allowance,
  sideJob,
  investments,
  childSupport,
  interest,
  miscellaneous;

  bool equals(String? valueStr) {
    return "StandardCategoryIncome.${valueStr ?? "None"}" == toString();
  }
}

enum StandardCategoryExpense {
  none,
  food,
  freeTime,
  house,
  lifestyle,
  car,
  miscellaneous;

  bool equals(String? valueStr) {
    return "StandardCategoryExpense.${valueStr ?? "None"}" == toString();
  }
}

enum StandardAccount {
  none,
  debit,
  credit,
  cash,
  depot,
}

enum RepeatDuration {
  none,
  daily,
  weekly,
  monthly,
  // TODO implement custom repeat
  // custom,
}
