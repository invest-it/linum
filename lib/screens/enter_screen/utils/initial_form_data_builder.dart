import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/models/selected_options.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/utils/get_repeat_interval.dart';
import 'package:linum/screens/enter_screen/utils/string_builder.dart';

class InitialFormDataBuilder {
  final ITranslator translator;

  Map<String, Currency> currencies;
  Map<RepeatInterval, RepeatConfiguration> repeatConfigurations;
  EntryType entryType = EntryType.unknown;

  InitialFormDataBuilder({
    required this.currencies,
    required this.repeatConfigurations,
    required this.translator,
  });

  String? name;
  num? amount;
  Currency? currency;
  String? date;
  String? categoryKey;
  RepeatConfiguration? repeatConfiguration;
  String? notes;

  void useTransaction(Transaction? transaction, {
    SerialTransaction? parentalSerialTransaction,
  }) {
    if (transaction == null) {
      return;
    }

    final repeatInterval = getRepeatInterval(
      parentalSerialTransaction?.repeatDuration,
      parentalSerialTransaction?.repeatDurationType,
    );

    name = transaction.name;
    amount = transaction.amount;
    currency = currencies[transaction.currency];
    date = transaction.date.toDate().toIso8601String();
    categoryKey = transaction.category;
    repeatConfiguration = repeatConfigurations[repeatInterval];
    notes = transaction.note;
  }

  void useSerialTransaction(SerialTransaction? serialTransaction) {
    if (serialTransaction == null) {
      return;
    }

    name = serialTransaction.name;
    amount = serialTransaction.amount;
    currency = currencies[serialTransaction.currency];
    date = serialTransaction.startDate.toDate().toIso8601String();
    categoryKey = serialTransaction.category;
    repeatConfiguration = repeatConfigurations[serialTransaction.repeatInterval];
    notes = serialTransaction.note;

  }

  EnterScreenFormData build() {

    final category = getCategory(categoryKey, entryType: entryType);
    final selectedOptions = SelectedOptions(
      currency: currency,
      category: category,
      date: date,
      repeatConfiguration: repeatConfiguration,
      notes: notes,
    );

    final strBuilder = StringBuilder(translator)
      ..setAmount(amount)
      ..setName(name)
      ..setCurrency(currency)
      ..setCategory(category)
      ..setDate(date)
      ..setRepeatConfiguration(repeatConfiguration);


    return EnterScreenFormData(
      parsed: StructuredParsedData(strBuilder.build()),
      options: selectedOptions,
    );
  }
}
