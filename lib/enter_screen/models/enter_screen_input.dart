import 'package:collection/collection.dart';
import 'package:linum/enter_screen/enums/input_flag.dart';
import 'package:tuple/tuple.dart';

class EnterScreenInput {
  final String raw;
  final double? amount;
  final String? currency;
  final String? name;
  final parsedInputs = <Tuple2<InputFlag, String>>[];

  EnterScreenInput(
    this.raw, {
    this.amount,
    this.name,
    this.currency,
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
