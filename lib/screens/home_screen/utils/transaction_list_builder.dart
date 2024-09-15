import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/date_time_extensions.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/balance/presentation/transaction_amount_formatter.dart';
import 'package:linum/screens/home_screen/enums/time_widget_date.dart';
import 'package:linum/screens/home_screen/widgets/time_widget.dart';
import 'package:linum/screens/home_screen/widgets/transaction_tile.dart';


List<Widget> _mergeLists(List<List<Widget>> lists) {
  final merged = <Widget>[];
  for (final list in lists) {
    if (list.length == 1) {
      continue;
    }
    merged.addAll(list);
  }
  return merged;
}

List<Widget> generateTransactionList({
  required BuildContext context,
  required List<Transaction> transactions,
  required TransactionAmountFormatter amountFormatter,
  required DateTime shownMonth,
}) {

  final String langCode = context.locale.languageCode;
  final DateFormat monthFormatter = DateFormat('MMMM', langCode);
  final DateFormat monthAndYearFormatter = DateFormat('MMMM yyyy', langCode);

  final List<Widget> futureList =
    shownMonth.isCurrentMonth()
      ? [const TimeWidget(timeWidgetDate: TimeWidgetDate.future,)]
      : [TimeWidget(
    label: shownMonth.year == DateTime.now().year
        ? monthFormatter.format(shownMonth)
        : monthAndYearFormatter.format(shownMonth),
    isTranslated: true,
  ),];

  final List<Widget> pastList = [
    TimeWidget(
      label: shownMonth.year == DateTime.now().year
          ? monthFormatter.format(shownMonth)
          : monthAndYearFormatter.format(shownMonth),
      isTranslated: true,
    ),
  ];

  final List<Widget> todayList = [
    const TimeWidget(
      timeWidgetDate: TimeWidgetDate.today,
    ),
  ];

  final List<Widget> yesterdayList = [
    const TimeWidget(
      timeWidgetDate: TimeWidgetDate.yesterday,
    ),
  ];

  final List<Widget> lastWeekList = [
    const TimeWidget(
      timeWidgetDate: TimeWidgetDate.lastWeek,
    ),
  ];

  final List<Widget> thisMonthList = [
    const TimeWidget(
      timeWidgetDate: TimeWidgetDate.thisMonth,
    ),
  ];


  if (transactions.isEmpty) {
    return [
      const TimeWidget(timeWidgetDate: TimeWidgetDate.none),
    ];
  } else {
    for (final transaction in transactions) {
      final date = transaction.date;

      if (date.isInFuture() && date.isAfter(TimeWidgetDate.today.toDate()!)) {
        futureList.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
          ),
        );
        continue;
      }
      // if date is before current month
      if (date.month < DateTime.now().month
          && date.year <= DateTime.now().year) {
        pastList.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
          ),
        );
        continue;
      }

      if (date.isAfter(TimeWidgetDate.yesterday.toDate()!)) {
        todayList.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
          ),
        );
        continue;
      }
      if (date.isAfter(TimeWidgetDate.lastWeek.toDate()!)) {
        yesterdayList.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
          ),
        );
        continue;
      }
      if (date.isAfter(TimeWidgetDate.thisMonth.toDate()!)) {
        lastWeekList.add(
          TransactionTile(
            transaction: transaction,
            amountFormatter: amountFormatter,
          ),
        );
        continue;
      }
      thisMonthList.add(
        TransactionTile(
          transaction: transaction,
          amountFormatter: amountFormatter,
        ),
      );

    }

    return _mergeLists([
      futureList,
      todayList,
      yesterdayList,
      lastWeekList,
      thisMonthList,
      pastList,
    ]);
  }
}
