//  Home Screen Listview - Specific ListView settings for the Home Screen
//
//  Author: SoTBurst, NightmindOfficial
//  Co-Author: thebluebaronx
//

// ignore_for_file: avoid_dynamic_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/balance/models/serial_transaction.dart';
import 'package:linum/core/balance/models/transaction.dart';
import 'package:linum/core/balance/utils/transaction_amount_formatter.dart';
import 'package:linum/core/balance/widgets/balance_data_list_view.dart';
import 'package:linum/features/currencies/models/currency.dart';
import 'package:linum/screens/budget_screen/widgets/time_widget.dart';
import 'package:linum/screens/home_screen/widgets/serial_transaction_tile.dart';
import 'package:linum/screens/home_screen/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = ListView();
  }

  final List<Map<String, dynamic>> _timeWidgets = <Map<String, dynamic>>[
    {
      "widget": const TimeWidget(displayValue: 'listview.label-today'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).add(const Duration(days: 1, microseconds: -1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview.label-yesterday'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(microseconds: 1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview.label-lastweek'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(days: 1, microseconds: 1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview.label-thismonth'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(days: 7, microseconds: 1))
    },
    // {
    //   "widget": TimeWidget(displayValue: 'Älter'),
    //   "time": DateTime(DateTime.now().year, DateTime.now().month)
    //       .subtract(Duration(days: 0, microseconds: 1))
    // },
  ];

  @override
  void setTransactions(
    List<Transaction> transactions, {
    required BuildContext context,
    bool error = false,
  }) {
    _listview = ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: buildTransactionList(context, transactions, error: error),
    );
  }

  @override
  void setSerialTransactions(
    List<SerialTransaction> serialTransactions, {
    required BuildContext context,
    bool error = false,
  }) {
    _listview = ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: buildSerialTransactionList(
        context,
        serialTransactions,
        error: error,
        // repeatedData: true,
      ),
    );
  }

  List<Widget> buildTransactionList(
    BuildContext context,
    List<Transaction> transactions, {
    bool error = false,
    bool repeatedData = false,
  }) {
    initializeDateFormatting();

    final String langCode = context.locale.languageCode;
    final DateFormat monthFormatter = DateFormat('MMMM', langCode);
    final DateFormat monthAndYearFormatter = DateFormat('MMMM yyyy', langCode);


    final amountFormatter = TransactionAmountFormatter(
      context.locale,
      context.watch<AccountSettingsService>().getStandardCurrency(),
    );
    // remember last used index in the list
    int currentIndex = 0;
    DateTime? currentTime;

    final List<Widget> list = [];
    if (error) {
      // TODO: tell user there was an error loading @damattl
    } else if (transactions.isEmpty) {
      list.add(const TimeWidget(displayValue: "listview.label-no-entries"));
    } else {
      for (final Transaction transaction in transactions) {
        final DateTime date = transaction.date.toDate();
        final bool isFutureItem = date.isAfter(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 1,
          ).subtract(const Duration(microseconds: 1)),
        );

        currentTime ??= DateTime(date.year, date.month + 2);
        if (isFutureItem) {
          if (date.isBefore(currentTime)) {
            var timeWidget = const TimeWidget(
              displayValue: "listview.label-future",
            );
            if (!(list.isEmpty && isCurrentMonth(date))) {
              timeWidget = TimeWidget(
                displayValue: date.year == DateTime.now().year
                    ? monthFormatter.format(date)
                    : monthAndYearFormatter.format(date),
                isTranslated: true,
              );
            }
            list.add(timeWidget);
            currentTime = DateTime(date.year, date.month);
          }
        } else if (currentIndex < _timeWidgets.length &&
            date.isBefore(_timeWidgets[currentIndex]["time"] as DateTime)) {
          currentTime = DateTime(DateTime.now().year, DateTime.now().month)
              .subtract(const Duration(microseconds: 1));
          while (currentIndex < (_timeWidgets.length - 1) &&
              date.isBefore(
                _timeWidgets[currentIndex + 1]["time"] as DateTime,
              )) {
            currentIndex++;
          }
          if (date.isBefore(_timeWidgets[currentIndex]["time"] as DateTime) &&
              date.isAfter(currentTime)) {
            list.add(_timeWidgets[currentIndex]["widget"] as Widget);
          }

          currentIndex++;
        }
        if (date.isBefore(DateTime.now()) &&
            (list.isEmpty || list.last.runtimeType != TimeWidget) &&
            date.isBefore(currentTime)) {
          final timeWidget = TimeWidget(
            displayValue: date.year == DateTime.now().year
                ? monthFormatter.format(date)
                : monthAndYearFormatter.format(date),
            isTranslated: true,
          );

          list.add(timeWidget);
          currentTime = DateTime(date.year, date.month - 1);

          currentIndex = 4; // idk why exactly but now we are save
        }

        list.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
            isFutureItem: isFutureItem,
          ),
        );
      }
    }
    return list;
  }

  List<Widget> buildSerialTransactionList(
    BuildContext context,
    List<SerialTransaction> serialTransactions, {
    bool error = false,
    // bool repeatedData = false,
  }) {
    final List<Widget> list = [];

    if (error) {
      // TODO: tell user there was an error loading @damattl
    } else if (serialTransactions.isEmpty) {
      list.add(const TimeWidget(displayValue: "listview.label-no-entries"));
    } else {
      bool wroteExpensesTag = false;
      bool wroteIncomeTag = false;

      for (final serTrans in serialTransactions) {
        if (!wroteExpensesTag && serTrans.amount <= 0) {
          list.add(
            const TimeWidget(displayValue: "home_screen_card.label-expenses"),
          );
          wroteExpensesTag = true;
        }
        if (!wroteIncomeTag && serTrans.amount > 0) {
          list.add(
            const TimeWidget(displayValue: "home_screen_card.label-income"),
          );
          wroteIncomeTag = true;
        }
        list.add(
          SerialTransactionTile(serialTransaction: serTrans),
        );
      }
    }

    return list;
  }

  bool isCurrentMonth(DateTime date) {
    return DateTime(date.year, date.month) ==
        DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  ListView get listview => _listview;
}
