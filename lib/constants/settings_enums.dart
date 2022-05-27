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
  miscellaneous,
}

enum StandardCategoryExpense {
  none,
  food,
  freeTime,
  house,
  lifestyle,
  car,
  miscellaneous,
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
