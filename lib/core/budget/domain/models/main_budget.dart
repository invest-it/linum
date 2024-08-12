import 'package:linum/common/interfaces/mappable.dart';
import 'package:linum/core/budget/domain/models/time_span.dart';

class MainBudget implements TimeSpan<MainBudget>, IMappable<MainBudget> {
  final String id;
  final double? amount;
  final DateTime start;
  final DateTime? end;

  MainBudget({
    String? id,
    required this.amount,
    required this.start,
    required this.end,
  }): id = id ?? TimeSpan.newId();

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "start": start,
      "end": end,
    };
  }

  factory MainBudget.fromMap(Map<String, dynamic> map) {
    final end = map["end"] as String?;
    return MainBudget(
        id: map["id"] as String,
        amount: map["amount"] as double?,
        start: DateTime.parse(map["start"] as String),
        end: end != null ? DateTime.parse(end) : null,
    );
  }

  MainBudget copyWith({
    String? id,
    double? amount,
    DateTime? start,
    DateTime? end,
  }) {
    return MainBudget(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  MainBudget copySpanWith({DateTime? start, DateTime? end, String? id}) {
    return copyWith(
      start: start,
      end: end,
      id: id,
    );
  }

  @override
  DateTime? getEnd() => end;

  @override
  DateTime getStart() => start;

  @override
  String getId() => id;

  @override
  String toString() {
    return 'MainBudget(id: $id, amount: $amount, start: $start, end: $end)';
  }


}


class MainBudgetFactory extends IMappableFactory<MainBudget> {
  @override
  MainBudget fromMap(Map<String, dynamic> map) {
    return MainBudget.fromMap(map);
  }

}
