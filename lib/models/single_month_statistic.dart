import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class SingleMonthStatistic {
  final num sumBalance;
  final num averageBalance;

  final num sumIncomes;
  final num averageIncomes;

  final num sumCosts;
  final num averageCosts;

  final List<String> costsSubcategories;
  final List<String> incomeSubcategories;

  const SingleMonthStatistic({
    required this.sumBalance,
    required this.averageBalance,
    required this.sumIncomes,
    required this.averageIncomes,
    required this.sumCosts,
    required this.averageCosts,
    required this.costsSubcategories,
    required this.incomeSubcategories,
  });

  SingleMonthStatistic copyWith({
    num? sumBalance,
    num? averageBalance,
    num? sumIncomes,
    num? averageIncomes,
    num? sumCosts,
    num? averageCosts,
    List<String>? costsSubcategories,
    List<String>? incomeSubcategories,
  }) {
    return SingleMonthStatistic(
      sumBalance: sumBalance ?? this.sumBalance,
      averageBalance: averageBalance ?? this.averageBalance,
      sumIncomes: sumIncomes ?? this.sumIncomes,
      averageIncomes: averageIncomes ?? this.averageIncomes,
      sumCosts: sumCosts ?? this.sumCosts,
      averageCosts: averageCosts ?? this.averageCosts,
      costsSubcategories: costsSubcategories ?? this.costsSubcategories,
      incomeSubcategories: incomeSubcategories ?? this.incomeSubcategories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sumBalance': sumBalance,
      'averageBalance': averageBalance,
      'sumIncomes': sumIncomes,
      'averageIncomes': averageIncomes,
      'sumCosts': sumCosts,
      'averageCosts': averageCosts,
      'costsSubcategories': costsSubcategories,
      'incomeSubcategories': incomeSubcategories,
    };
  }

  factory SingleMonthStatistic.fromMap(Map<String, dynamic> map) {
    return SingleMonthStatistic(
      sumBalance: map['sumBalance'] as num? ?? 0,
      averageBalance: map['averageBalance'] as num? ?? 0,
      sumIncomes: map['sumIncomes'] as num? ?? 0,
      averageIncomes: map['averageIncomes'] as num? ?? 0,
      sumCosts: map['sumCosts'] as num? ?? 0,
      averageCosts: map['averageCosts'] as num? ?? 0,
      costsSubcategories:
          List<String>.from(map['costsSubcategories'] as List<String>? ?? []),
      incomeSubcategories:
          List<String>.from(map['incomeSubcategories'] as List<String>? ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleMonthStatistic.fromJson(String source) =>
      SingleMonthStatistic.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SingleMonthStatistic(sumBalance: $sumBalance, averageBalance: $averageBalance, sumIncomes: $sumIncomes, averageIncomes: $averageIncomes, sumCosts: $sumCosts, averageCosts: $averageCosts, costsSubcategories: $costsSubcategories, incomeSubcategories: $incomeSubcategories)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is SingleMonthStatistic &&
        other.sumBalance == sumBalance &&
        other.averageBalance == averageBalance &&
        other.sumIncomes == sumIncomes &&
        other.averageIncomes == averageIncomes &&
        other.sumCosts == sumCosts &&
        other.averageCosts == averageCosts &&
        listEquals(other.costsSubcategories, costsSubcategories) &&
        listEquals(other.incomeSubcategories, incomeSubcategories);
  }

  @override
  int get hashCode {
    return sumBalance.hashCode ^
        averageBalance.hashCode ^
        sumIncomes.hashCode ^
        averageIncomes.hashCode ^
        sumCosts.hashCode ^
        averageCosts.hashCode ^
        costsSubcategories.hashCode ^
        incomeSubcategories.hashCode;
  }
}
