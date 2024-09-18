
class BudgetException implements Exception {
  final String message;

  BudgetException(this.message);
}

class BudgetAlreadyExistsException extends BudgetException {
  BudgetAlreadyExistsException(String id) : super("Budget with id $id already exists");
}

class BudgetNotFoundException extends BudgetException {
  BudgetNotFoundException(String id) : super("Budget with id $id does not exists");
}
