import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/models/category.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/constants/standard_currencies.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';

class EnterScreenData {
  final num? amount;
  final String? name;
  final Currency? currency;
  final Category? category;
  final String? date;
  final RepeatConfiguration? repeatConfiguration;
  final String? notes;
  final bool isParsed;

  const EnterScreenData({
    this.amount,
    this.name,
    this.currency,
    this.category,
    this.date,
    this.repeatConfiguration,
    this.notes,
    this.isParsed = false,
  });

  EnterScreenData copyWith({
    num? amount,
    String? name,
    Currency? currency,
    Category? category,
    String? date,
    RepeatConfiguration? repeatConfiguration,
    String? notes,
    bool isParsed = false,
  }) {
    return EnterScreenData(
      amount: amount ?? this.amount,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      date: date ?? this.date,
      repeatConfiguration: repeatConfiguration ?? this.repeatConfiguration,
      notes: notes ?? this.notes,
      isParsed: isParsed,
    );
  }

  EnterScreenData removeCategory() {
    return EnterScreenData(
      amount: amount,
      name: name,
      currency: currency,
      date: date,
      repeatConfiguration: repeatConfiguration,
      notes: notes,
      isParsed: isParsed,
    );
  }

  factory EnterScreenData.fromFormData(EnterScreenFormData formData) {
    final parsed = formData.parsed;
    final options = formData.options;

    final amount = parsed.amount?.value;
    final name = parsed.name?.value;
    final currency = options.currency ?? parsed.currency?.value;

    final category = options.category ?? parsed.category?.value;
    final date = options.date ?? parsed.date?.value;
    final repeatConfiguration = options.repeatConfiguration ?? parsed.repeatInfo?.value;

    return EnterScreenData(
      amount: amount,
      name: name,
      currency: currency,
      category: category,
      date: date,
      repeatConfiguration: repeatConfiguration,
      notes: options.notes,
      isParsed: true,
    );
  }

  @override
  String toString() {
    return 'EnterScreenData{'
        'amount: $amount, '
        'name: $name, '
        'currency: $currency, '
        'category: $category, '
        'date: $date, '
        'repeatConfiguration: $repeatConfiguration, '
        'notes: $notes, '
        'isParsed: $isParsed'
        '}';
  }
}
