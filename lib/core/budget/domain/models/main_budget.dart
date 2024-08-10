import 'package:linum/common/interfaces/mappable.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';

class MainBudget implements TimeSpan<MainBudget>, IMappable<MainBudget> {
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

  MainBudget copyWith({
    double? amount,
    DateTime? start,
    DateTime? end,
  }) {
    return MainBudget(
        amount: amount ?? this.amount,
        start: start ?? this.start,
        end: end ?? this.end,
    );
  }

  @override
  MainBudget copySpanWith({DateTime? start, DateTime? end}) {
    return copyWith(
      start: start,
      end: end,
    );
  }
}


class MainBudgetFactory extends IMappableFactory<MainBudget> {
  @override
  MainBudget fromMap(Map<String, dynamic> map) {
    return MainBudget.fromMap(map);
  }

}
