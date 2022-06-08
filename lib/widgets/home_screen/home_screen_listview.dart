//  Home Screen Listview - Specific ListView settings for the Home Screen
//
//  Author: SoTBurst
//  Co-Author: thebluebaronx, NightmindOfficial
//

// ignore_for_file: avoid_dynamic_calls

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/single_balance_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/delete_entry_popup.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';
import 'package:provider/provider.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = ListView();
  }

  final List<Map<String, dynamic>> _timeWidgets = <Map<String, dynamic>>[
    {
      "widget": const TimeWidget(displayValue: 'listview/label-today'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).add(const Duration(days: 1, microseconds: -1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview/label-yesterday'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(microseconds: 1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview/label-lastweek'),
      "time": DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(const Duration(days: 1, microseconds: 1))
    },
    {
      "widget": const TimeWidget(displayValue: 'listview/label-thismonth'),
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
  void setBalanceData(
    List<SingleBalanceData> balanceData, {
    required BuildContext context,
    bool error = false,
  }) {
    initializeDateFormatting();

    final String langCode = AppLocalizations.of(context)!.locale.languageCode;

    final DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', langCode);

    final DateFormat monthFormatter = DateFormat('MMMM', langCode);
    final DateFormat monthAndYearFormatter = DateFormat('MMMM yyyy', langCode);
    final BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    // remember last used index in the list
    int currentIndex = 0;
    DateTime? currentTime;

    //log(balanceData.toString());
    final List<Widget> list = [];
    if (error) {
      // TODO: tell user there was an error loading @damattl
    } else if (balanceData.isEmpty) {
      list.add(const TimeWidget(displayValue: "listview/label-no-entries"));
    } else {
      for (final SingleBalanceData singleBalanceData in balanceData) {
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
            if (list.isEmpty &&
                DateTime(date.year, date.month) ==
                    DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                    )) {
              list.add(
                const TimeWidget(
                  displayValue: "listview/label-future",
                ),
              );
            } else {
              list.add(
                TimeWidget(
                  displayValue: date.year == DateTime.now().year
                      ? monthFormatter.format(date)
                      : monthAndYearFormatter.format(date),
                  isTranslated: true,
                ),
              );
            }
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
          list.add(
            TimeWidget(
              displayValue: date.year == DateTime.now().year
                  ? monthFormatter.format(date)
                  : monthAndYearFormatter.format(date),
              isTranslated: true,
            ),
          );
          currentTime = DateTime(date.year, date.month - 1);

          currentIndex = 4; // idk why exactly but now we are save
        }

        list.add(
          GestureDetector(
            onTap: () {
              final BalanceDataProvider balanceDataProvider =
                  Provider.of<BalanceDataProvider>(context, listen: false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (innerContext) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<EnterScreenProvider>(
                          create: (_) {
                            return EnterScreenProvider(
                              id: singleBalanceData.id,
                              amount: singleBalanceData.amount,
                              category: singleBalanceData.category,
                              name: singleBalanceData.name,
                              selectedDate: (singleBalanceData.time).toDate(),
                              editMode: true,
                              repeatId: singleBalanceData.repeatId,
                              formerTime: singleBalanceData.formerTime ??
                                  singleBalanceData.time,
                            );
                          },
                        ),
                        ChangeNotifierProvider<BalanceDataProvider>(
                          create: (_) {
                            return balanceDataProvider..dontDisposeOneTime();
                          },
                        ),
                        ChangeNotifierProvider<AccountSettingsProvider>(
                          create: (_) {
                            return accountSettingsProvider
                              ..dontDisposeOneTime();
                          },
                        ),
                      ],
                      child: const EnterScreen(),
                    );
                  },
                ),
              );
            },
            //print(arrayElement["amount"].toString()),
            child: Dismissible(
              background: Container(
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
                            AppLocalizations.of(context)!.translate(
                              "listview/dismissible/label-delete",
                            ),
                            style: Theme.of(context).textTheme.button,
                          ),
                          Icon(
                            Icons.delete,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
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
                return generateDeletePopupFromSingleBalanceData(
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
                              : Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
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
                            standardCategoryIncomes[singleBalanceData.category]
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
                            standardCategoryExpenses[singleBalanceData.category]
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
                        AppLocalizations.of(context)!
                            .translate('home_screen/free-text'),
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Text(
                        "${singleBalanceData.amount.toStringAsFixed(2)}€",
                        style: singleBalanceData.amount <= 0
                            ? Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                )
                            : Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                      ),
              ),
            ),
          ),
        );
      }
    }

    _listview = ListView(
      padding: const EdgeInsets.only(
        bottom: 32.0,
      ),
      children: list,
    );
  }

  String translateCategory(
    String category,
    BuildContext context, {
    required bool isExpense,
  }) {
    if (isExpense) {
      return AppLocalizations.of(context)!.translate(
        standardCategoryExpenses[category]?.label ?? "",
      ); // TODO @Nightmind you could add a String here that will show something like "error translating your category"
    } else if (!isExpense) {
      return AppLocalizations.of(context)!.translate(
        standardCategoryIncomes[category]?.label ?? "",
      ); // TODO @Nightmind you could add a String here that will show something like "error translating your category"
    }
    return "Error"; // This should never happen.
  }

  @override
  ListView get listview => _listview;
}
