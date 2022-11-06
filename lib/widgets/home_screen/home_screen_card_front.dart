//  Home Screen Card Front - Front Side of the Home Screen Card displaying monthly data statistics
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';
import 'package:linum/utilities/frontend/homescreen_card_time_warp.dart';
import 'package:linum/widgets/home_screen/home_screen_card_arrow.dart';
import 'package:linum/widgets/home_screen/home_screen_card_side.dart';
import 'package:linum/widgets/home_screen/home_screen_functions.dart';
import 'package:provider/provider.dart';

class HomeScreenCardFront extends StatelessWidget {
  final HomeScreenCardData data;
  final FlipCardController flipCardController;
  const HomeScreenCardFront({
    super.key,
    required this.data,
    required this.flipCardController,
  });

  void _onHorizontalDragEnd(DragEndDetails details, BuildContext context) {
    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
    final algorithmProvider =
        Provider.of<AlgorithmProvider>(context, listen: false);
    const int sensitivity = 1;
    if (details.primaryVelocity! > sensitivity) {
      //Right Swipe, going back in time
      goBackInTime(algorithmProvider);
    } else if (details.primaryVelocity! < -sensitivity) {
      goForwardInTime(algorithmProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);
    final settings = Provider.of<AccountSettingsProvider>(context);
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) =>
          _onHorizontalDragEnd(details, context),
      onTap: () => onFlipCardTap(context, flipCardController),
      onLongPress: () {
        goToCurrentTime(algorithmProvider);
      },
      child: HomeScreenCardSide(
        flipCardController: flipCardController,
        data: data,
        isBack: false,
        headline: Text(
          dateFormat.format(
            algorithmProvider.currentShownMonth,
          ),
          style: MediaQuery.of(context).size.height < 650
              ? Theme.of(context).textTheme.headline5
              : Theme.of(context).textTheme.headline3,
        ),
        subHeadline: Text(
          tr('home_screen_card.label-current-balance'),
          style: Theme.of(context).textTheme.headline5,
        ),
        middleRow: Row(
          // MiddleRow
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {

                goBackInTime(algorithmProvider);
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: CurrencyFormatter(
                  context.locale,
                  symbol: settings.getStandardCurrency().symbol,
                ).formatWithWidgets(
                  data.balance,
                  (amount) => Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        amount,
                        style: getBalanceTextStyle(context, data.balance),
                      ),
                    ),
                  ),
                  (symbol) => Text(
                    symbol,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                goForwardInTime(algorithmProvider);
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ), //TODO: Refactor even more?
        upwardArrow: HomeScreenCardArrow(
          arrowBoxColor: Theme.of(context).colorScheme.primary,
          arrowColor: Theme.of(context).colorScheme.background,
          isUpward: true,
        ),
        downwardArrow: HomeScreenCardArrow(
          arrowBoxColor: Theme.of(context).colorScheme.error,
          arrowColor: Theme.of(context).colorScheme.background,
        ),
      ),
    );
  }
}
