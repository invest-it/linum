import 'package:flutter/cupertino.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/utilities/backend/statistic_calculations.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';

class HomeScreenCardManager implements AbstractHomeScreenCard {
  late HomeScreenCard _homeScreenCard;
  HomeScreenCardManager() {
    _homeScreenCard = const HomeScreenCard(
      frontData: HomeScreenCardData(
        balance: 0,
        income: 0,
        expense: 0,
      ),
      backData: HomeScreenCardData(
        balance: 0,
        income: 0,
        expense: 0,
      ),
    );
  }

  @override
  void addStatisticData(StatisticsCalculations? statData) {
    if (statData != null) {
      final num income = statData.sumIncomes;
      final num expense = -statData.sumCosts;
      final num balance = statData.sumBalance;
      final num allTimeIncome = statData.allTimeSumIncomes;
      final num allTimeExpense = statData.allTimeSumCosts;
      final num allTimeBalance = statData.allTimeSumBalance;

      _homeScreenCard = HomeScreenCard(
        frontData: HomeScreenCardData(
          balance: balance,
          income: income,
          expense: expense,
        ),
        backData: HomeScreenCardData(
          balance: allTimeBalance,
          income: allTimeIncome,
          expense: allTimeExpense,
        ),
      );
    }
  }

  @override
  Widget get returnWidget => _homeScreenCard;
}

// TODO: Move to another folder
