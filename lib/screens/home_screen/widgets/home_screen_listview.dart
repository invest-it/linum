//  Home Screen Listview - Specific ListView settings for the Home Screen
//
//  Author: SoTBurst, NightmindOfficial
//  Co-Author: thebluebaronx
//

// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/common/widgets/loading_spinner.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/utils/balance_data_processors.dart';
import 'package:linum/core/balance/widgets/balance_data_stream_consumer.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:linum/screens/home_screen/widgets/serial_transaction_list_view.dart';
import 'package:linum/screens/home_screen/widgets/transaction_list_view.dart';
import 'package:logger/logger.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class HomeScreenListView extends StatelessWidget {
  final bool showSerialTransactions;
  const HomeScreenListView({super.key, this.showSerialTransactions = false});



  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();

    return BalanceDataStreamConsumer3<
        ExchangeRateService,
        AlgorithmService,
        PreparedBalanceData
    >(
      transformer: (snapshot, exchangeRateService, algorithmService) async {
        return processBalanceData(
          snapshot: snapshot,
          algorithms: algorithmService.state,
          exchangeRateService: exchangeRateService,
        );
      },
      builder: (context, snapshot, _) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        if (snapshot.data == null) {
          // TODO tell the user that the connection is broken
          Logger().e("ERROR LOADING");
          return const TransactionListView(transactions: [],);
        } else {
          if (showSerialTransactions) {
            return SerialTransactionListView(
              serialTransactions: snapshot.data!.item2,
            );
          }
          return TransactionListView(
            transactions: snapshot.data!.item1,
          );
        }
      },
    );
  }
}
