import 'package:linum/common/interfaces/translator.dart';
import 'package:linum/screens/enter_screen/constants/suggestion_defaults.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:linum/screens/enter_screen/models/structured_parsed_data.dart';
import 'package:tuple/tuple.dart';

class ExampleStringBuilder {
  final num defaultAmount;
  final String defaultCurrency;
  final String defaultName;
  final String defaultCategory;
  final String defaultDate;
  final String defaultRepeatInfo;
  final ITranslator translator;

  late Tuple2<String, String> value;

  ExampleStringBuilder({
    required this.defaultAmount,
    required this.defaultCurrency,
    required this.defaultName,
    required this.defaultCategory,
    required this.defaultDate,
    required this.defaultRepeatInfo,
    required this.translator,
  }) {
    build();
  }

  String _buildCategoryString({String? category}) {
    return "#${translator.translate(flagSuggestionDefaults[InputFlag.category] ?? "")}:"
        "${translator.translate(category ?? defaultCategory)}";
  }

  String _buildDateString({String? date}) {
    return "#${translator.translate(flagSuggestionDefaults[InputFlag.date] ?? "")}:"
        "${translator.translate(date ?? defaultDate)}";
  }

  String _buildRepeatInfoString({String? repeatInfo}) {
    return "#${translator.translate(flagSuggestionDefaults[InputFlag.repeatInfo] ?? "")}:"
        "${translator.translate(repeatInfo ?? defaultRepeatInfo)}";
  }

  void build() {
    final str2 = "$defaultAmount $defaultCurrency $defaultName "
        "${_buildCategoryString()} "
        "${_buildDateString()} "
        "${_buildRepeatInfoString()}";
    value = Tuple2("", str2);
  }


  // TODO: Refactor
  void rebuild(StructuredParsedData parsed) {
    if (parsed.raw == "") {
      build();
      return;
    }


    final str2 = (parsed.hasAmount ? "" : "$defaultAmount ") +
        (parsed.raw.endsWith(" ") && parsed.hasAmount ? "" : " ") +
        (parsed.hasName ? "" : "$defaultName ") +
        (parsed.raw.contains('#')
            ? ""
            : "${parsed.hasCategory ? "" : "${_buildCategoryString()} "}"
                "${parsed.hasDate ? "" : "${_buildDateString()} "}"
                "${parsed.hasRepeatInfo ? "" : "${_buildRepeatInfoString()} "}");
    value = Tuple2(parsed.raw, str2);
  }
}
