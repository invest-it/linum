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
import 'package:linum/widgets/screen_card/card_widgets/home_screen_card_avatar.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_overline_header_row.dart';
import 'package:linum/widgets/screen_card/home_screen_card/home_screen_card_row.dart';
import 'package:linum/widgets/screen_card/home_screen_functions.dart';
import 'package:linum/widgets/screen_card/screen_card_data_extensions.dart';
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
                Text(
                  textAlign: TextAlign.center,
                  "Monatsplanung | Feb '23", //TODO @NightmindOfficial translate!
                  style: MediaQuery.of(context).size.height < 650
                      ? Theme.of(context).textTheme.headline5
                      : Theme.of(context).textTheme.headline4,
                ),
                Flexible(
                  child: ColoredBox(
                    color: Colors.yellow, //TODO REMOVE BEFORE FLIGHT
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            goBackInTime(algorithmProvider);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              StreamBuilder<HomeScreenCardData>(
                                stream:
                                    balanceDataProvider.getHomeScreenCardData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.none ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return const LoadingSpinner();
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      const Text("EOM"),
                                      Column(
                                        children: const [
                                          Text("Plus"),
                                          Text("Minus"),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                              //LOWER OVERLINE HEADER HERE
                              const HomeScreenCardOverlineHeaderRow(
                                ["= aktueller Kontostand"],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            goForwardInTime(algorithmProvider);
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
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



// CURRENCY FORMATTER TEMPLATE 


// CurrencyFormatter(
//                         context.locale,
//                         symbol: settings.getStandardCurrency().symbol,
//                       ).formatWithWidgets(
//                         snapshot.data?.eomBalance ?? 0,
//                         (amount) => Flexible(
//                           child: FittedBox(
//                             fit: BoxFit.scaleDown,
//                             child: Text(
//                               amount,
//                               style: getBalanceTextStyle(
//                                   context, snapshot.data?.eomBalance ?? 0),
//                             ),
//                           ),
//                         ),
//                         (symbol) => Text(
//                           symbol,
//                           style: Theme.of(context).textTheme.bodyText1,
//                         ),
//                       ),
