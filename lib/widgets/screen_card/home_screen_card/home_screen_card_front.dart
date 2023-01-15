//  Home Screen Card Front - Front Side of the Home Screen Card displaying monthly data statistics
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/screen_card_provider.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';
import 'package:linum/utilities/frontend/homescreen_card_time_warp.dart';
import 'package:linum/widgets/loading_spinner.dart';
import 'package:linum/widgets/screen_card/card_widgets/home_screen_card_avatar.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_row.dart';
import 'package:linum/widgets/screen_card/home_screen_functions.dart';
import 'package:linum/widgets/screen_card/screen_card_data_extensions.dart';
import 'package:provider/provider.dart';

class HomeScreenCardFront extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

    final settings = Provider.of<AccountSettingsProvider>(context);
    final screenCardProvider = Provider.of<ScreenCardProvider>(context, listen: false);
    final balanceDataProvider = Provider.of<BalanceDataProvider>(context);

    return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) =>
              onHorizontalDragEnd(details, context),
          onTap: () => onFlipCardTap(context, screenCardProvider.controller!),
          onLongPress: () {
            goToCurrentTime(algorithmProvider);
          },
          child: Column(
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
                              screenCardProvider.controller!.toggleCard();
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
                    child: StreamBuilder<HomeScreenCardData>(
                      stream: balanceDataProvider.getHomeScreenCardData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState == ConnectionState.waiting) {
                          return const LoadingSpinner();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: CurrencyFormatter(
                            context.locale,
                            symbol: settings.getStandardCurrency().symbol,
                          ).formatWithWidgets(
                            snapshot.data?.mtdBalance ?? 0,
                            (amount) => Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  amount,
                                  style: getBalanceTextStyle(context, snapshot.data?.mtdBalance ?? 0),
                                ),
                              ),
                            ), (symbol) => Text(
                            symbol,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          ),
                        );
                      },
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
                child: HomeScreenCardRow(
                  data: balanceDataProvider.getHomeScreenCardData(),
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
        );
  }
}
