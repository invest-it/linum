import 'package:easy_localization/easy_localization.dart';
import 'package:linum/core/categories/core/data/models/category.dart';
import 'package:linum/core/repeating/enums/repeat_interval.dart';
import 'package:linum/core/repeating/models/repeat_configuration.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/utils/date_formatter.dart';



class StringBuilder {
  final _dateFormatter = const DateFormatter();

  String _existingStr = "";
  String _str = "";
  String _amount = "";
  String _currency = "";
  String _name = "";
  String _category = "";
  String _date = "";
  String _repeatInfo = "";

  void useExistingString(String str) {
    _existingStr = str;
  }

  void setAmount(num? amount) {
    _amount = amount?.abs().toString() ?? "";
  }

  void setCurrency(Currency? currency) {
    _currency = currency?.name ?? "";
  }
  void setName(String? name) {
    _name = name ?? "";
  }
  void setCategory(Category? category) {
    if (category != null) {
      _category = "#${flagSuggestionDefaults[InputFlag.category]?.tr()}:"
          "${category.label.tr()}";
    }
  }
  void setDate(String? date) {
    if (date != null && date != "") {
      _date = "#${flagSuggestionDefaults[InputFlag.date]?.tr()}:"
          "${_dateFormatter.format(date)?.tr()}";
    }
  }
  void setRepeatConfiguration(RepeatConfiguration? repeatConfiguration) {
    if (repeatConfiguration != null && repeatConfiguration.interval != RepeatInterval.none) {
      _repeatInfo = "#${flagSuggestionDefaults[InputFlag.repeatInfo]?.tr()}:"
          "${repeatConfiguration.label.tr()}";
    }
  }

  String build() {
    if (_existingStr != "") {
      // TODO Parse and replace;
      return _str;
    }

    _str += _amount;
    _addSpaceConditionally();
    _str += _currency;
    _addSpaceConditionally();
    _str += _name;
    _addSpaceConditionally();
    _str += _category;
    _addSpaceConditionally();
    _str += _date;
    _addSpaceConditionally();
    _str += _repeatInfo;
    _addSpaceConditionally();
    return _str;
  }

  void _addSpaceConditionally() {
    if (_str.isEmpty) {
      return;
    }
    final lastChar = _str[_str.length - 1];
    if (lastChar == " ") {
      return;
    }
    _str += " ";
  }
}
