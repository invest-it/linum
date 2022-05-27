//  HomeScreenCard - Main Widget for the Home Screen Card
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

// ignore: unused_import
import 'dart:developer' as dev;
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/widgets/home_screen/home_screen_card_back.dart';
import 'package:linum/widgets/home_screen/home_screen_card_front.dart';

class HomeScreenCard extends StatefulWidget {
  final HomeScreenCardData frontData;
  final HomeScreenCardData backData;

  const HomeScreenCard({
    Key? key,
    required this.frontData,
    required this.backData,
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
    return FlipCard(
      controller: _flipCardController,
      front: HomeScreenCardFront(
        data: widget.frontData,
        flipCardController: _flipCardController,
      ),
      back: HomeScreenCardBack(
        data: widget.backData,
        flipCardController: _flipCardController,
      ),
    );
  }
}
