import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/models/currency.dart';

class DefaultValues{
  final num amount;
  final String name;
  final Currency currency;
  final Category? category;
  final String date;
  final RepeatConfiguration repeatConfiguration;
  
  const DefaultValues({
    required this.amount,
    required this.name,
    required this.currency,
    required this.category,
    required this.date,
    required this.repeatConfiguration,
  });
}
