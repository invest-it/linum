import 'package:linum/common/utils/date_time_extensions.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/stats/domain/models/expense_statistic.dart';
import 'package:linum/core/stats/domain/models/income_statistic.dart';

// TODO: Should write a test for this
IncomeStatistics generateSerialIncomeStatistics(List<Transaction> transactions) {
  final statBuilder = IncomeStatisticsBuilder();
  for (final s in transactions) {
    if (!s.isIncome()) {
      continue;
    }
    if (s.repeatId == null) { // If transaction is not a serialTransaction
      continue;
    }
    if (s.date.isInFuture()) {
      statBuilder.addUpcoming(s.amountInStandardCurrency);
    } else {
      statBuilder.addCurrent(s.amountInStandardCurrency);
    }

  }
  return statBuilder.build();
}

// TODO: Should write a test for this
ExpenseStatistics generateExpenseStatisticsForCategory(List<Transaction> transactions, String category) {
  final statBuilder = ExpenseStatisticsBuilder();
  for (final t in transactions) {
    if (t.isIncome()) {
      continue;
    }
    if (t.category != category) {
      continue;
    }
    if (t.date.isInFuture()) {
      statBuilder.addUpcoming(t.amountInStandardCurrency);
    } else {
      statBuilder.addCurrent(t.amountInStandardCurrency);
    }
  }
  return statBuilder.build();
}

// TODO: Should write a test for this
Map<String, ExpenseStatistics> generateExpenseStatisticsForCategories(List<Transaction> transactions, Set<String> categories) {
  final catToBuilder = <String, ExpenseStatisticsBuilder>{};
  for (final cat in categories) {
    catToBuilder[cat] ??= ExpenseStatisticsBuilder();
  }

  for (final t in transactions) {
    if (t.isIncome()) {
      continue;
    }
    if (!categories.contains(t.category)) {
      continue;
    }
    if (t.date.isInFuture()) {
      catToBuilder[t.category]?.addUpcoming(t.amountInStandardCurrency);
    } else {
      catToBuilder[t.category]?.addCurrent(t.amountInStandardCurrency);
    }
  }
  return catToBuilder.map((k, v) => MapEntry(k, v.build()));
}
