import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/providers/balance_data_provider.dart';

extension ScreenCardDataExtensions on BalanceDataProvider {
  Stream<HomeScreenCardData>? getHomeScreenCardData() {
    final calculationsStream = getStatisticalCalculations();
    return calculationsStream?.asyncMap((statData) {
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
    });
  }
}
