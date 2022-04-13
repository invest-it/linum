import 'package:flutter/cupertino.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/home_screen/home_screen_card.dart';


class HomeScreenCardManager implements AbstractHomeScreenCard {
  late HomeScreenCard _homeScreenCard;
  HomeScreenCardManager() {
    _homeScreenCard = const HomeScreenCard(income: 0, expense: 0, balance: 0);
  }

  @override
  void addStatisticData(StatisticsCalculations? statData) {
    if (statData != null) {
      final num income = statData.sumIncomes;
      final num expense = -statData.sumCosts;
      final num balance = statData.sumBalance;
      _homeScreenCard =
          HomeScreenCard(income: income, expense: expense, balance: balance);
    }
  }

  @override
  Widget get returnWidget => _homeScreenCard;
}

// TODO: Move to another folder
