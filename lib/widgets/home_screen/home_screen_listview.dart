//  Home Screen Listview - Specific ListView settings for the Home Screen
//
//  Author: SoTBurst, NightmindOfficial
//  Co-Author: thebluebaronx
//

// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/serial_transaction.dart';
import 'package:linum/models/transaction.dart';
import 'package:linum/navigation/enter_screen_page.dart';
import 'package:linum/navigation/get_delegate.dart';
import 'package:linum/navigation/main_routes.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';
import 'package:linum/widgets/enter_screen/delete_entry_dialog.dart';
import 'package:provider/provider.dart';

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
        final DateTime date = transaction.time.toDate();
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
          buildTransaction(
            context,
            transaction,
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
        list.add(buildSerialTransaction(context, serTrans));
      }
    }

    return list;
  }

  /// Builds a [GestureDetector] for displaying a single balance on the home screen. Below, there is another function for handling the active contracts display.
  GestureDetector buildTransaction(
    BuildContext context,
    Transaction transaction, {
    bool isFutureItem = false,
  }) {
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);
    final String langCode = context.locale.languageCode;
    final DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', langCode);

    return GestureDetector(
      onTap: () {
        getRouterDelegate().pushRoute(
          MainRoute.enter,
          settings: EnterScreenPageSettings.withTransaction(transaction),
        );
      },
      child: Dismissible(
        background: ColoredBox(
          color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16.0,
                  children: [
                    Text(
                      tr("listview.dismissible.label-delete"),
                      style: Theme.of(context).textTheme.button,
                    ),
                    Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.5,
        },
        confirmDismiss: (DismissDirection direction) async {
          return generateDeleteDialogFromTransaction(
            context,
            balanceDataProvider,
            transaction,
          );
        },
        child: ListTile(
          leading: Badge(
            padding: const EdgeInsets.all(2),
            toAnimate: false,
            position: const BadgePosition(bottom: 23, start: 23),
            elevation: 1,
            badgeColor: isFutureItem && transaction.repeatId != null
                ? Theme.of(context).colorScheme.tertiaryContainer
                //badgeColor for current transactions
                : transaction.amount > 0
                    //badgeColor for future transactions
                    ? transaction.repeatId != null
                        ? Theme.of(context).colorScheme.tertiary
                        // ignore: use_full_hex_values_for_flutter_colors
                        : const Color(0x000000)
                    : transaction.repeatId != null
                        ? Theme.of(context).colorScheme.errorContainer
                        // ignore: use_full_hex_values_for_flutter_colors
                        : const Color(0x000000),
            //cannot use the suggestion as it produces an unwanted white point
            badgeContent: transaction.repeatId != null
                ? Icon(
                    Icons.autorenew_rounded,
                    color: isFutureItem
                        ? transaction.amount > 0
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                    size: 18,
                  )
                : const SizedBox(),
            child: CircleAvatar(
              backgroundColor: isFutureItem
                  ? transaction.amount > 0
                      ? Theme.of(context)
                          .colorScheme
                          .tertiary // FUTURE INCOME BACKGROUND
                      : Theme.of(context).colorScheme.errorContainer
                  // FUTURE EXPENSE BACKGROUND
                  : transaction.amount > 0
                      ? Theme.of(context)
                          .colorScheme
                          .secondary // PRESENT INCOME BACKGROUND
                      : Theme.of(context)
                          .colorScheme
                          .secondary, // PRESENT EXPENSE BACKGROUND
              child: transaction.amount > 0
                  ? Icon(
                      standardIncomeCategories[transaction.category]?.icon ??
                          Icons.error,
                      color: isFutureItem
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary // FUTURE INCOME ICON
                          : Theme.of(context)
                              .colorScheme
                              .tertiary, // PRESENT INCOME ICON
                    )
                  : Icon(
                      standardExpenseCategories[transaction.category]?.icon ??
                          Icons.error,
                      color: isFutureItem
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary // FUTURE EXPENSE ICON
                          : Theme.of(context)
                              .colorScheme
                              .errorContainer, // PRESENT EXPENSE ICON
                    ),
            ),
          ),
          title: Text(
            transaction.name != ""
                ? transaction.name
                : translateCategory(
                    transaction.category,
                    context,
                    isExpense: transaction.amount <= 0,
                  ),
            style: isFutureItem
                ? Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                : Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            formatter
                .format(
                  transaction.time.toDate(),
                )
                .toUpperCase(),
            style: isFutureItem
                ? Theme.of(context).textTheme.overline!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                : Theme.of(context).textTheme.overline,
          ),
          trailing: transaction.amount == 0
              ? Text(
                  tr('home_screen.free-text'),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : Text(
                  "${transaction.amount.toStringAsFixed(2)}€",
                  style: transaction.amount <= 0
                      ? Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          )
                      : Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                ),
        ),
      ),
    );
  }

  /// As mentioned above, this function handles the active contracts display.
  Material buildSerialTransaction(
    BuildContext context,
    SerialTransaction serialTransaction,
  ) {
    final String langCode = context.locale.languageCode;
    final DateFormat serialFormatter = DateFormat('dd.MM.yyyy', langCode);

    return Material(
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: serialTransaction.amount > 0
              ? Theme.of(context)
                  .colorScheme
                  .tertiary // FU-TURE INCOME BACKGROUND
              : Theme.of(context).colorScheme.errorContainer,
          child: serialTransaction.amount > 0
              ? Icon(
                  standardIncomeCategories[serialTransaction.category]?.icon ??
                      Icons.error,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary, // PRESENT INCOME ICON
                )
              : Icon(
                  standardExpenseCategories[serialTransaction.category]?.icon ??
                      Icons.error,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
        ),
        title: Text(
          serialTransaction.name != ""
              ? serialTransaction.name
              : translateCategory(
                  serialTransaction.category,
                  context,
                  isExpense: serialTransaction.amount <= 0,
                ),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        subtitle: Text(
          "${calculateTimeFrequency(serialTransaction)} \nSeit ${serialFormatter.format(serialTransaction.initialTime.toDate())}"
              .toUpperCase(),
          style: Theme.of(context).textTheme.overline,
        ),
        trailing: IconButton(
          splashRadius: 24.0,
          icon: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => {
            getRouterDelegate().pushRoute(
              MainRoute.enter,
              settings: EnterScreenPageSettings.withSerialTransaction(
                serialTransaction,
              ),
            ),
          },
        ),
      ),
    );
  }

  bool isCurrentMonth(DateTime date) {
    return DateTime(date.year, date.month) ==
        DateTime(DateTime.now().year, DateTime.now().month);
  }

  String translateCategory(
    String category,
    BuildContext context, {
    required bool isExpense,
  }) {
    if (isExpense) {
      return tr(
        standardExpenseCategories[category]?.label ??
            tr('listview.label-error-translation'),
      );
    } else if (!isExpense) {
      return tr(
        standardIncomeCategories[category]?.label ??
            tr('listview.label-error-translation'),
      );
    }
    return "Error"; // This should never happen.
  }

  String calculateTimeFrequency(
    SerialTransaction serialTransaction,
  ) {
    final int duration = serialTransaction.repeatDuration;
    final RepeatDurationType repeatDurationType =
        serialTransaction.repeatDurationType;
    final String amount = serialTransaction.amount.abs().toStringAsFixed(2);

    switch (repeatDurationType) {
      case RepeatDurationType.seconds:
        //The following constants represent the seconds equivalent of the respecive timeframes - to make the following if-else clause easier to understand
        const int week = 604800;
        const int day = 86400;

        // If the repeatDuration is on a weekly basis
        if (duration % week == 0) {
          if (duration / week == 1) {
            return "$amount€ ${tr('enter_screen.label-repeat-weekly')}";
          }
          return "${tr('listview.label-every')} ${(duration / day).floor()} ${tr('listview.label-weeks')}";
        }

        // If the repeatDuration is on a daily basis
        else if (duration % day == 0) {
          if (duration / day == 1) {
            return "$amount€ ${tr('enter_screen.label-repeat-daily')}";
          }
          return "${tr('listview.label-every')} ${(duration / day).floor()} ${tr('listview.label-days')}";
        } else {
          //This should never happen, but just in case (if we forget to cap the repeat duration to at least one day)
          return tr('main.label-error');
        }

      // If the repeatDuration is on a monthly / yearly basis
      case RepeatDurationType.months:
        if (duration % 12 == 0) {
          if (duration / 12 == 1) {
            return "$amount€ ${tr('enter_screen.label-repeat-annually')}";
          }
          return "${tr('listview.label-every')} ${(duration / 12).floor()} ${tr('listview.label-years')}";
        }
        if (duration == 1) {
          return "$amount€ ${tr('enter_screen.label-repeat-30days')}";
        } else if (duration == 3) {
          return "$amount€ ${tr('enter_screen.label-repeat-quarterly')}";
        } else if (duration == 6) {
          return "$amount€ ${tr('enter_screen.label-repeat-semiannually')}";
        }
        return "${tr('listview.label-every')} ${(duration / 12).floor()} ${tr('listview.label-months')}";
    }
  }

  @override
  ListView get listview => _listview;
}
