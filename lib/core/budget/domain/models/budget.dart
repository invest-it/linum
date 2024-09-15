import 'package:linum/common/interfaces/mappable.dart';
import 'package:linum/common/interfaces/time_span.dart';
import 'package:linum/core/budget/domain/models/budget_cap.dart';
import 'package:uuid/uuid.dart';



class Budget implements TimeSpan<Budget>, IMappable<Budget> {
  final String seriesId;
  final String id;
  final String name;
  final BudgetCap cap;
  final List<String> categories;
  final DateTime start;
  final DateTime? end;

  Budget({
    String? seriesId,
    String? id,
    required this.name,
    required this.cap,
    required this.categories,
    required this.start,
    this.end,
  }): seriesId = seriesId ?? const Uuid().v4(), id = id ?? TimeSpan.newId(), assert(categories.isNotEmpty);

  @override
  Map<String, dynamic> toMap() {
    return {
      "seriesId": seriesId,
      "id": id,
      "name": name,
      "cap": cap.toMap(),
      "categories": categories,
      "start": start.toIso8601String(),
      "end": end?.toIso8601String(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    final end = map["end"] as String?;

    return Budget(
      seriesId: map["seriesId"] as String,
      id: map["id"] as String,
      name: map["name"] as String,
      cap: BudgetCap.fromMap(map["cap"] as Map<String, dynamic>),
      categories: map["categories"] as List<String>,
      start: DateTime.parse(map["start"] as String),
      end: end != null ? DateTime.parse(end) : null,
    );
  }

  Budget copyWith({
    String? id,
    String? name,
    BudgetCap? cap,
    List<String>? categories,
    DateTime? start,
    DateTime? end,
  }) {
    return Budget(
      seriesId: seriesId,
      id: id ?? this.id,
      name: name?? this.name,
      cap: cap ?? this.cap,
      categories: categories ?? this.categories,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  Budget copySpanWith({DateTime? start, DateTime? end, String? id}) {
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
    return 'Budget(seriesId: $seriesId, id: $id, name: $name, cap: $cap, categories: $categories, start: $start, end: $end)';
  }

}

class BudgetFactory implements IMappableFactory<Budget> {
  @override
  Budget fromMap(Map<String, dynamic> map) {
    return Budget.fromMap(map);
  }
}
