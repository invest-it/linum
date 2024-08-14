import 'package:collection/collection.dart';
import 'package:linum/common/interfaces/mappable.dart';

enum CapType {
  percentage,
  amount;

  factory CapType.fromString(String? str) {
    return CapType.values.firstWhereOrNull((e) => e.name == str) ?? CapType.amount;
  }

  factory CapType.fromDynamic(dynamic value) {
    return CapType.values.firstWhereOrNull((e) => e.name == value as String?) ?? CapType.amount;
  }
}


class BudgetCap implements IMappable<BudgetCap> {
  final double value;
  final CapType type;

  BudgetCap({required this.value, required this.type});

  @override
  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "amount": type.name,
    };
  }

  factory BudgetCap.fromMap(Map<String, dynamic> map) {
    return BudgetCap(
      value: map["value"] as double? ?? 0.0,
      type: CapType.fromDynamic(map["type"]),
    );
  }

  @override
  String toString() {
    return 'BudgetCap(value: $value, type: $type)';
  }
}

class BudgetCapFactory implements IMappableFactory<BudgetCap> {
  @override
  BudgetCap fromMap(Map<String, dynamic> map) {
    return BudgetCap.fromMap(map);
  }

}
