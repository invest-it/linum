import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/screens/home_screen/components/home_screen_card/models/home_screen_card_data.dart';

extension ScreenCardDataExtensions on BalanceDataService {
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
