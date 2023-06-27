import 'package:easy_localization/easy_localization.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_data.dart';
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

  StringBuilder useExistingString(String str) {
    _existingStr = str;
    return this;
  }

  StringBuilder useEnterScreenData(EnterScreenData data) {
    _amount = data.amount?.toString() ?? "";
    _currency = data.currency?.name ?? "";
    _name = data.name ?? "";

    if (data.category != null) {
      _category = "#${flagSuggestionDefaults[InputFlag.category]?.tr()}:"
                  "${data.category!.label.tr()}";
    }
    if (data.date != null && data.date != "") {
      _date = "#${flagSuggestionDefaults[InputFlag.date]?.tr()}:"
              "${_dateFormatter.format(data.date!)?.tr()}";
    }
    if (data.repeatConfiguration != null) {
      _repeatInfo = "#${flagSuggestionDefaults[InputFlag.repeatInfo]?.tr()}:"
                    "${data.repeatConfiguration!.label.tr()}";
    }

    return this;
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
    if (lastChar == "") {
      return;
    }
    _str += " ";
  }
}
