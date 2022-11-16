//  Home Screen Card Manager - Chooser for which Side to display & more helper functions
//
//  Author: damattl
//  Co-Author: NightmindOfficial
//  (Refactored)

import 'package:flutter/cupertino.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/utilities/backend/statistical_calculations.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/screen_card/home_screen_card.dart';

class ScreenCardManager implements AbstractScreenCard {
  late HomeScreenCard _homeScreenCard;

//TODO do we even need a constructor here?
  ScreenCardManager() {
    _homeScreenCard = const HomeScreenCard(
      frontData: HomeScreenCardData(),
      backData: HomeScreenCardData(),
    );
  }

  @override
  void addStatisticData(StatisticalCalculations? statData) {
    if (statData != null) {
      final num income = statData.sumIncomes;
      final num expense = -statData.sumCosts;
      final num balance = statData.sumBalance;
      final num allTimeIncome = statData.allTimeSumIncomes;
      final num allTimeExpense = statData.allTimeSumCosts;
      final num allTimeBalance = statData.allTimeSumBalance;

      _homeScreenCard = HomeScreenCard(
        frontData: HomeScreenCardData(
          mtdBalance: balance,
          mtdIncome: income,
          mtdExpenses: expense,
        ),
        backData: HomeScreenCardData(
          eomBalance: allTimeBalance,
          eomSerialIncome: allTimeIncome,
          eomSerialExpenses: allTimeExpense,
        ),
      );
    }
  }

  @override
  Widget get returnWidget => _homeScreenCard;
}
