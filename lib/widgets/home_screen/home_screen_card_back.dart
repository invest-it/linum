//  Home Screen Card Back - Back Side of the Home Screen Card with All-Time Metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_card_avatar.dart';
import 'package:linum/widgets/home_screen/home_screen_card_bottom_row.dart';
import 'package:linum/widgets/home_screen/home_screen_card_skeleton.dart';
import 'package:linum/widgets/home_screen/home_screen_functions.dart';
import 'package:provider/provider.dart';

class HomeScreenCardBack extends StatelessWidget {
  final HomeScreenCardData data;
  final FlipCardController flipCardController;

  const HomeScreenCardBack({
    super.key,
    required this.data,
    required this.flipCardController,
  });

  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

    return GestureDetector(
      onTap: () => onFlipCardTap(context, flipCardController),
      child: HomeScreenCardSkeleton(
        flipCardController: flipCardController,
        cardWidth: 345,
        cardHeight: 196,
        data: data,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: Text(
                        'Monatsplanung', //TODO @NightmindOfficial translate!
                        style: MediaQuery.of(context).size.height < 650
                            ? Theme.of(context).textTheme.headline5
                            : Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          padding: const EdgeInsets.only(right: 16),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            flipCardController.toggleCard();
                          },
                          icon: const Icon(
                            Icons.flip_camera_android_rounded,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  dateFormat.format(
                    algorithmProvider.currentShownMonth,
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            data.balance.toStringAsFixed(2),
                            style: getBalanceTextStyle(context, data.balance),
                          ),
                        ),
                      ),
                      Text(
                        '€',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
