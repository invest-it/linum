// ignore_for_file: implementation_imports

import 'dart:developer';
import 'dart:math' as Math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/screens/enter_screen.dart';
import 'package:linum/widgets/abstract/balance_data_list_view.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';
import 'package:provider/provider.dart';

class HomeScreenListView implements BalanceDataListView {
  late ListView _listview;

  HomeScreenListView() {
    _listview = new ListView();
  }

  List<Map<String, dynamic>> _timeWidgets = [
    {
      "widget": TimeWidget(displayValue: 'listview/label-today'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(Duration(days: 1, microseconds: -1))
    },
    {
      "widget": TimeWidget(displayValue: 'listview/label-yesterday'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 0, microseconds: 1))
    },
    {
      "widget": TimeWidget(displayValue: 'listview/label-lastweek'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 1, microseconds: 1))
    },
    {
      "widget": TimeWidget(displayValue: 'listview/label-thismonth'),
      "time": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: 7, microseconds: 1))
    },
    // {
    //   "widget": TimeWidget(displayValue: 'Älter'),
    //   "time": DateTime(DateTime.now().year, DateTime.now().month)
    //       .subtract(Duration(days: 0, microseconds: 1))
    // },
  ];

  @override
  void setBalanceData(List<dynamic> balanceData,
      {required BuildContext context}) {
    initializeDateFormatting();
    DateFormat formatter = DateFormat('EEEE, dd. MMMM yyyy', 'de');

    DateFormat monthFormatter = DateFormat('MMMM', 'de');
    DateFormat monthAndYearFormatter = DateFormat('MMMM yyyy', 'de');
    BalanceDataProvider balanceDataProvider =
        Provider.of<BalanceDataProvider>(context);

    AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    // remember last used index in the list
    int currentIndex = 0;
    DateTime? currentTime;

    //log(balanceData.toString());
    List<Widget> list = [];
    if (balanceData.length == 0) {
      list.add(TimeWidget(displayValue: "listview/label-no-entries"));
    } else if (balanceData[0] != null && balanceData[0]["Error"] == null) {
      balanceData.forEach(
        (arrayElement) {
          DateTime date = arrayElement["time"].toDate() as DateTime;
          if (currentTime == null) {
            currentTime = DateTime(date.year, date.month + 2);
          }
          if (date.isAfter(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ))) {
            if (date.isBefore(currentTime!)) {
              list.add(TimeWidget(
                displayValue: date.year == DateTime.now().year
                    ? monthFormatter.format(date)
                    : monthAndYearFormatter.format(date),
                isTranslated: false,
              ));
              currentTime = DateTime(date.year, date.month);
            }
          } else if (currentIndex < _timeWidgets.length &&
              date.isBefore(_timeWidgets[currentIndex]["time"])) {
            currentTime = DateTime(DateTime.now().year, DateTime.now().month)
                .subtract(Duration(days: 0, microseconds: 1));
            while (currentIndex < (_timeWidgets.length - 1) &&
                date.isBefore(_timeWidgets[currentIndex + 1]["time"])) {
              currentIndex++;
            }
            if (date.isBefore(_timeWidgets[currentIndex]["time"]) &&
                date.isAfter(currentTime!)) {
              list.add(_timeWidgets[currentIndex]["widget"]);
            }

            currentIndex++;
          }
          if (date.isBefore(DateTime.now()) &&
              (list.length == 0 || list.last.runtimeType != TimeWidget) &&
              date.isBefore(currentTime!)) {
            list.add(TimeWidget(
                displayValue: date.year == DateTime.now().year
                    ? monthFormatter.format(date)
                    : monthAndYearFormatter.format(date),
                isTranslated: false));
            currentTime = DateTime(date.year, date.month - 1);

            currentIndex = 4; // idk why exactly but now we are save
          }

          list.add(
            GestureDetector(
              onTap: () {
                BalanceDataProvider balanceDataProvider =
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
                                amount: arrayElement["amount"] * -1,
                                category: arrayElement["category"],
                                name: arrayElement["name"],
                                selectedDate:
                                    (arrayElement["time"] as Timestamp)
                                        .toDate(),
                                editMode: true,
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
                        child: EnterScreen(),
                      );
                    },
                  ),
                );
              },
              //print(arrayElement["amount"].toString()),
              child: Dismissible(
                background: Container(
                  child: Icon(Icons.delete),
                  color: Colors.red,
                ),
                key: arrayElement["id"] != null
                    ? Key(arrayElement["id"])
                    : Key("one"),
                onDismissed: (DismissDirection direction) {
                  //_alertDialogFunction();
                  balanceDataProvider.removeSingleBalance(arrayElement["id"]);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      arrayElement["category"]
                          .substring(0,
                              Math.min<num>(3, arrayElement["category"].length))
                          .toUpperCase(),
                      style: Theme.of(context).textTheme.overline?.copyWith(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  title: Text(
                    arrayElement["name"],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    formatter
                        .format(
                          arrayElement["time"].toDate(),
                        )
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.overline,
                  ),
                  trailing: Text(
                    arrayElement["amount"].toStringAsFixed(2) + "€",
                    style: arrayElement["amount"] < 0
                        ? Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.error)
                        : Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      log("HomeScreenListView: " + balanceData[0]["Error"].toString());
    }
    _listview = ListView(children: list, padding: EdgeInsets.zero);
  }

  @override
  ListView get listview => _listview;

  _alertDialogFunction() {
    return AlertDialog(
      title: Text("Delete"),
      content: Text("Do you want to delete this transaction?"),
      actions: [],
    );
  }
}
