class MainBudgetException implements Exception {
  final String message;

  MainBudgetException(this.message);
}

class MainBudgetAlreadyExistsException extends MainBudgetException {
  MainBudgetAlreadyExistsException(String id) : super("MainBudget with id $id already exists");
}

class MainBudgetNotFoundException extends MainBudgetException {
  MainBudgetNotFoundException(String id) : super("MainBudget with id $id does not exists");
}

class MainBudgetTimespanOverlapsException extends MainBudgetException {
  MainBudgetTimespanOverlapsException(String id) : super("MainBudget with id $id overlaps with an other MainBudget");
}
