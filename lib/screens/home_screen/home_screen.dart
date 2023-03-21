//  Home Screen - The Home Screen of the App containing Statistical Info in the HomeScreenCard as well as a list of transactions in a specified month.
//
//  Author: SoTBurst, thebluebaronx, NightmindOfficial
//  Co-Author: damattl
/// PAGE INDEX 0
import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/components/screen_card/utils/flip_card_controller_extensions.dart';
import 'package:linum/common/utils/filters.dart';
import 'package:linum/common/utils/in_between_timestamps.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/widgets/home_screen_card.dart';
import 'package:linum/screens/home_screen/widgets/home_screen_listview.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED
/// Page Index: 0
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlipCardController? _flipCardController;

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
  }

  void resetAlgorithmProvider() {
    final AlgorithmService algorithmProvider =
        Provider.of<AlgorithmService>(context);

    if (algorithmProvider.state.filter == Filters.noFilter) {
      algorithmProvider.resetCurrentShownMonth();
      algorithmProvider.setCurrentFilterAlgorithm(
        Filters.inBetween(timestampsFromNow()),
      );
    }
  }

  bool showRepeatables = false;

  @override
  Widget build(BuildContext context) {
    final BalanceDataService balanceDataProvider =
        Provider.of<BalanceDataService>(context);

    final PinCodeService pinCodeProvider =
        Provider.of<PinCodeService>(context);

    resetAlgorithmProvider();
    // AlgorithmProvider algorithmProvider =
    //     Provider.of<AlgorithmProvider>(context, listen: false);

    // if (!algorithmProvider.currentFilter(
    //     {"time": Timestamp.fromDate(DateTime.now().add(Duration(days: 1)))})) {
    //   algorithmProvider.setCurrentFilterAlgorithm(
    //       AlgorithmProvider.olderThan(Timestamp.fromDate(DateTime.now())));
    // }

    return ScreenSkeleton(
      head: 'Home',
      isInverted: true,
      leadingAction: AppBarAction.fromPreset(DefaultAction.academy),
      actions: [
        if (pinCodeProvider.pinSet)
          (BuildContext context) => AppBarAction.fromParameters(
                icon: Icons.lock_rounded,
                ontap: () {
                  pinCodeProvider.resetSession();
                },
                key: const Key("pinRecallButton"),
              ),
        AppBarAction.fromPreset(DefaultAction.settings),
      ],
      screenCard: HomeScreenCard(
        controller: _flipCardController!,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 25, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: DropdownButton(
                        value: showRepeatables,
                        items: [
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Text(
                              tr('home_screen.label-recent-transactions'),
                            ),
                          ),
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Text(
                              tr('home_screen.label-active-serialcontracts'),
                            ),
                          ),
                        ],
                        underline: Container(),
                        elevation: 2,
                        style: Theme.of(context).textTheme.headline5,
                        onChanged: (value) {
                          setState(() {
                            showRepeatables = value! as bool;
                          });
                          if (value == true) {
                            _flipCardController?.turnToBack();
                          } else {
                            _flipCardController?.turnToFront();
                          }
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        getRouterDelegate().pushRoute(MainRoute.filter);
                      },
                      child: Text(
                        showRepeatables
                            ? tr('home_screen.button-show-all').toUpperCase()
                            : tr('home_screen.button-show-more').toUpperCase(),
                        style: Theme.of(context).textTheme.overline?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: ScrollConfiguration(
                    behavior: SilentScroll(),
                    child: showRepeatables
                        ? balanceDataProvider.fillListViewWithRepeatables(
                            HomeScreenListView(),
                            context: context,
                          )
                        : balanceDataProvider.fillListViewWithData(
                            HomeScreenListView(),
                            context: context,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
