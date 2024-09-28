import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';

class DefaultValues{
  final num amount;
  final String name;
  final Currency currency;
  final Category expenseCategory;
  final Category incomeCategory;
  final String date;
  final RepeatConfiguration repeatConfiguration;
  
  const DefaultValues({
    required this.amount,
    required this.name,
    required this.currency,
    required this.expenseCategory,
    required this.incomeCategory,
    required this.date,
    required this.repeatConfiguration,
  });

}
