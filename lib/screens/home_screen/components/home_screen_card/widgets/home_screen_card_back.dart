//  Home Screen Card Back - Back Side of the Home Screen Card with All-Time Metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_card/viewmodels/screen_card_viewmodel.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/common/widgets/styled_amount.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/balance/utils/balance_data_processors.dart';
import 'package:linum/core/balance/widgets/balance_data_stream_consumer.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/models/home_screen_card_data.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/utils/home_screen_functions.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/utils/homescreen_card_time_warp.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

//TODO: WTF OTIS, WHY IS THIS SO FREAKING LARGE?

class HomeScreenCardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlgorithmService algorithmService =
        context.watch<AlgorithmService>();
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat("MMM ''yy", langCode);
    final DateTime now = DateTime.now();

    bool checkPastMonth() {
      return !DateTime(now.year, now.month).isAfter(
        algorithmService.state.shownMonth,
      );
    }

    final accountSettingsService = context.watch<AccountSettingsService>();
    final balanceDataService = context.watch<BalanceDataService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onFlipCardTap(
            context.read<ScreenCardViewModel>().controller!,
        ),
        onHorizontalDragEnd: (DragEndDetails details) =>
            onHorizontalDragEnd(details, context),
        onLongPress: () => goToCurrentTime(algorithmService),
        child: Stack(
          children: [
            //Go back to current month button
            Align(
              alignment: Alignment.topLeft,
              child: (algorithmService.state.shownMonth !=
                      DateTime(now.year, now.month))
                  ? IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4.0),
                      icon: const Icon(Icons.event_repeat_rounded),
                      onPressed: () {
                        goToCurrentTime(algorithmService);
                      },
                    )
                  : IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4.0),
                      icon: const Icon(Icons.error),
                      color:
                          Theme.of(context).colorScheme.onSurface.withAlpha(0),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                    ),
            ),

            //Switch Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4.0),
                onPressed: () {
                  context.read<ScreenCardViewModel>().controller?.toggleCard();
                },
                icon: const Icon(
                  Icons.flip_camera_android_rounded,
                ),
              ),
            ),

            //Card Content
            Column(
              children: [
                //Card Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "${tr("home_screen_card.label-monthly-planner")} | ${dateFormat.format(algorithmService.state.shownMonth)}",
                    style: MediaQuery.of(context).size.height < 650
                        ? Theme.of(context).textTheme.headline5
                        : Theme.of(context).textTheme.headline4,
                  ),
                ),

                //Card Content
                Expanded(
                  //MOTHER ROW

                  child: Row(
                    children: [
                      //GO BACK IN TIME
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              goBackInTime(algorithmService);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                        ],
                      ),

                      //KPI COLUMN
                      Expanded(
                        //STREAM INSERT
                        child: BalanceDataStreamConsumer3<
                            ExchangeRateService, AlgorithmService, HomeScreenCardData>(
                          transformer: (snapshot, exchangeRateService, algorithmService) async {
                            final statData = await generateStatistics(
                              snapshot: snapshot,
                              algorithms: algorithmService.state,
                              exchangeRateService: exchangeRateService,
                            );
                            return HomeScreenCardData.fromStatistics(statData);
                          },
                          builder: (context, snapshot, _) {
                            if (snapshot.connectionState ==
                                    ConnectionState.none ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return const LoadingSpinner();
                            }
                            return Column(
                              children: [
                                //UPPER PART
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (checkPastMonth())
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            children: [
                                              Text(
                                                tr("home_screen_card.label-mtd-balance")
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: StyledAmount(
                                                    value: snapshot.data?.mtdBalance ??
                                                        0.00,
                                                    locale: context.locale,
                                                    symbol: accountSettingsService
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (checkPastMonth())
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  tr("home_screen_card.label-contracts")
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: StyledAmount(
                                                          value: snapshot.data
                                                                  ?.eomFutureSerialIncome ??
                                                              0.00,
                                                          locale: context.locale,
                                                          symbol: accountSettingsService
                                                              .getStandardCurrency()
                                                              .symbol,
                                                          fontSize:
                                                              StyledFontSize
                                                                  .compact,
                                                          fontPrefix:
                                                              StyledFontPrefix
                                                                  .alwaysPositive,
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: StyledAmount(
                                                          value: snapshot.data
                                                                  ?.eomFutureSerialExpenses ??
                                                              0.00,
                                                          locale: context.locale,
                                                          symbol: accountSettingsService
                                                              .getStandardCurrency()
                                                              .symbol,
                                                          fontPrefix:
                                                              StyledFontPrefix
                                                                  .alwaysNegative,
                                                          fontSize:
                                                              StyledFontSize
                                                                  .compact,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Flexible(
                                        flex: 6,
                                        fit: checkPastMonth()
                                            ? FlexFit.loose
                                            : FlexFit.tight,
                                        child: Column(
                                          children: [
                                            Text(
                                              tr("home_screen_card.label-eom-projected-balance")
                                                  .toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline,
                                            ),
                                            Expanded(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: StyledAmount(
                                                  value: snapshot.data?.eomBalance ??
                                                      0.00,
                                                  locale: context.locale,
                                                  symbol: accountSettingsService
                                                      .getStandardCurrency()
                                                      .symbol,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //LOWER PART
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        tr("home_screen_card.label-account-position-month")
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: StyledAmount(
                                                  value: snapshot.data
                                                          ?.tillBeginningOfMonthSumBalance ??
                                                      0.00,
                                                  locale: context.locale,
                                                  symbol: accountSettingsService
                                                      .getStandardCurrency()
                                                      .symbol,
                                                ),
                                              ),
                                            ),
                                            const IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.navigate_next_rounded,
                                              ),
                                            ),
                                            Flexible(
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: StyledAmount(
                                                  value: snapshot.data
                                                          ?.tillEndOfMonthSumBalance ??
                                                      0.00,
                                                  locale: context.locale,
                                                  symbol: accountSettingsService
                                                      .getStandardCurrency()
                                                      .symbol,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      //GO FORWARD IN TIME
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              goForwardInTime(algorithmService);
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
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
