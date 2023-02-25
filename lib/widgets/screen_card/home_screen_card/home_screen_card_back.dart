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
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);

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
                Text(
                  textAlign: TextAlign.center,
                  "Monatsplanung | Feb '23", //TODO @NightmindOfficial translate!
                  style: MediaQuery.of(context).size.height < 650
                      ? Theme.of(context).textTheme.headline5
                      : Theme.of(context).textTheme.headline4,
                ),

                //Card Content
                Expanded(
                  child: ColoredBox(
                    color: Colors.yellow, //TODO REMOVE BEFORE FLIGHT

                    //MOTHER ROW

                    child: Row(
                      children: [
                        //GO BACK IN TIME
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                goBackInTime(algorithmProvider);
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
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
                                    child: ColoredBox(
                                      //TODO REMOVE BEFORE FLIGHT
                                      color: Colors.purple,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Flexible(
                                            flex: 6,
                                            fit: FlexFit.tight,
                                            child: ColoredBox(
                                              //TODO REMOVE BEFORE FLIGHT
                                              color: Colors.teal,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Bilanz bisher"
                                                        .toUpperCase(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .overline,
                                                  ),
                                                  StyledAmount(
                                                    -420.69,
                                                    context.locale,
                                                    settings
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 8,
                                            fit: FlexFit.tight,
                                            child: ColoredBox(
                                              //TODO REMOVE BEFORE FLIGHT
                                              color: Colors.lightBlueAccent,
                                              child: Column(
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                      "± ausstehende Verträge"
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .overline,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  StyledAmount(
                                                    -42.69,
                                                    context.locale,
                                                    settings
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                  StyledAmount(
                                                    42.69,
                                                    context.locale,
                                                    settings
                                                        .getStandardCurrency()
                                                        .symbol,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //LOWER PART
                                  Expanded(
                                    flex: 4,
                                    child: ColoredBox(
                                      color: Colors.lightGreen,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            "= aktueller Kontostand"
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .overline,
                                          ),
                                          StyledAmount(
                                            -420.69,
                                            context.locale,
                                            settings
                                                .getStandardCurrency()
                                                .symbol,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
