import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/homescreen_card_time_warp.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:provider/provider.dart';

class BackSide extends StatelessWidget {
  final num balance;
  final num income;
  final num expense;
  FlipCardController flipCardController;

  BackSide({
    Key? key,
    required this.flipCardController,
    required this.balance,
    required this.income,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);

    final String langCode = AppLocalizations.of(context)!.locale.languageCode;

    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);
    final DateTime now = DateTime.now();

    return GestureDetector(
      onTap: () {
        flipCardController.hint(
          duration: const Duration(
            milliseconds: 750,
          ),
          total: const Duration(
            seconds: 2,
          ),
        );
        // Fluttertoast.showToast(
        //   msg: AppLocalizations.of(context)!
        //       .translate('home_screen_card/home-screen-card-toast'),
        //   toastLength: Toast.LENGTH_SHORT,
        // );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
                  blurRadius: 16.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Material(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/v01-cubes-12.png"),
                      opacity: 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: proportionateScreenWidth(345),
                  height: proportionateScreenHeight(196),
                  // color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Center(
                                child: Text(
                                  "Kontostand",
                                  style: MediaQuery.of(context).size.height <
                                          650
                                      ? Theme.of(context).textTheme.headline5
                                      : Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    padding: const EdgeInsets.only(right: 16),
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      flipCardController.toggleCard();
                                    },
                                    icon: const Icon(
                                        Icons.flip_camera_android_rounded),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "seit Nutzungsbeginn",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      balance.toStringAsFixed(2),
                                      style: MediaQuery.of(context)
                                                  .size
                                                  .height <
                                              650
                                          ? Theme.of(context)
                                              .textTheme
                                              .headline2
                                              ?.copyWith(
                                                color: balance < 0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                    : createMaterialColor(
                                                        const Color(0xFF202020),
                                                      ),
                                              )
                                          : Theme.of(context)
                                              .textTheme
                                              .headline1
                                              ?.copyWith(
                                                color: balance < 0
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .error
                                                    : createMaterialColor(
                                                        const Color(0xFF505050),
                                                      ),
                                              ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '€',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 10,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_upward_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.translate(
                                          'home_screen_card/label-income',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline!
                                            .copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${income.toStringAsFixed(2)} €',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: algorithmProvider.currentShownMonth !=
                                        DateTime(
                                          now.year,
                                          now.month,
                                        )
                                    ? IconButton(
                                        icon: const Icon(Icons.today_rounded),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(64),
                                        onPressed: () {
                                          goToCurrentTime(algorithmProvider);
                                        },
                                      )

                                    // I am not proud of this.
                                    // If someone finds a better way of handling this without creating layout issues,
                                    // you're more than welcome to make it better. For now,
                                    // I only care that it works.

                                    : IconButton(
                                        icon: const Icon(Icons.error),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(0),
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {},
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.translate(
                                          'home_screen_card/label-expenses',
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline!
                                            .copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${expense.toStringAsFixed(2)} € ',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_downward_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
