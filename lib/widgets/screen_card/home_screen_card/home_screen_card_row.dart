//  Home Screen Card Bottom Row - Bottom Part of the Home Screen displaying additional Metrics
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/currency_formatter.dart';
import 'package:linum/utilities/frontend/homescreen_card_time_warp.dart';
import 'package:linum/widgets/screen_card/card_widgets/home_screen_card_avatar.dart';
import 'package:provider/provider.dart';

class HomeScreenCardRow extends StatelessWidget {
  final Stream<HomeScreenCardData>? data;
  final HomeScreenCardAvatar upwardArrow;
  final HomeScreenCardAvatar downwardArrow;

  const HomeScreenCardRow({
    super.key,
    required this.data,
    required this.upwardArrow,
    required this.downwardArrow,
  });

  IconButton _buildGoToCurrentDateIcon(BuildContext context) {
    final AlgorithmProvider algorithmProvider =
        Provider.of<AlgorithmProvider>(context);
    final DateTime now = DateTime.now();

    return (algorithmProvider.currentShownMonth !=
            DateTime(now.year, now.month))
        ? IconButton(
            icon: const Icon(Icons.today_rounded),
            color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
            onPressed: () {
              goToCurrentTime(algorithmProvider);
            },
          )
        : IconButton(
            icon: const Icon(Icons.error),
            color: Theme.of(context).colorScheme.onSurface.withAlpha(0),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {},
          );
  }

  Expanded _buildIncomeExpensesInfo(
    BuildContext context,
    SizeGuideProvider sizeGuideProvider, {
    bool isIncome = false,
  }) {
    final settings = Provider.of<AccountSettingsProvider>(context);
    return Expanded(
      flex: 10,
      child: Row(
        mainAxisAlignment:
            isIncome ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isIncome) ...[
            upwardArrow,
            SizedBox(width: sizeGuideProvider.proportionateScreenWidth(10))
          ],
          Column(
            crossAxisAlignment:
                isIncome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Text(
                tr(
                  isIncome
                      ? 'home_screen_card.label-income'
                      : 'home_screen_card.label-expenses',
                ),
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(fontSize: 12),
              ),
              StreamBuilder<HomeScreenCardData>(
                stream: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      "--",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }
                  return Text(
                    CurrencyFormatter(context.locale,
                            symbol: settings.getStandardCurrency().symbol)
                        .format(
                      isIncome
                          ? snapshot.data?.mtdIncome ?? 0
                          : snapshot.data?.mtdExpenses ?? 0,
                    ),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ],
          ),
          if (!isIncome) ...[
            SizedBox(width: sizeGuideProvider.proportionateScreenWidth(10)),
            downwardArrow
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeGuideProvider =
        Provider.of<SizeGuideProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIncomeExpensesInfo(context, sizeGuideProvider, isIncome: true),
        Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _buildGoToCurrentDateIcon(context),
          ),
        ),
        _buildIncomeExpensesInfo(context, sizeGuideProvider)
      ],
    );
  }
}
