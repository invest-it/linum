import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/homescreen_card_time_warp.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/widgets/home_screen/home_screen_functions.dart';
import 'package:provider/provider.dart';

class HomeScreenCardFront extends StatefulWidget {
  final HomeScreenCardData data;
  final FlipCardController flipCardController;
  const HomeScreenCardFront({Key? key, required this.data, required this.flipCardController}) : super(key: key);

  @override
  State<HomeScreenCardFront> createState() => _HomeScreenCardFrontState();
}

class _HomeScreenCardFrontState extends State<HomeScreenCardFront> {

  @override
  Widget build(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
    Provider.of<AlgorithmProvider>(context);
    final String langCode = AppLocalizations.of(context)!.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);
    final DateTime now = DateTime.now();

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        const int sensitivity = 1;
        if (details.primaryVelocity! > sensitivity) {
          //Right Swipe, going back in time
          goBackInTime(algorithmProvider);
        } else if (details.primaryVelocity! < -sensitivity) {
          goForwardInTime(algorithmProvider);
        }
      },
      onTap: () => onFlipCardTap(context, widget.flipCardController),
      onLongPress: () {
        goToCurrentTime(algorithmProvider);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                  Theme.of(context).colorScheme.onSurface.withAlpha(64),
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
                                  dateFormat.format(
                                    algorithmProvider.currentShownMonth,
                                  ),
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
                                      widget.flipCardController.toggleCard();
                                    },
                                    icon: const Icon(Icons.flip_camera_android_rounded),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            AppLocalizations.of(context)!.translate('home_screen_card/label-current-balance'),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              goBackInTime(algorithmProvider);
                            },
                            icon:
                            const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
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
                                      widget.data.balance.toStringAsFixed(2),
                                      style: getBalanceTextStyle(context, widget.data.balance),
                                    ),
                                  ),
                                ),
                                Text(
                                  '€',
                                  style:
                                  Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              goForwardInTime(algorithmProvider);
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
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
                                          .primary,
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
                                        AppLocalizations.of(context)!
                                            .translate(
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
                                        '${widget.data.income.toStringAsFixed(2)} €',
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate(
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
                                        '${widget.data.expense.toStringAsFixed(2)} € ',
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
                                      color:
                                      Theme.of(context).colorScheme.error,
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
