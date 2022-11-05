//  Home Screen Card Back - Back Side of the Home Screen Card with All-Time Metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_card_arrow.dart';
import 'package:linum/widgets/home_screen/home_screen_card_side.dart';
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
    final settings = Provider.of<AccountSettingsProvider>(context);
    return GestureDetector(
      onTap: () => onFlipCardTap(context, flipCardController),
      child: HomeScreenCardSide(
        flipCardController: flipCardController,
        data: data,
        isBack: true,
        headline: Text(
          tr('home_screen_card.label-total-balance'),
          style: MediaQuery.of(context).size.height < 650
              ? Theme.of(context).textTheme.headline5
              : Theme.of(context).textTheme.headline3,
        ),
        subHeadline: Text(
          tr('home_screen_card.label-total-balance-sub'),
          style: Theme.of(context).textTheme.headline5,
        ),
        middleRow: Row(
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
                    settings.getStandardCurrency().symbol,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
        upwardArrow: HomeScreenCardArrow(
          arrowBoxColor: Theme.of(context).colorScheme.tertiaryContainer,
          arrowColor: Theme.of(context).colorScheme.background,
          isUpward: true,
        ),
        downwardArrow: HomeScreenCardArrow(
          arrowBoxColor: Theme.of(context).colorScheme.secondary,
          arrowColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
