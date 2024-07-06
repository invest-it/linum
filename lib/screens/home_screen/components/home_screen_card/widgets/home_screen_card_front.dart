//  Home Screen Card Front - Front Side of the Home Screen Card displaying monthly data statistics
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_card/viewmodels/screen_card_viewmodel.dart';
import 'package:linum/common/components/screen_card/widgets/home_screen_card_avatar.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/utils/balance_data_processors.dart';
import 'package:linum/core/balance/widgets/balance_data_stream_consumer.dart';
import 'package:linum/features/currencies/core/data/models/currency.dart';
import 'package:linum/features/currencies/core/presentation/exchange_rate_service.dart';
import 'package:linum/features/currencies/core/presentation/widgets/styled_amount.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/models/home_screen_card_data.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/utils/home_screen_functions.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/utils/homescreen_card_time_warp.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/widgets/home_screen_card_row.dart';
import 'package:provider/provider.dart';


class HomeScreenCardFront extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);
    final DateTime now = DateTime.now();

    final AlgorithmService algorithmService =
      context.watch<AlgorithmService>();

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) =>
          onHorizontalDragEnd(details, context),
      onTap: () => onFlipCardTap(
          context.read<ScreenCardViewModel>().controller!,
      ),
      onLongPress: () {
        goToCurrentTime(algorithmService);
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: (algorithmService.state.shownMonth !=
                DateTime(now.year, now.month))
                ? IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(18.0),
              icon: const Icon(Icons.event_repeat_rounded),
              onPressed: () {
                goToCurrentTime(algorithmService);
              },
            )
                : IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(18.0),
              icon: const Icon(Icons.error),
              color: Theme.of(context).colorScheme.onSurface.withAlpha(0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {},
            ),
          ),
          Column(
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
                            algorithmService.state.shownMonth,
                          ),
                          style: MediaQuery.of(context).size.height < 650
                              ? Theme.of(context).textTheme.headlineSmall
                              : Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      /*Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            padding: const EdgeInsets.only(right: 16),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              context.read<ScreenCardViewModel>()
                                  .controller!.toggleCard();
                            },
                            icon: const Icon(
                              Icons.flip_camera_android_rounded,
                            ),
                          ),
                        ),
                      ),*/
                      const Spacer(),
                    ],
                  ),
                  Text(
                    //SUBHEADLINE
                    tr(translationKeys.homeScreenCard.labelCurrentBalance),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Row(
                // MiddleRow
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      goBackInTime(algorithmService);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: BalanceDataStreamConsumer3<
                        IExchangeRateService, AlgorithmService, HomeScreenCardData>(
                      transformer: (snapshot, exchangeRateService, algorithmService) async {
                        final statData = await generateStatistics(
                          snapshot: snapshot,
                          algorithms: algorithmService.state,
                          exchangeRateService: exchangeRateService,
                        );
                        return HomeScreenCardData.fromStatistics(statData);
                      },
                      builder: (context, snapshot, _) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return const LoadingSpinner();
                        }

                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Selector<ICurrencySettingsService, Currency>(
                            selector: (_, currencySettings) => currencySettings.getStandardCurrency(),
                            builder: (context, standardCurrency, _) {
                              return StyledAmount(
                                value: snapshot.data?.mtdBalance ?? 0.00,
                                locale: context.locale,
                                symbol: standardCurrency.symbol,
                                fontSize: StyledFontSize.maximize,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      goForwardInTime(algorithmService);
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
                  upwardArrow: HomeScreenCardAvatar.withArrow(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    arrow: Preset.arrowUp,
                  ),
                  downwardArrow: HomeScreenCardAvatar.withArrow(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    arrow: Preset.arrowDown,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
