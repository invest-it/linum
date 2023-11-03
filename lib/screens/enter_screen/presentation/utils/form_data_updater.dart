import 'dart:developer';

import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/screens/enter_screen/domain/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/domain/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/domain/formatting/date_formatter.dart';
import 'package:linum/screens/enter_screen/domain/models/parsed_input.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/presentation/models/enter_screen_form_data.dart';
import 'package:linum/screens/enter_screen/presentation/models/selected_options.dart';


class FormDataUpdater {
  final EnterScreenFormData oldData;
  final EnterScreenFormData newData;
  final ITranslator translator;
  final dateFormatter = const DateFormatter();

  EnterScreenFormData? updatedData;

  late final DidChange _optionsChanged;

  FormDataUpdater({
    required this.oldData,
    required this.newData,
    required this.translator,
  }) {
    _optionsChanged = _detectOptionChanges(
        oldOptions: oldData.options,
        newOptions: newData.options,
    );
  }

  EnterScreenFormData update() {
    if (_optionsChanged.changed) {
      updatedData = _handleChangedOptions();
    }


    // TODO: Careful this might override previous changes
    if (oldData.parsed != newData.parsed) {
      updatedData ??= newData;
      /*
      if (updatedData == null) {
        updatedData = newData;
      }
      */

      var updatedCurrency = updatedData?.options.currency;
      // If currency input was just deleted
      if (updatedData?.parsed.currency == null && oldData.parsed.currency != null) {
        updatedCurrency = null;
      }
      // If currency was parsed from user input
      if (updatedData?.parsed.currency != null) {
        updatedCurrency = updatedData?.parsed.currency?.value;
      }

      var updatedCategory = updatedData?.options.category;
      // If category input was just deleted
      if (updatedData?.parsed.category == null && oldData.parsed.category != null) {
        updatedCategory = null;
      }
      // If category was parsed from user input
      if (updatedData?.parsed.category != null) {
        updatedCategory = updatedData?.parsed.category?.value;
      }

      var updatedDate = updatedData?.options.date;
      // If date input was just deleted
      if (updatedData?.parsed.date == null && oldData.parsed.date != null) {
        updatedDate = null;
      }
      // If date was parsed from user input
      if (updatedData?.parsed.date != null) {
        updatedDate = updatedData?.parsed.date?.value;
      }

      var updatedRepeatInfo = updatedData?.options.repeatConfiguration;
      // If repeatInfo input was just deleted
      if (updatedData?.parsed.repeatInfo == null && oldData.parsed.repeatInfo != null) {
        updatedRepeatInfo = null;
      }
      // If repeatInfo was parsed from user input
      if (updatedData?.parsed.repeatInfo != null) {
        updatedRepeatInfo = updatedData?.parsed.repeatInfo?.value;
      }


      updatedData = updatedData?.copyWith(
        options: SelectedOptions(
          currency: updatedCurrency,
          category: updatedCategory,
          date: updatedDate,
          repeatConfiguration: updatedRepeatInfo,
        ),
      );

    }

    if (updatedData == null) {
      return newData;
    }
    return updatedData!;
  }

  EnterScreenFormData _handleChangedOptions() {
    StructuredParsedData parsedData = newData.parsed;

    if (_optionsChanged.currency) {
      parsedData = _replaceParsedCurrency(parsedData);
    }
    if (_optionsChanged.category) {
      parsedData = _replaceParsedCategory(parsedData);
    }
    if (_optionsChanged.date) {
      parsedData = _replaceParsedDate(parsedData);

    }
    if (_optionsChanged.repeatInfo) {
      parsedData = _replaceParsedRepeatInfo(parsedData);

    }
    return newData.copyWith(
      parsed: parsedData,
    );
  }

  StructuredParsedData _replaceParsedCurrency(
      StructuredParsedData parsedData,
      ) {
    final parsedInput = parsedData.currency;
    if (parsedInput == null) {
      return parsedData;
    }

    var replacement = "";
    final label = newData.options.currency?.name;
    if (label != null) {
      replacement = translator.translate(label);
    }

    final raw = _replaceParsedInput(parsedInput, parsedData.raw, replacement: replacement);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      category: parsedData.category,
      date: parsedData.date,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _replaceParsedCategory(
      StructuredParsedData parsedData,
      ) {
    final parsedInput = parsedData.category;
    if (parsedInput == null) {
      return parsedData;
    }

    var replacement = "";
    final label = newData.options.category?.label;
    if (label != null) {
      replacement = "#${translator.translate(flagSuggestionDefaults[InputFlag.category]!)}:${translator.translate(label)}";
    }

    log(newData.toString());

    log(label.toString());

    final raw = _replaceParsedInput(parsedInput, parsedData.raw, replacement: replacement);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      date: parsedData.date,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _replaceParsedDate(
      StructuredParsedData parsedData,
      ) {
    final parsedInput = parsedData.date;
    if (parsedInput == null) {
      return parsedData;
    }

    var replacement = "";
    final label = newData.options.date;
    if (label != null) {
      replacement = "#${translator.translate(flagSuggestionDefaults[InputFlag.date]!)}:${translator.translate(dateFormatter.format(label) ?? label)}";
    }


    final raw = _replaceParsedInput(parsedInput, parsedData.raw, replacement: replacement);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      category: parsedData.category,
      repeatInfo: parsedData.repeatInfo,
    );
  }

  StructuredParsedData _replaceParsedRepeatInfo(
      StructuredParsedData parsedData,
  ) {
    final parsedInput = parsedData.repeatInfo;
    if (parsedInput == null) {
      return parsedData;
    }

    var replacement = "";
    final label = newData.options.repeatConfiguration?.label;
    if (label != null) {
      replacement = "#${translator.translate(flagSuggestionDefaults[InputFlag.repeatInfo]!)}:${translator.translate(label)}";
    }

    log(newData.toString());

    log(label.toString());

    final raw = _replaceParsedInput(parsedInput, parsedData.raw, replacement: replacement);
    return StructuredParsedData(
      raw,
      amount: parsedData.amount,
      name: parsedData.name,
      currency: parsedData.currency,
      category: parsedData.category,
      date: parsedData.date,
    );
  }

  String _replaceParsedInput(ParsedInput parsedInput, String raw, {String replacement = ""}) {
    if (parsedInput.indices.end > raw.length) {
      return raw;
    }
    return raw.replaceRange(
      parsedInput.indices.start,
      parsedInput.indices.end,
      replacement,
    );
  }
}


class DidChange {
  final bool category;
  final bool currency;
  final bool date;
  final bool repeatInfo;

  DidChange({
    this.category = false,
    this.currency = false,
    this.date = false,
    this.repeatInfo = false,
  });

  bool get changed => category || currency || repeatInfo || date;
}

DidChange _detectOptionChanges({
  required SelectedOptions oldOptions,
  required SelectedOptions newOptions,
}) {
  bool categoryChanged = false;
  bool currencyChanged = false;
  bool repeatConfigurationChanged = false;
  bool dateChanged = false;

  if (oldOptions.category != newOptions.category) {
    categoryChanged = true;
  }
  if (oldOptions.currency != newOptions.currency) {
    currencyChanged = true;
  }
  if (oldOptions.repeatConfiguration != newOptions.repeatConfiguration) {
    repeatConfigurationChanged = true;
  }
  if (oldOptions.date != newOptions.date) {
    dateChanged = true;
  }

  return DidChange(
    category: categoryChanged,
    currency: currencyChanged,
    date: dateChanged,
    repeatInfo: repeatConfigurationChanged,
  );
}
