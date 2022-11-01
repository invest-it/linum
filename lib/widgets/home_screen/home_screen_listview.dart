//  Home Screen Listview - Specific ListView settings for the Home Screen
//
//  Author: SoTBurst
//  Co-Author: thebluebaronx, NightmindOfficial
//

// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/repeat_balance_data.dart';
import 'package:linum/models/single_balance_data.dart';
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
  void setSingleBalanceData(
    List<SingleBalanceData> balanceDataList, {
    required BuildContext context,
    bool error = false,
  }) {
    _listview = ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: buildSingleBalanceList(context, balanceDataList, error: error),
    );
  }

  @override
  void setRepeatedBalanceData(
    List<RepeatedBalanceData> balanceDataList, {
    required BuildContext context,
    bool error = false,
  }) {
    _listview = ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: buildRepeatedBalanceList(
        context,
        balanceDataList,
        error: error,
        repeatedData: true,
      ),
    );
  }

  List<Widget> buildSingleBalanceList(
    BuildContext context,
    List<SingleBalanceData> balanceDataList, {
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
    } else if (balanceDataList.isEmpty) {
      list.add(const TimeWidget(displayValue: "listview.label-no-entries"));
    } else {
      for (final SingleBalanceData singleBalanceData in balanceDataList) {
        final DateTime date = singleBalanceData.time.toDate();
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
          buildSingleBalanceGestureDetector(
            context,
            singleBalanceData,
            isFutureItem: isFutureItem,
          ),
        );
      }
    }
    return list;
  }

  List<Widget> buildRepeatedBalanceList(
    BuildContext context,
    List<RepeatedBalanceData> balanceDataList, {
    bool error = false,
    bool repeatedData = false,
  }) {
    log(balanceDataList.toString());
    final List<Widget> list = [const Text("W.I.P.")];

    return list;
  }

  /// Builds a [GestureDetector] for displaying a single balance on the home screen. Below, there is another function for handling the active contracts display.
  GestureDetector buildSingleBalanceGestureDetector(
    BuildContext context,
    SingleBalanceData singleBalanceData, {
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
          settings: EnterScreenPageSettings.withBalanceData(singleBalanceData),
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
        key: Key(singleBalanceData.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.5,
        },
        confirmDismiss: (DismissDirection direction) async {
          return generateDeleteDialogFromSingleBalanceData(
            context,
            balanceDataProvider,
            singleBalanceData,
          );
        },
        child: ListTile(
          leading: Badge(
            padding: const EdgeInsets.all(2),
            toAnimate: false,
            position: const BadgePosition(bottom: 23, start: 23),
            elevation: 1,
            badgeColor: isFutureItem && singleBalanceData.repeatId != null
                ? Theme.of(context).colorScheme.tertiaryContainer
                //badgeColor for current transactions
                : singleBalanceData.amount > 0
                    //badgeColor for future transactions
                    ? singleBalanceData.repeatId != null
                        ? Theme.of(context).colorScheme.tertiary
                        // ignore: use_full_hex_values_for_flutter_colors
                        : const Color(0x000000)
                    : singleBalanceData.repeatId != null
                        ? Theme.of(context).colorScheme.errorContainer
                        // ignore: use_full_hex_values_for_flutter_colors
                        : const Color(0x000000),
            //cannot use the suggestion as it produces an unwanted white point
            badgeContent: singleBalanceData.repeatId != null
                ? Icon(
                    Icons.autorenew_rounded,
                    color: isFutureItem
                        ? singleBalanceData.amount > 0
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                    size: 18,
                  )
                : const SizedBox(),
            child: CircleAvatar(
              backgroundColor: isFutureItem
                  ? singleBalanceData.amount > 0
                      ? Theme.of(context)
                          .colorScheme
                          .tertiary // FUTURE INCOME BACKGROUND
                      : Theme.of(context).colorScheme.errorContainer
                  // FUTURE EXPENSE BACKGROUND
                  : singleBalanceData.amount > 0
                      ? Theme.of(context)
                          .colorScheme
                          .secondary // PRESENT INCOME BACKGROUND
                      : Theme.of(context)
                          .colorScheme
                          .secondary, // PRESENT EXPENSE BACKGROUND
              child: singleBalanceData.amount > 0
                  ? Icon(
                      standardIncomeCategories[singleBalanceData.category]
                              ?.icon ??
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
                      standardExpenseCategories[singleBalanceData.category]
                              ?.icon ??
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
            singleBalanceData.name != ""
                ? singleBalanceData.name
                : translateCategory(
                    singleBalanceData.category,
                    context,
                    isExpense: singleBalanceData.amount <= 0,
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
                  singleBalanceData.time.toDate(),
                )
                .toUpperCase(),
            style: isFutureItem
                ? Theme.of(context).textTheme.overline!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                : Theme.of(context).textTheme.overline,
          ),
          trailing: singleBalanceData.amount == 0
              ? Text(
                  tr('home_screen.free-text'),
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              : Text(
                  "${singleBalanceData.amount.toStringAsFixed(2)}€",
                  style: singleBalanceData.amount <= 0
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
  GestureDetector buildRepeatedBalanceGestureDetector(
    BuildContext context,
    RepeatedBalanceData repeatedBalanceData,
  ) {
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);
    final String langCode = context.locale.languageCode;
    final DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', langCode);

    return GestureDetector(
      onTap: () {
        // TODO implement custom edit screen handling here
        // getRouterDelegate().pushRoute(
        //   MainRoute.enter,
        //   settings: EnterScreenPageSettings.withBalanceData(singleBalanceData),
        // );
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
        key: Key(repeatedBalanceData.id),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {
          DismissDirection.endToStart: 0.5,
        },
        confirmDismiss: (DismissDirection direction) async {
          return generateDeleteDialogFromRepetableBalanceData(
            //FIXME: @SoTBurst
            context,
            balanceDataProvider,
            repeatedBalanceData,
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: repeatedBalanceData.amount > 0
                ? Theme.of(context)
                    .colorScheme
                    .tertiary // FUTURE INCOME BACKGROUND
                : Theme.of(context).colorScheme.errorContainer,
            child: repeatedBalanceData.amount > 0
                ? Icon(
                    standardIncomeCategories[repeatedBalanceData.category]
                            ?.icon ??
                        Icons.error,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary, // PRESENT INCOME ICON
                  )
                : Icon(
                    standardExpenseCategories[repeatedBalanceData.category]
                            ?.icon ??
                        Icons.error,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
          ),
          title: Text(
            repeatedBalanceData.name != ""
                ? repeatedBalanceData.name
                : translateCategory(
                    repeatedBalanceData.category,
                    context,
                    isExpense: repeatedBalanceData.amount <= 0,
                  ),
            style: Theme.of(context).textTheme.bodyText1,
          ),
          //TODO FIX THIS ASAP!!!
          // subtitle: Text(
          //   formatter
          //       .format(
          //         // repeatedBalanceData.time.toDate(), singleBalanceData.amount == 0 TODO Implement the following format: "27,99€ alle 7 Tage" oder "3,50 täglich"
          //       )
          //       .toUpperCase(),
          //   style: Theme.of(context).textTheme.overline,
          // ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: () => {},
          ), //TODO implement Edit function
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
      return tr(standardExpenseCategories[category]?.label ?? "");
      // TODO @Nightmind you could add a String here that will show something like "error translating your category"
    } else if (!isExpense) {
      return tr(standardIncomeCategories[category]?.label ?? "");
      // TODO @Nightmind you could add a String here that will show something like "error translating your category"
    }
    return "Error"; // This should never happen.
  }

  @override
  ListView get listview => _listview;
}
