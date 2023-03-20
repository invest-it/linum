import 'package:collection/collection.dart';
import 'package:linum/screens/enter_screen/enums/input_flag.dart';
import 'package:tuple/tuple.dart';

class EnterScreenInput {
  final String raw;
  final double? amount;
  final String? currency;
  final String? name;
  final parsedInputs = <Tuple2<InputFlag, String>>[];

  final Tuple2<int, int>? amountIndices;
  final Tuple2<int, int>? currencyIndices;
  final Tuple2<int, int>? nameIndices;

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
      parsedInputs.firstWhereOrNull((t) => t.item1 == InputFlag.category) !=
      null;
  bool get hasDate =>
      parsedInputs.firstWhereOrNull((t) => t.item1 == InputFlag.date) != null;
  bool get hasRepeatInfo =>
      parsedInputs.firstWhereOrNull((t) => t.item1 == InputFlag.category) !=
      null;
}
