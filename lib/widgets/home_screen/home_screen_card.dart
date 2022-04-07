// ignore: unused_import
import 'dart:developer' as dev;

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/widgets/abstract/abstract_home_screen_card.dart';
import 'package:linum/widgets/home_screen/card_sides/back_side.dart';
import 'package:linum/widgets/home_screen/card_sides/front_side.dart';

class HomeScreenCard extends StatefulWidget {
  final num balance;
  final num income;
  final num expense;
  const HomeScreenCard({
    Key? key,
    required this.balance,
    required this.income,
    required this.expense,
  }) : super(key: key);

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  late FlipCardController _flipCardController;

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    // dev.log(algorithmProvider.currentShownMonth.toString());

    return FlipCard(
      controller: _flipCardController,
      front: FrontSide(
        flipCardController: _flipCardController,
        balance: widget.balance,
        income: widget.income,
        expense: widget.expense,
      ),
      back: BackSide(
        flipCardController: _flipCardController,
        balance: widget.balance,
        income: widget.income,
        expense: widget.expense,
      ),
    );
  }
}

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
