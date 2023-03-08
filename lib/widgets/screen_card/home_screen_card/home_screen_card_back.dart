//  Home Screen Card Back - Back Side of the Home Screen Card with All-Time Metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/screen_card_provider.dart';
import 'package:linum/utilities/frontend/homescreen_card_time_warp.dart';
import 'package:linum/widgets/loading_spinner.dart';
import 'package:linum/widgets/screen_card/home_screen_functions.dart';
import 'package:linum/widgets/screen_card/screen_card_data_extensions.dart';
import 'package:linum/widgets/styled_amount.dart';
import 'package:provider/provider.dart';

class HomeScreenCardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);
    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat("MMM ''yy", langCode);

    final settings = Provider.of<AccountSettingsProvider>(context);
    final screenCardProvider =
        Provider.of<ScreenCardProvider>(context, listen: false);
    final balanceDataProvider = Provider.of<BalanceDataProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onFlipCardTap(context, screenCardProvider.controller!),
        onHorizontalDragEnd: (DragEndDetails details) =>
            onHorizontalDragEnd(details, context),
        onLongPress: () => goToCurrentTime(algorithmProvider),
        child: Stack(
          children: [
            //Switch Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4.0),
                onPressed: () {
                  screenCardProvider.controller?.toggleCard();
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
                    "Monatsplaner | ${dateFormat.format(algorithmProvider.currentShownMonth)}", //TODO @NightmindOfficial translate!
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
                              goBackInTime(algorithmProvider);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                        ],
                      ),

                      //KPI COLUMN
                      Expanded(
                        //STREAM INSERT
                        child: StreamBuilder<HomeScreenCardData>(
                          stream: balanceDataProvider.getHomeScreenCardData(),
                          builder: (context, snapshot) {
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
                                    children: [
                                      Flexible(
                                        flex: 6,
                                        fit: FlexFit.tight,
                                        child: ColoredBox(
                                          //TODO REMOVE BEFORE FLIGHT
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Bilanz bisher".toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: StyledAmount(
                                                    snapshot.data?.mtdBalance ??
                                                        0.00,
                                                    context.locale,
                                                    settings
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 6,
                                        fit: FlexFit.tight,
                                        child: ColoredBox(
                                          //TODO REMOVE BEFORE FLIGHT
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "± Verträge".toUpperCase(),
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
                                                          snapshot.data
                                                                  ?.eomFutureSerialIncome ??
                                                              0.00,
                                                          context.locale,
                                                          settings
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
                                                          snapshot.data
                                                                  ?.eomFutureSerialExpenses ??
                                                              0.00,
                                                          context.locale,
                                                          settings
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
                                      ),
                                      Flexible(
                                        flex: 6,
                                        fit: FlexFit.tight,
                                        child: ColoredBox(
                                          //TODO REMOVE BEFORE FLIGHT
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Text(
                                                "= Endbilanz".toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .overline,
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: StyledAmount(
                                                    snapshot.data?.eomBalance ??
                                                        0.00,
                                                    context.locale,
                                                    settings
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //LOWER PART
                                Expanded(
                                  flex: 4,
                                  child: ColoredBox(
                                    color: Colors
                                        .transparent, //TODO REMOVE BEFORE FLIGHT
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Kontostand Monatsanfang bis -ende"
                                              .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline,
                                        ),
                                        Expanded(
                                          child: ColoredBox(
                                            //TODO REMOVE BEFORE FLIGHT
                                            color: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: StyledAmount(
                                                      snapshot.data
                                                              ?.tillBeginningOfMonthSumBalance ??
                                                          0.00,
                                                      context.locale,
                                                      settings
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
                                                      snapshot.data
                                                              ?.tillEndOfMonthSumBalance ??
                                                          0.00,
                                                      context.locale,
                                                      settings
                                                          .getStandardCurrency()
                                                          .symbol,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                              goForwardInTime(algorithmProvider);
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
