import 'package:linum/common/interfaces/mappable.dart';

class MainBudget implements IMappable<MainBudget> {
  final double? amount;
  final DateTime start;
  final DateTime? end;

  MainBudget({required this.amount, required this.start, required this.end});

  @override
  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "start": start,
      "end": end,
    };
  }

  factory MainBudget.fromMap(Map<String, dynamic> map) {
    final end = map["end"] as String?;
    return MainBudget(
        amount: map["amount"] as double?,
        start: DateTime.parse(map["start"] as String),
        end: end != null ? DateTime.parse(end) : null,
    );
  }
}


class MainBudgetFactory extends IMappableFactory<MainBudget> {
  @override
  MainBudget fromMap(Map<String, dynamic> map) {
    return MainBudget.fromMap(map);
  }

}
