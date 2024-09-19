// Home Screen Card Data - Model for storing data for the home screen card
//
// Author: NightmindOfficial
// Co-Author: n/a
//
import 'package:linum/core/stats/statistical_calculations.dart';

class HomeScreenCardData {
  // Front Side
  final num mtdBalance; //Month to date balance
  final num mtdIncome; // Month to date income
  final num mtdExpenses; // Month to date expenses

  //Back Side
  final num eomBalance; //End of Month projection of balance
  final num
      eomFutureSerialIncome; //End of Month outstanding serial income items (sum)
  final num
      eomFutureSerialExpenses; //End of Month outstanding serial expense items (sum)

  final num eomSerialIncome; //End of Month serial income items (sum)
  final num eomSerialExpenses; //End of Month serial expense items (sum)

  final num allTimeSumBalance;

  final int countSerialIncomes;
  final int countSerialCosts;

  final num tillBeginningOfMonthSumBalance;
  final num tillEndOfMonthSumBalance;

  const HomeScreenCardData({
    this.mtdBalance = 0,
    this.mtdExpenses = 0,
    this.mtdIncome = 0,
    this.eomBalance = 0,
    this.eomFutureSerialIncome = 0,
    this.eomFutureSerialExpenses = 0,
    this.eomSerialIncome = 0,
    this.eomSerialExpenses = 0,
    this.allTimeSumBalance = 0,
    this.countSerialIncomes = 0,
    this.countSerialCosts = 0,
    this.tillBeginningOfMonthSumBalance = 0,
    this.tillEndOfMonthSumBalance = 0,
  });

  factory HomeScreenCardData.fromStatistics(StatisticalCalculations statData) {
    return HomeScreenCardData(
      mtdIncome: statData.tillNowSumIncomes,
      mtdExpenses: -statData.tillNowSumCosts,
      mtdBalance: statData.tillNowSumBalance,
      eomBalance: statData.sumBalance,
      eomFutureSerialExpenses: statData.sumFutureSerialCosts,
      eomFutureSerialIncome: statData.sumFutureSerialIncomes,
      eomSerialExpenses: statData.sumSerialCosts,
      eomSerialIncome: statData.sumSerialIncomes,
      countSerialIncomes: statData.countSerialIncomes,
      countSerialCosts: statData.countSerialCosts,
      allTimeSumBalance: statData.allTimeSumBalance,
      tillBeginningOfMonthSumBalance: statData.tillBeginningOfMonthSumBalance,
      tillEndOfMonthSumBalance: statData.tillEndOfMonthSumBalance,
    );
  }
}
