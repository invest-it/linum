//  Home Screen Card Front - Front Side of the Home Screen Card displaying monthly data statistics
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/utilities/frontend/homescreen_card_time_warp.dart';
import 'package:linum/widgets/home_screen/home_screen_card_avatar.dart';
import 'package:linum/widgets/home_screen/home_screen_card_bottom_row.dart';
import 'package:linum/widgets/home_screen/home_screen_card_skeleton.dart';
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
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) =>
          _onHorizontalDragEnd(details, context),
      onTap: () => onFlipCardTap(context, flipCardController),
      onLongPress: () {
        goToCurrentTime(algorithmProvider);
      },
      child: HomeScreenCardSkeleton(
        flipCardController: flipCardController,
        cardWidth: 345,
        cardHeight: 196,
        data: data,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: Text(
                        // HEADLINE
                        dateFormat.format(
                          algorithmProvider.currentShownMonth,
                        ),
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
                  //SUBHEADLINE
                  tr('home_screen_card.label-current-balance'),
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
            Row(
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
                IconButton(
                  onPressed: () {
                    goForwardInTime(algorithmProvider);
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: HomeScreenCardBottomRow(
                data: data,
                upwardArrow: HomeScreenCardAvatar.withArrow(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  arrow: Preset.arrowUp,
                ),
                downwardArrow: HomeScreenCardAvatar.withArrow(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  arrow: Preset.arrowDown,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
