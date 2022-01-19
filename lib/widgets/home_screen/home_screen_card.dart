import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/statistic_calculations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/widgets/abstract/abstract_statistic_panel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreenCard extends StatelessWidget {
  final num balance;

  final num income;

  final num expense;

  const HomeScreenCard(
      {Key? key,
      required this.balance,
      required this.income,
      required this.expense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    DateFormat dateFormat = DateFormat('MMMM yyyy', 'de');

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        int sensitivity = 1;
        if (details.primaryVelocity! > sensitivity) {
          // Right Swipe, going back in time
          algorithmProvider.previousMonth();
          if (algorithmProvider.currentShownMonth.month ==
                  DateTime.now().month &&
              algorithmProvider.currentShownMonth.year == DateTime.now().year) {
            algorithmProvider
                .setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
              Timestamp.fromDate(DateTime(
                DateTime.now().year,
                DateTime.now().month,
              )),
              Timestamp.fromDate(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              )),
            ));
          } else {
            algorithmProvider
                .setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
              Timestamp.fromDate(
                algorithmProvider.currentShownMonth,
              ),
              Timestamp.fromDate(DateTime(
                algorithmProvider.currentShownMonth.year,
                algorithmProvider.currentShownMonth.month + 1,
              )),
            ));
          }
        } else if (details.primaryVelocity! < -sensitivity) {
          //Left Swipe, going forward in time
          algorithmProvider.nextMonth();
          if (algorithmProvider.currentShownMonth.month ==
                  DateTime.now().month &&
              algorithmProvider.currentShownMonth.year == DateTime.now().year) {
            algorithmProvider
                .setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
              Timestamp.fromDate(DateTime(
                DateTime.now().year,
                DateTime.now().month,
              )),
              Timestamp.fromDate(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              )),
            ));
          } else {
            algorithmProvider
                .setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
              Timestamp.fromDate(
                algorithmProvider.currentShownMonth,
              ),
              Timestamp.fromDate(DateTime(
                algorithmProvider.currentShownMonth.year,
                algorithmProvider.currentShownMonth.month + 1,
              )),
            ));
          }
        }
      },
      onTap: () {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!
              .translate('home_screen_card/home-screen-card-toast'),
          toastLength: Toast.LENGTH_SHORT,
        );
      },
      onDoubleTap: () {
        // Reset to current month
        algorithmProvider.resetCurrentShownMonth();
        algorithmProvider.setCurrentFilterAlgorithm(AlgorithmProvider.inBetween(
          Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
          )),
          Timestamp.fromDate(DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )),
        ));
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: proportionateScreenWidth(345),
              height: proportionateScreenHeight(196),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                            'home_screen_card/label-current-balance'),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        '< ' +
                            dateFormat
                                .format(algorithmProvider.currentShownMonth) +
                            ' >',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        balance.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text('\€', style: Theme.of(context).textTheme.bodyText1)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                      'home_screen_card/label-income'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(income.toStringAsFixed(2) + '\ €',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                      'home_screen_card/label-expenses'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(fontSize: 12),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  expense.toStringAsFixed(2) + ' \€ ',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenCardManager implements AbstractStatisticPanel {
  late HomeScreenCard _homeScreenCard;
  HomeScreenCardManager() {
    _homeScreenCard = HomeScreenCard(income: 0, expense: 0, balance: 0);
  }

  @override
  addStatisticData(StatisticsCalculations? statData) {
    if (statData != null) {
      num income = statData.sumIncomes;
      num expense = -(statData.sumCosts);
      num balance = statData.sumBalance;
      _homeScreenCard =
          HomeScreenCard(income: income, expense: expense, balance: balance);
    }
  }

  @override
  Widget get returnWidget => _homeScreenCard;
}
