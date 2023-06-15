import 'package:collection/collection.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';

typedef TextIndices = ({int start, int end});
typedef ParsedInput = ({InputFlag flag, String text});

class EnterScreenInput {
  final String raw;
  final double? amount;
  final String? currency;
  final String? name;
  final parsedInputs = <ParsedInput>[];

  final TextIndices? amountIndices;
  final TextIndices? currencyIndices;
  final TextIndices? nameIndices;

  EnterScreenInput(
    this.raw, {
    this.amount,
    this.name,
    this.currency,
    this.amountIndices,
    this.currencyIndices,
    this.nameIndices,
  });

  bool get hasAmount => amount != null;
  bool get hasCurrency => currency != null;
  bool get hasName => name != null;
  bool get hasCategory =>
      parsedInputs.firstWhereOrNull((t) => t.flag == InputFlag.category) !=
      null;
  bool get hasDate =>
      parsedInputs.firstWhereOrNull((t) => t.flag == InputFlag.date) != null;
  bool get hasRepeatInfo =>
      parsedInputs.firstWhereOrNull((t) => t.flag == InputFlag.category) !=
      null;
}
